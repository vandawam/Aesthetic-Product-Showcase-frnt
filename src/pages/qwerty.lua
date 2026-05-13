local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local TitansFolder = workspace:WaitForChild("Titans")
local POSTRemote = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Remotes"):WaitForChild("POST")
local GETRemote = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Remotes"):WaitForChild("GET")

-- Konfigurasi
getgenv().UltimateAutoFarm = true
local FlySpeed = 350
local AttackRange = 35
local EvasionHeight = 70 -- Jarak manuver ke atas setelah kill
local IgnoredTitans = {} -- Sistem Cooldown agar Titan yang tertinggal bisa dikejar lagi

-- ============================================================
-- 🛡️ SISTEM ANTI-STUCK & NOCLIP
-- ============================================================

local function SetNoclip(titan)
    for _, part in ipairs(titan:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
        end
    end
end

TitansFolder.ChildAdded:Connect(SetNoclip)
for _, t in ipairs(TitansFolder:GetChildren()) do SetNoclip(t) end

task.spawn(function()
    while getgenv().UltimateAutoFarm do
        local interface = LocalPlayer.PlayerGui:FindFirstChild("Interface")
        if interface and interface:FindFirstChild("Buttons") and interface.Buttons.Visible then
            POSTRemote:FireServer("Attacks", "Slash_Escape")
        end
        task.wait(0.1)
    end
end)

-- ============================================================
-- 🛠️ FUNGSI UTILITAS
-- ============================================================

local function AreBladesEmpty()
    local myChar = workspace.Characters:FindFirstChild(LocalPlayer.Name)
    local rig = myChar and myChar:FindFirstChild("Rig_" .. LocalPlayer.Name)
    local rightHand = rig and rig:FindFirstChild("RightHand")
    if rightHand then
        for i = 1, 7 do
            local blade = rightHand:FindFirstChild("Blade_" .. i)
            if blade and blade.Transparency < 1 then return false end
        end
    end
    return true
end

local function GetRemainingAmmo()
    local success, label = pcall(function() 
        return LocalPlayer.PlayerGui.Interface.HUD.Main.Top["7"].Blades.Sets 
    end)
    return success and tonumber(string.match(label.Text, "^(%d+)")) or 0
end

local function CheckAutoRetry()
    local rewards = LocalPlayer.PlayerGui.Interface:FindFirstChild("Rewards")
    if rewards and rewards.Visible then
        local qt = queue_on_teleport or (syn and syn.queue_on_teleport)
        if qt then qt([[loadstring(game:HttpGet("https://raw.githubusercontent.com/vandawam/Aesthetic-Product-Showcase-frnt/refs/heads/main/src/pages/qwerty.lua"))()]]) end
        GETRemote:InvokeServer("Functions", "Retry", "Add")
    end
end

-- ============================================================
-- ⚔️ LOGIKA UTAMA (PIERCING RAILGUN + HIT & RUN)
-- ============================================================
print("⚔️ Ultra-Smooth (Hit & Run + Cooldown Fix) Aktif!")

task.spawn(function()
    while getgenv().UltimateAutoFarm do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- 1. RELOAD CHECK
            if AreBladesEmpty() then
                hrp.Anchored = true
                if GetRemainingAmmo() > 0 then
                    GETRemote:InvokeServer("Blades", "Reload")
                else
                    local hq = workspace.Unclimbable.Props:FindFirstChild("HQ")
                    local refill = hq and hq:FindFirstChild("Refill", true)
                    if refill then
                        POSTRemote:FireServer("Attacks", "Reload", refill)
                        task.wait(0.5)
                        GETRemote:InvokeServer("Blades", "Reload")
                    end
                end
                task.wait(1.2)
                hrp.Anchored = false
            end

            -- 2. TARGETING DENGAN COOLDOWN
            local targetNape, targetTitan = nil, nil
            local distMin = math.huge
            local currentTime = tick()

            for _, titan in ipairs(TitansFolder:GetChildren()) do
                if titan.Parent == TitansFolder then
                    -- Abaikan Titan jika baru saja ditebas dalam 3 detik terakhir
                    if not IgnoredTitans[titan] or (currentTime - IgnoredTitans[titan] > 3) then
                        local nape = titan:FindFirstChild("Hitboxes") and titan.Hitboxes:FindFirstChild("Hit") and titan.Hitboxes.Hit:FindFirstChild("Nape")
                        if nape then
                            local d = (hrp.Position - nape.Position).Magnitude
                            if d < distMin then
                                distMin = d
                                targetNape = nape
                                targetTitan = titan
                            end
                        end
                    end
                end
            end

            -- 3. SMOOTH PIERCING
            if targetNape then
                local currentTweenActive = true
                task.delay(2.5, function() if currentTweenActive then hrp.Anchored = false end end)

                hrp.Anchored = true
                local startDist = (hrp.Position - targetNape.Position).Magnitude
                local targetPos = targetNape.CFrame * CFrame.new(0, 0, -15) 
                
                local flyTween = TweenService:Create(hrp, TweenInfo.new(startDist/FlySpeed, Enum.EasingStyle.Linear), {
                    CFrame = CFrame.lookAt(targetPos.Position, targetNape.Position)
                })
                
                flyTween:Play()
                
                local slashed = false
                while flyTween.PlaybackState == Enum.PlaybackState.Playing do
                    if not targetNape.Parent then break end
                    
                    local d = (hrp.Position - targetNape.Position).Magnitude
                    if d <= AttackRange and not slashed then
                        slashed = true
                        
                        task.spawn(function()
                            POSTRemote:FireServer("Attacks", "Slash", true)
                            POSTRemote:FireServer("Hitboxes", "Register", targetNape, 450.0, 0.25)
                            POSTRemote:FireServer("Attacks", "Slash", false)
                        end)
                        
                        -- Masukkan Titan ke daftar cooldown (Bukan blacklist permanen)
                        IgnoredTitans[targetTitan] = tick()
                        break 
                    end
                    task.wait()
                end
                
                currentTweenActive = false
                flyTween:Cancel()

                -- 🚀 MANUVER NAIK KE ATAS SETELAH SLASH
                if slashed then
                    local evadeTween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
                        CFrame = hrp.CFrame + Vector3.new(0, EvasionHeight, 0)
                    })
                    evadeTween:Play()
                    task.wait(0.3)
                end

                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.zero
            else
                CheckAutoRetry()
            end
        end
        task.wait(0.05)
    end
end)
