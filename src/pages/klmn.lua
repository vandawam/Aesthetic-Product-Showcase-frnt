local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local TitansFolder = workspace:WaitForChild("Titans")
local POSTRemote = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Remotes"):WaitForChild("POST")
local GETRemote = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Remotes"):WaitForChild("GET")

getgenv().UltimateAutoFarm = true

-- Fungsi mencari stasiun pengisian amunisi di Markas
local function FindRefillStation()
    local hq = workspace:FindFirstChild("Unclimbable") and workspace.Unclimbable:FindFirstChild("Props") and workspace.Unclimbable.Props:FindFirstChild("HQ")
    if hq then
        for _, v in ipairs(hq:GetDescendants()) do
            if v.Name == "Refill" then return v end
        end
    end
    local success, result = pcall(function() return workspace.Unclimbable.Props.HQ:GetChildren()[215].Refill end)
    return success and result or nil
end

-- Fungsi membaca jumlah amunisi dari UI
local function GetRemainingAmmo()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local path = {"Interface", "HUD", "Main", "Top", "7", "Blades", "Sets"}
    local target = playerGui
    
    for _, name in ipairs(path) do
        if target then target = target:FindFirstChild(name) else break end
    end
    
    if target and target:IsA("TextLabel") then
        local remaining = tonumber(string.match(target.Text, "^(%d+)"))
        return remaining or 0
    end
    return 0
end

-- Fungsi mengecek apakah pedang di tangan sudah habis (Transparan)
local function AreBladesEmpty()
    local myChar = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(LocalPlayer.Name)
    local rig = myChar and myChar:FindFirstChild("Rig_" .. LocalPlayer.Name)
    local rightHand = rig and rig:FindFirstChild("RightHand")
    
    if rightHand then
        for i = 1, 7 do
            local blade = rightHand:FindFirstChild("Blade_" .. i)
            if blade and blade:IsA("BasePart") and blade.Transparency < 1 then
                return false
            end
        end
    end
    return true 
end

-- Fungsi memantau UI Rewards untuk Auto-Retry
local function CheckAutoRetry()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local interface = playerGui and playerGui:FindFirstChild("Interface")
    local rewards = interface and interface:FindFirstChild("Rewards")
    
    if rewards and rewards.Visible then
        print("Game Selesai! Mencoba Retry otomatis dan menyuntikkan script re-execute...")
        
        -- Mendeteksi fungsi queue_on_teleport dari berbagai jenis eksekutor
        local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        
        if queueTeleport then
            queueTeleport([[
                loadstring(game:HttpGet("https://raw.githubusercontent.com/vandawam/Aesthetic-Product-Showcase-frnt/refs/heads/main/src/pages/klmn.lua"))()
            ]])
        else
            warn("Eksekutor kamu tidak mendukung queue_on_teleport. Auto-re-execute mungkin gagal.")
        end

        pcall(function()
            GETRemote:InvokeServer("Functions", "Retry", "Add")
        end)
        
        task.wait(2)
    end
end

print("Ultimate Auto-Farm AoT Aktif! Kill, Reload, Refill, dan Retry otomatis berjalan.")

task.spawn(function()
    while getgenv().UltimateAutoFarm do
        
        -- 1. CEK SELESAI GAME (RETRY)
        CheckAutoRetry()

        -- 2. LOGIKA RELOAD & REFILL
        if AreBladesEmpty() then
            local currentAmmo = GetRemainingAmmo()
            if currentAmmo > 0 then
                print("Reload pedang (Ammo: " .. currentAmmo .. ")")
                pcall(function() GETRemote:InvokeServer("Blades", "Reload") end)
            else
                print("Amunisi 0! Refill dari Markas...")
                local station = FindRefillStation()
                if station then
                    pcall(function() POSTRemote:FireServer("Attacks", "Reload", station) end)
                    task.wait(0.5)
                    pcall(function() GETRemote:InvokeServer("Blades", "Reload") end)
                end
            end
            task.wait(0.5)
        end

        -- 3. EKSEKUSI TITAN
        local titans = TitansFolder:GetChildren()
        if #titans > 0 then
            for _, titan in ipairs(titans) do
                if not getgenv().UltimateAutoFarm then break end
                
                local nape = titan:FindFirstChild("Hitboxes") and titan.Hitboxes:FindFirstChild("Hit") and titan.Hitboxes.Hit:FindFirstChild("Nape")
                
                if nape and nape:IsA("BasePart") then
                    pcall(function()
                        POSTRemote:FireServer("Attacks", "Slash", true)
                        POSTRemote:FireServer("Hitboxes", "Register", nape, 380.0, 0.25)
                        POSTRemote:FireServer("Attacks", "Slash", false)
                    end)
                    
                    if AreBladesEmpty() then break end 
                    task.wait(0.1) 
                end
            end
        end
        
        task.wait(0.5)
    end
end)

-- Cara mematikan:
-- getgenv().UltimateAutoFarm = false
