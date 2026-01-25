------------
-- services & variables
------------

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
-- [[ TAMBAHKAN INI ]]
local isScriptLoading = true -- Penanda script sedang loading

local cloneref = (cloneref or clonereference or function(instance) return instance end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

------------
-- library load
------------

local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    
    if ok then
        WindUI = result
    else 
        if game:GetService("RunService"):IsStudio() then
            -- Fallback studio logic
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
        end
    end
end

-- [[ CONFIG SYSTEM SETUP ]] --
local HttpService = game:GetService("HttpService")
local ConfigFolder = "ZuperMing_Fisch" -- Nama Folder di Workspace
local ConfigFile = ConfigFolder .. "/autoload.txt"

-- Table ini akan menampung semua UI yang mau di-save
-- Format: SaveElements["NamaSetting"] = ObjectUI
local SaveElements = {} 

-- Fungsi Helper untuk mendaftarkan UI
local function AddSave(name, element)
    SaveElements[name] = element
    return element
end

-- Buat Folder jika belum ada
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

------------
-- window setup
------------

WindUI.Services.minghubkeysystem = {
    Name = "MingHub Key System",
    Icon = "key", 
    
    Args = {}, -- Kosongkan jika tidak butuh argumen tambahan
    
    New = function() 
        -- Fungsi Validasi Key dengan HTTP POST
        function validateKey(inputKey)
            -- 1. Cek jika key kosong
            if not inputKey or inputKey == "" then
                return false, "Key tidak boleh kosong!" 
            end

            -- 2. Definisikan fungsi request (kompatibel dengan berbagai executor)
            local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
            
            if not httpRequest then
                return false, "Executor kamu tidak mendukung HTTP Request!"
            end

            local HttpService = game:GetService("HttpService")

            -- 3. Siapkan data yang akan dikirim ke website
            -- Biasanya key system butuh HWID juga, jadi saya tambahkan opsional
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local username = Player.Name
            local bodyData = {
                key = inputKey,
                username = username
            }

            -- 4. Kirim Request
            local success, response = pcall(function()
                return httpRequest({
                    Url = "https://superminghub.com/checkkey", -- Pastikan pakai HTTPS
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json" -- Wajib untuk API modern
                    },
                    Body = HttpService:JSONEncode(bodyData) -- Ubah table Lua ke JSON
                })
            end)

            -- 5. Cek Response dari Server
            if success and response then
                if response.StatusCode == 200 then
                    -- Coba baca balasan dari website
                    -- Asumsi: Website membalas JSON seperti {"valid": true} atau {"status": "success"}
                    local data = HttpService:JSONDecode(response.Body)
                    
                    -- SESUAIKAN LOGIKA DI BAWAH INI DENGAN RESPONSE WEBSITE KAMU
                    if data.valid == true or data.status == "success" or data.message == "Key Valid" then
                        return true, "Key Valid! Selamat datang."
                    else
                        return false, "Key Salah atau Expired!"
                    end
                else
                    return false, "Server Error: " .. tostring(response.StatusCode)
                end
            else
                return false, "Gagal terhubung ke server (Connection Error)"
            end
        end
        
        function copyLink()
            -- Ganti dengan link untuk mendapatkan key (Get Key)
            setclipboard("https://superminghub.com/getkey") 
        end
        
        return {
            Verify = validateKey,
            Copy = copyLink 
        }
    end
}

------------
-- loading sequence
------------

WindUI:Notify({
    Title = "Loading Script...",
    Content = "Sabaar ya bang",
    Duration = 3,
    Icon = "rbxassetid://84078385121142"
})
task.wait(3)

local Window = WindUI:CreateWindow({
    Title = "Fish It | Premium Script",
    Folder = "ZuperMing",
    Icon = "solar:crown-bold", -- Icon mahkota di header menu
    NewElements = true,
    HideSearchBar = false,
    Theme = "Sky",
    
    -- [[ CUSTOM LOGO TOMBOL BUKA ]]
    OpenButton = {nil

    },

    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },

    -- [[ KEY SYSTEM CONFIG ]]
    KeySystem = {
        Note = "Join Discord for Key!",
        API = {
            {
                Type = "minghubkeysystem", -- Pastikan type ini didukung oleh library key system kamu
                ServiceId = 27895,
                SuperId = 27895,
            },
        },
    },
})

Window:Tag({
    Title = "ZuperMing v1.17",
    Icon = "rbxassetid://84078385121142",
    Color = Color3.fromHex("#6A5ACD"),
    Border = true,
})

----------------------------
-- tab creator
----------------------------

local InfoTab = Window:Tab({
    Title = "Info",
    Icon = "solar:info-circle-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "solar:home-2-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local AutoTab = Window:Tab({
    Title = "Auto",
    Icon = "solar:play-circle-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local ShopTab = Window:Tab({
    Title = "Shop",
    Icon = "solar:cart-large-minimalistic-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local TeleportTab = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local EventTab = Window:Tab({
    Title = "Event",
    Icon = "solar:calendar-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local WebhookTab = Window:Tab({
    Title = "Webhook",
    Icon = "solar:bell-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local PerformanceTab = Window:Tab({
    Title = "Performance",
    Icon = "solar:bolt-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local ConfigTab = Window:Tab({
    Title = "Config",
    Icon = "solar:settings-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "solar:layers-minimalistic-bold",
    IconColor = Color3.fromHex("#E0E0E0"),
    IconShape = "Square",
    Border = true,
})

------------
-- tab info
------------

local function loadTabInfo()
    local InfoSection = InfoTab:Section({
        Title = "Script Information",
        Opened = true
    })

    InfoSection:Image({
        Title = "ZuperMing Logo",
        Image = "rbxassetid://137808493980662",
    })

    InfoSection:Paragraph({
        Title = "ZuperMing Premium v1.0",
        Content = "👑 Creator: Ming\n🎮 Game: Fish it\n✨ Status: UPDATED\n\nSelamat menikmati script ini!"
    })

    InfoSection:Button({
        Title = "Join Discord",
        Desc = "Klik untuk menyalin link",
        Icon = "brands-discord",
        Callback = function()
            setclipboard("https://discord.gg/ZuperMing")
            WindUI:Notify({ Title = "Discord", Content = "Link disalin!", Icon = "check" })
        end
    })
end

------------
-- tab main
------------

local function loadTabMain()
    ---------------------------------------------------
    -- ----- GLOBAL CONFIG & VARIABLES
    ---------------------------------------------------

    local Settings = {
        FishingMode = "Old Blatant",
        Active = false,
    }

    local BlatantConfig = {
        D_Charge = 0.007,
        D_Complete = 0.7, 
        D_Cancel = 0.3,
    }

    local InstantConfig = {
        CatchDelay = 0.3, -- Pure Input buat Instant
    }

    -- [TEMPLATE PRESETS]
    local BlatantPresets = {
        ["Custom"] = {Cast = nil, Catch = nil},
        ["11n Holy Trident [Ocean/Kohana]"] = {Cast = 0.128, Catch = 0.088},
        ["3n All Skin [All Map]"] = {Cast = 1.5, Catch = 0.7},
        ["7n Soul Scythe [All Map]"] = {Cast = 0.435, Catch = 0.321},
        ["11n Soul Scythe [Ocean/Kohana]"] = {Cast = 0.174, Catch = 0.288},
        ["5n Ele/Dm [Ocean/Kohana]"] = {Cast = 0.7, Catch = 0.3},
        ["5n Krampus [All Map]"] = {Cast = 0.72, Catch = 0.36},
    }

    -- [VARS KHUSUS LEGIT]
    local LegitState = {
        Enabled = false, 
        Thread = nil, 
        BV = nil, 
        BAV = nil
    }
    
    -- Services
    local vim = game:GetService("VirtualInputManager")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local Camera = Workspace.CurrentCamera
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Debris = game:GetService("Debris") 
    
    -- [DEPENDENCIES]
    local repilion = require(ReplicatedStorage.Packages.Replion)
    local FishingController = require(ReplicatedStorage.Controllers.FishingController)
    local AnimController = require(ReplicatedStorage.Controllers.AnimationController)

    -- Variables for Hook
    local MySpyConnection = nil
    local GameConnections = {}
    local fishCaughtDetected = false

    ---------------------------------------------------
    -- ----- REMOTE CACHING
    ---------------------------------------------------
    local NetPath = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
    local remoteCache = {}

    local function cacheRemote(kind, name)
        local key = kind .. "/" .. name
        local r = NetPath:FindFirstChild(key)
        remoteCache[key] = r
        return r
    end

    cacheRemote("RE", "EquipToolFromHotbar")
    cacheRemote("RE", "FishingCompleted")
    cacheRemote("RF", "ChargeFishingRod")
    cacheRemote("RF", "RequestFishingMinigameStarted")
    cacheRemote("RF", "CancelFishingInputs")
    cacheRemote("RF", "UpdateAutoFishingState")
    cacheRemote("RE", "ReplicateTextEffect")

    local function fireCached(name, args)
        local r = remoteCache["RE/" .. name]
        if r then pcall(function() r:FireServer(unpack(args or {})) end) end
    end
    
    local function invokeCached(name, args)
        local r = remoteCache["RF/" .. name]
        if r then pcall(function() r:InvokeServer(unpack(args or {})) end) end
    end

    ---------------------------------------------------
    -- ----- STANDARD EVENTS
    ---------------------------------------------------
    local Events = {
        Fishing     = NetPath:WaitForChild("RE/FishingCompleted"),
        Charge      = NetPath:WaitForChild("RF/ChargeFishingRod"),
        Minigame    = NetPath:WaitForChild("RF/RequestFishingMinigameStarted"),
        Equip       = NetPath:WaitForChild("RE/EquipToolFromHotbar"),
        Unequip     = NetPath:WaitForChild("RE/UnequipToolFromHotbar"),
        Cancel      = NetPath:WaitForChild("RF/CancelFishingInputs"),
        Exclaim     = NetPath:WaitForChild("RE/ReplicateTextEffect"),
        UpdateState = NetPath:WaitForChild("RF/UpdateAutoFishingState")
    }

    local TargetRemote = NetPath:WaitForChild("RE/ObtainedNewFishNotification")

    ---------------------------------------------------
    -- ----- UTILITY FUNCTIONS
    ---------------------------------------------------

    local function SafeCall(func)
        task.spawn(function() pcall(func) end)
    end

    local function StartExclaimListener()
        if _G.ExclaimConn then _G.ExclaimConn:Disconnect() end
        _G.ExclaimConn = Events.Exclaim.OnClientEvent:Connect(function(EventData)
            if not Settings.Active then return end
        end)
    end

    -- [AUTO HIDE NOTIF]
    local function ToggleNotifKiller(state)
        if getgenv().UIKillerConnection then
            getgenv().UIKillerConnection:Disconnect()
            getgenv().UIKillerConnection = nil
        end
        if not state then return end 

        local function vanishContainer(textLabel)
            local currentObject = textLabel
            for i = 1, 10 do
                local parent = currentObject.Parent
                if not parent or parent:IsA("ScreenGui") then break end
                local grandParent = parent.Parent
                if grandParent then
                    local layout = grandParent:FindFirstChildWhichIsA("UIListLayout") or grandParent:FindFirstChildWhichIsA("UIGridLayout")
                    if layout then
                        parent.Visible = false
                        parent.BackgroundTransparency = 1
                        parent.Size = UDim2.new(0, 0, 0, 0)
                        Debris:AddItem(parent, 0)
                        return
                    end
                end
                currentObject = parent
            end
            textLabel.Visible = false
            textLabel.TextTransparency = 1
        end

        local function processLabel(label)
            local function checkText()
                if not label or not label.Parent then return end
                local text = label.Text:lower()
                if text:find("auto fishing") then
                    if text:find("enabled") or text:find("disabled") then
                        if label:GetAttribute("KillConnection") then return end
                        label:SetAttribute("KillConnection", true)
                        vanishContainer(label)
                    end
                end
            end
            checkText()
            local conn
            conn = label:GetPropertyChangedSignal("Text"):Connect(function()
                if not label or not label.Parent then 
                    if conn then conn:Disconnect() end
                    return 
                end
                checkText()
            end)
        end

        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") then processLabel(v) end
        end

        getgenv().UIKillerConnection = LocalPlayer.PlayerGui.DescendantAdded:Connect(function(v)
            if v:IsA("TextLabel") then processLabel(v) end
        end)
    end

    -- [LEGIT HELPERS]
    local function freezeCharacter()
        local char = LocalPlayer.Character
        local rp = char and char:FindFirstChild("HumanoidRootPart")
        if not rp then return end
        if LegitState.BV then LegitState.BV:Destroy() end
        if LegitState.BAV then LegitState.BAV:Destroy() end
        local bv = Instance.new("BodyVelocity")
        bv.Velocity, bv.MaxForce, bv.Parent = Vector3.new(0, 0, 0), Vector3.new(40000, 40000, 40000), rp
        LegitState.BV = bv
        local bav = Instance.new("BodyAngularVelocity")
        bav.AngularVelocity, bav.MaxTorque, bav.Parent = Vector3.new(0, 0, 0), Vector3.new(40000, 40000, 40000), rp
        LegitState.BAV = bav
    end

    local function unfreezeCharacter()
        if LegitState.BV then LegitState.BV:Destroy() LegitState.BV = nil end
        if LegitState.BAV then LegitState.BAV:Destroy() LegitState.BAV = nil end
    end

    local function StartHook()
        if MySpyConnection then return end
        for _, conn in pairs(getconnections(TargetRemote.OnClientEvent)) do
            table.insert(GameConnections, conn)
            conn:Disable()
        end
        MySpyConnection = TargetRemote.OnClientEvent:Connect(function(...) fishCaughtDetected = true end)
    end

    local function StopHook()
        if MySpyConnection then MySpyConnection:Disconnect() MySpyConnection = nil end
        for _, conn in pairs(GameConnections) do conn:Enable() end
        GameConnections = {}
    end

    local function GetWaterHeight()
        local RayParams = RaycastParams.new()
        RayParams.FilterType = Enum.RaycastFilterType.Exclude
        RayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        RayParams.IgnoreWater = false 
        local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local RayInfo = Camera:ViewportPointToRay(Center.X, Center.Y)
        local Result = Workspace:Raycast(RayInfo.Origin, RayInfo.Direction * 1000, RayParams)
        if Result and (Result.Instance.Name == "Water" or Result.Material == Enum.Material.Water) then
            return Result.Position.Y
        end
        return nil
    end

    ---------------------------------------------------
    -- ----- FISHING LOOPS
    ---------------------------------------------------

    -- [LEGIT LOOP V4]
    local function StartLegitLoop()
        task.spawn(function()
            if Events.Equip then pcall(function() Events.Equip:FireServer(1) end) end
            
            while Settings.Active and Settings.FishingMode == "Legit" do
                task.wait() 
                local Character = LocalPlayer.Character
                if not Character then continue end
                
                local activeMinigame = FishingController:GetCurrentGUID()
                if activeMinigame then
                    FishingController:RequestFishingMinigameClick()
                    task.wait(0.1)
                else
                    if not FishingController:OnCooldown() then
                        local ChargeGui = LocalPlayer.PlayerGui:FindFirstChild("Charge")
                        local IsCharging = ChargeGui and ChargeGui.Enabled
                        if not IsCharging then
                            local CenterPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            FishingController:RequestChargeFishingRod(CenterPos, false)
                            task.wait(0.1) 
                        else
                            local currentPower = FishingController:_getPower()
                            if currentPower >= 0.91 then 
                                local WaterY = GetWaterHeight() or 1.22232
                                if WaterY then
                                    local ServerTime = Workspace:GetServerTimeNow()
                                    if LocalPlayer.PlayerGui:FindFirstChild("Charge") then
                                        LocalPlayer.PlayerGui.Charge.Enabled = false
                                    end
                                    local Success, MinigameData = Events.Minigame:InvokeServer(WaterY, 1.0, ServerTime)
                                    if Success and MinigameData then
                                        FishingController:FishingRodStarted(MinigameData)
                                        FishingController:UpdateChargeState(nil)
                                        _G.confirmFishingInput = nil
                                        if AnimController then AnimController:StopAnimation("StartRodCharge") end
                                    end
                                    task.wait(0.3)
                                else
                                    FishingController:RequestClientStopFishing(true)
                                end
                            end
                        end
                    end
                end
            end
            FishingController:RequestClientStopFishing(true)
        end)
    end

    -- [NEW BLATANT LOOP - With UpdateState]
    local function StartNewBlatantLoop()
        task.spawn(function()
            while Settings.Active and Settings.FishingMode == "New Blatant" do
                SafeCall(function() Events.UpdateState:InvokeServer(true) end)
                local t1 = tick()
                SafeCall(function() Events.Charge:InvokeServer({ [1] = t1 }) end)
                task.wait(BlatantConfig.D_Charge)
                local t2 = tick()
                SafeCall(function() Events.Minigame:InvokeServer(1, 0, t2) end)
                SafeCall(function() Events.UpdateState:InvokeServer(false) end)
                
                task.wait(BlatantConfig.D_Complete)
                if not Settings.Active then break end
                SafeCall(function() Events.Fishing:FireServer() end)
                task.wait(BlatantConfig.D_Cancel)
                if not Settings.Active then break end
                SafeCall(function() Events.Cancel:InvokeServer() end)
            end
        end)
    end

    -- [OLD BLATANT LOOP - Raw]
    local function StartOldBlatantLoop()
        task.spawn(function()
            while Settings.Active and Settings.FishingMode == "Old Blatant" do
                local t1 = tick()
                SafeCall(function() Events.Charge:InvokeServer({ [1] = t1 }) end)
                task.wait(BlatantConfig.D_Charge)
                local t2 = tick()
                SafeCall(function() Events.Minigame:InvokeServer(1, 0, t2) end)
                
                task.wait(BlatantConfig.D_Complete)
                if not Settings.Active then break end
                SafeCall(function() Events.Fishing:FireServer() end)
                task.wait(BlatantConfig.D_Cancel)
                if not Settings.Active then break end
                SafeCall(function() Events.Cancel:InvokeServer() end)
            end
        end)
    end

    -- [INSTANT LOOP - CLASSIC RAW V1]
    -- Tanpa UpdateState, Hanya pakai Catch Delay
    local function StartInstantLoop()
        task.spawn(function()
            while Settings.Active and Settings.FishingMode == "Instant Fishing" do
                pcall(function()
                    Events.Cancel:InvokeServer()
                    task.wait(0.05)
                    Events.Charge:InvokeServer(0)
                    Events.Minigame:InvokeServer(0, 0, 0)
                    
                    -- HANYA PAKE CATCH DELAY
                    task.wait(InstantConfig.CatchDelay) 
                    
                    if not Settings.Active then return end
                    Events.Fishing:FireServer()
                    task.wait(0.1)
                    Events.Cancel:InvokeServer()
                end)
                -- Tambahan buffer dikit biar gak crash
                task.wait(InstantConfig.CatchDelay + 0.1)
            end
        end)
    end

    if not _G.BlatantV2MinigameListener then
        _G.BlatantV2MinigameListener = NetPath["RE/FishingMinigameChanged"].OnClientEvent:Connect(function()
            if Settings.Active and (Settings.FishingMode == "New Blatant" or Settings.FishingMode == "Old Blatant") then
                task.spawn(function()
                    task.wait(BlatantConfig.D_Complete)
                    SafeCall(function() Events.Fishing:FireServer() end)
                    task.wait(BlatantConfig.D_Cancel)
                    SafeCall(function() Events.Cancel:InvokeServer() end)
                end)
            end
        end)
    end

    ---------------------------------------------------
    -- ----- AUTO FISHING SECTION UI
    ---------------------------------------------------

    local FishingSection = MainTab:Section({
        Title = "Auto Fishing",
        Tooltip = "Pilih mode dan aktifkan fishing",
        Opened = true 
    })

    -- [INPUT BOXES]
    local CastInput = AddSave("CastDelayInput", FishingSection:Input({
        Title = "Cast Delay",
        Desc = "Claim Time (Blatant Only)",
        Placeholder = tostring(BlatantConfig.D_Complete),
        Callback = function(value)
            local num = tonumber(value)
            if num then BlatantConfig.D_Complete = num end
        end
    }))

    local CatchInput = AddSave("CatchDelayInput", FishingSection:Input({
        Title = "Catch Delay",
        Desc = "Reel Time (Blatant & Instant)",
        Placeholder = tostring(BlatantConfig.D_Cancel),
        Callback = function(value)
            local num = tonumber(value)
            if num then
                BlatantConfig.D_Cancel = num
                InstantConfig.CatchDelay = num -- Update Instant juga
            end
        end
    }))

    -- [UPDATED DROPDOWN]
    AddSave("FishingModeDropdown", FishingSection:Dropdown({
        Title = "Fishing Mode",
        Desc = "Pilih mode auto fishing",
        Multi = false,
        Value = "Old Blatant",
        Values = {"New Blatant", "Old Blatant", "Instant Fishing", "Legit"},
        Callback = function(selected)
            Settings.FishingMode = selected
            if not isScriptLoading then
                WindUI:Notify({ Title = "Mode Changed", Content = "Mode: " .. selected, Duration = 2, Icon = "info" })
            end
        end
    }))

    -- [BLATANT TEMPLATE]
    AddSave("BlatantTemplateDropdown", FishingSection:Dropdown({
        Title = "Blatant Template",
        Desc = "Pilih settingan delay otomatis",
        Multi = false,
        Value = "Custom",
        Values = {"Custom", "3n All Skin [All Map]", "11n Holy Trident [Ocean/Kohana]", "5n Ele/Dm [Ocean/Kohana]", "11n Soul Scythe [Ocean/Kohana]", "7n Soul Scythe [All Map]", "5n Krampus [All Map]"}, 
        Callback = function(selected)
            local preset = BlatantPresets[selected]
            if preset and preset.Cast and preset.Catch then
                BlatantConfig.D_Complete = preset.Cast
                BlatantConfig.D_Cancel = preset.Catch
                
                if CastInput and CastInput.Set then CastInput:Set(tostring(preset.Cast)) end
                if CatchInput and CatchInput.Set then CatchInput:Set(tostring(preset.Catch)) end
                
                if not isScriptLoading then
                    WindUI:Notify({
                        Title = "Template Loaded",
                        Content = selected .. " (Cast:" .. preset.Cast .. ", Catch:" .. preset.Catch .. ")",
                        Duration = 2,
                        Icon = "settings"
                    })
                end
            end
        end
    }))

    -- [[ AUTO EQUIP ROD - SIMPLE LOOP ]]
    AddSave("AutoEquipRodToggle", FishingSection:Toggle({
        Title = "Auto Equip Rod",
        Desc = "Loop equip rod (Slot 1)",
        Value = false,
        Callback = function(Value)
            _G.AutoEquipActive = Value
            if Value then
                task.spawn(function()
                    while _G.AutoEquipActive do
                        pcall(function()
                            if Events.Equip then Events.Equip:FireServer(1) end
                        end)
                        task.wait(1) 
                    end
                end)
            else
                print("[AutoEquip] Stopped")
            end
        end
    }))

    -- [[ AUTO FISHING ENABLE + AUTO HIDE NOTIF ]]
    AddSave("AutoFishingToggle", FishingSection:Toggle({
        Title = "Enable Auto Fishing",
        Desc = "Aktifkan mode yang dipilih",
        Value = false,
        Callback = function(state)
            Settings.Active = state
            
            if state then
                if not isScriptLoading then
                    WindUI:Notify({ Title = "ZuperMing", Content = Settings.FishingMode .. " Aktif! 🎣", Duration = 2, Icon = "check" })
                end
                
                -- [[ AUTO HIDE (NEW BLATANT / INSTANT ONLY) ]]
                if Settings.FishingMode == "New Blatant" or Settings.FishingMode == "Instant Fishing" then
                    ToggleNotifKiller(true) 
                else
                    ToggleNotifKiller(false) 
                end

                if Settings.FishingMode == "Legit" then
                    StartHook()
                    freezeCharacter()
                    pcall(function() Events.Equip:FireServer(1) end)
                    task.wait(0.5)
                    if not LegitState.Thread then
                        LegitState.Thread = task.spawn(StartLegitLoop)
                    end
                else
                    StartExclaimListener()
                    task.spawn(function()
                        pcall(function() Events.Cancel:InvokeServer() end)
                        task.wait(0.2)
                        pcall(function() Events.Equip:FireServer(1) end)
                        task.wait(0.2)
                        
                        if Settings.FishingMode == "New Blatant" then
                            StartNewBlatantLoop()
                        elseif Settings.FishingMode == "Old Blatant" then
                            StartOldBlatantLoop()
                        elseif Settings.FishingMode == "Instant Fishing" then
                            StartInstantLoop()
                        end
                    end)
                end
            else
                if not isScriptLoading then
                    WindUI:Notify({ Title = "Farm Stopped", Content = "Auto fishing dihentikan", Duration = 3, Icon = "info" })
                end
                
                -- [[ MATIKAN HIDE ]]
                ToggleNotifKiller(false) 
                
                if _G.ExclaimConn then _G.ExclaimConn:Disconnect() end
                pcall(function() Events.Cancel:InvokeServer() end)
                pcall(function() Events.Unequip:FireServer() end)
                
                StopHook()
                unfreezeCharacter()
                if LegitState.Thread then
                    task.cancel(LegitState.Thread)
                    LegitState.Thread = nil
                end
                
                local FishingController = require(ReplicatedStorage.Controllers.FishingController)
                FishingController:RequestClientStopFishing(true)
            end
        end
    }))


    FishingSection:Space()

    -- Fix Rod Button (TIDAK PERLU ADDSAVE)
    FishingSection:Button({
        Title = "Fix Rod",
        Desc = "Fix kalau rod bug, tidak bisa ganti rod/skin",
        Callback = function()
            pcall(function()
                Events.Cancel:InvokeServer()
                Events.Unequip:FireServer()
            end)
            WindUI:Notify({ Title = "Fix Rod", Content = "Rod telah di-fix!", Duration = 2, Icon = "check" })
        end
    })

    -- [[ FISHING FILTER SECTION ]] --
local FilterSection = MainTab:Section({ 
    Title = "Fishing Filter (Auto Skip)", 
    Opened = true 
})

-- Variables
local SkipConfig = {
    Active = false,
    Rarities = {} -- Format: { ["Common"] = true, ["Uncommon"] = false }
}
local SkipConnection = nil

-- Data Warna Rarity (Sesuai Logic Kamu)
local RarityColors = {
    ["Common"]    = Color3.new(1, 0.980392, 0.964706),
    ["Uncommon"]  = Color3.new(0.764706, 1, 0.333333),
    ["Rare"]      = Color3.new(0.333333, 0.635294, 1),
    ["Epic"]      = Color3.new(0.698039, 0.447059, 0.968627),
    ["Legendary"] = Color3.new(1, 0.721569, 0.164706),
    ["Mythic"]    = Color3.new(1, 0.0941176, 0.0941176),
}

-- Logic Utama
local function OnTextEffect(argTable)
    if not SkipConfig.Active then return end
    if not argTable or not argTable.TextData then return end
    
    local data = argTable.TextData
    local char = LocalPlayer.Character
    if not char then return end

    -- Pastikan effect muncul di karakter kita sendiri
    if not data.AttachTo or not data.AttachTo:IsDescendantOf(char) then
        return 
    end

    -- Cek apakah effect adalah tanda seru "!" (Exclaim)
    if data.Text ~= "!" or data.EffectType ~= "Exclaim" then return end

    -- Fungsi Deteksi Warna
    local function GetRarityFromColor()
        local colorSeq = data.TextColor
        if typeof(colorSeq) ~= "ColorSequence" then return nil end
        
        -- Ambil warna utama
        local mainColor = colorSeq.Keypoints[1].Value

        for name, color in pairs(RarityColors) do
            -- Hitung selisih warna (Delta RGB)
            local diff = math.abs(mainColor.R - color.R) + 
                         math.abs(mainColor.G - color.G) + 
                         math.abs(mainColor.B - color.B)
            
            -- Toleransi warna 0.05
            if diff < 0.05 then return name end
        end
        return nil
    end

    -- Eksekusi Skip
    local detectedRarity = GetRarityFromColor()
    
    if detectedRarity and SkipConfig.Rarities[detectedRarity] then
        -- Spam Cancel biar pasti ke-skip
        task.spawn(function()
            for i = 1, 3 do
                pcall(function() Events.Cancel:InvokeServer() end)
                task.wait()
            end
            
            -- Notif kecil (Optional, bisa dihapus kalau ganggu)
            if not isScriptLoading then
                -- WindUI:Notify({Title="Skipped", Content=detectedRarity.." Fish", Duration=1})
            end
        end)
    end
end

-- Toggle Connection
local function ToggleSkipListener(state)
    if SkipConnection then SkipConnection:Disconnect() SkipConnection = nil end
    if state then
        SkipConnection = Events.Exclaim.OnClientEvent:Connect(OnTextEffect)
    end
end

-- [[ UI ELEMENTS ]] --

AddSave("SkipRarityDropdown", FilterSection:Dropdown({
    Title = "Select Rarity to Skip",
    Desc = "Ikan dengan rarity ini akan di-skip otomatis",
    Values = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"},
    Multi = true,
    Value = {"Common", "Uncommon"}, -- Default skip sampah
    Callback = function(val)
        -- Convert Array WindUI {"Common", "Rare"} -> Dictionary {["Common"]=true, ["Rare"]=true}
        local newMap = {}
        for _, v in pairs(val) do
            newMap[v] = true
        end
        SkipConfig.Rarities = newMap
    end
}))

AddSave("SkipRarityToggle", FilterSection:Toggle({
    Title = "Enable Auto Skip",
    Desc = "Otomatis cancel fishing jika rarity terdeteksi",
    Value = false,
    Callback = function(val)
        SkipConfig.Active = val
        ToggleSkipListener(val)
        
        if val and not isScriptLoading then
            WindUI:Notify({Title="Auto Skip", Content="Active", Icon="check"})
        end
    end
}))

end
------------
-- tab auto
------------

local function loadTabAuto()

    -- [[ 1. AUTO SELL (LEADERSTATS METHOD) ]]
    local SellSection = AutoTab:Section({ Title = "Auto Sell", Opened = true })

    -- Config Variable (Wajib ada di atas)
    local AutoSellConfig = { 
        Enabled = false, 
        Delay = 1, 
        MinCount = 0 
    }

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    -- [[ WRAPPED WITH ADDSAVE ]] --

    AddSave("AutoSellToggle", SellSection:Toggle({
        Title = "Auto Sell All",
        Desc = "Jual otomatis (By Count / Time)",
        Value = false,
        Callback = function(state)
            AutoSellConfig.Enabled = state
            
            if state then
                if not isScriptLoading then 
                    WindUI:Notify({ Title = "Auto Sell", Content = "Aktif", Duration = 2 }) 
                end
                
                task.spawn(function()
                    -- Cari Leaderstats dulu
                    local leaderstats = LocalPlayer:WaitForChild("leaderstats", 10)
                    local caughtStat = leaderstats and leaderstats:WaitForChild("Caught", 10)
                    
                    -- Titik awal hitungan
                    local startCaught = 0
                    if caughtStat then startCaught = caughtStat.Value end
                    
                    while AutoSellConfig.Enabled do
                        local shouldSell = false
                        
                        if AutoSellConfig.MinCount > 0 then
                            -- [MODE COUNT]
                            if caughtStat then
                                local currentCaught = caughtStat.Value
                                local gained = currentCaught - startCaught 
                                
                                if gained >= AutoSellConfig.MinCount then
                                    shouldSell = true
                                    WindUI:Notify({ 
                                        Title = "Auto Sell", 
                                        Content = "Terkumpul " .. gained .. " ikan. Menjual...", 
                                        Icon = "money-bill-wave" 
                                    })
                                end
                            end
                        else
                            -- [MODE TIME]
                            shouldSell = true
                        end
                        
                        if shouldSell then
                            pcall(function() 
                                local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
                                Net["RF/SellAllItems"]:InvokeServer() 
                            end)
                            
                            -- Reset titik awal setelah jual
                            if caughtStat then startCaught = caughtStat.Value end
                        end
                        
                        -- Logic Delay Loop
                        if AutoSellConfig.MinCount > 0 then
                            task.wait(1) 
                        else
                            task.wait(AutoSellConfig.Delay * 60) 
                        end
                    end
                end)
            else
                if not isScriptLoading then 
                    WindUI:Notify({ Title = "Auto Sell", Content = "Mati", Duration = 2 }) 
                end
            end
        end
    }))

    AddSave("SellCountInput", SellSection:Input({
        Title = "Sell Count Target",
        Desc = "Jual setelah menangkap X ikan baru (0 = Mode Waktu)",
        Placeholder = "Contoh: 50",
        Callback = function(t) 
            local n = tonumber(t) 
            if n then 
                AutoSellConfig.MinCount = n 
                if n > 0 then
                    WindUI:Notify({ Title = "Setting", Content = "Akan jual setiap " .. n .. " ikan", Duration = 2 })
                else
                    WindUI:Notify({ Title = "Setting", Content = "Mode Waktu Aktif", Duration = 2 })
                end
            end 
        end
    }))

    AddSave("SellDelayInput", SellSection:Input({
        Title = "Sell Delay (Menit)",
        Desc = "Jeda waktu jual (Hanya aktif jika Count Target = 0)",
        Placeholder = "1",
        Callback = function(t) 
            local n = tonumber(t) 
            if n then AutoSellConfig.Delay = n end 
        end
    }))

        -- [[ 2. AUTO ENCHANT ROD (NEW) ]]
    local EnchantSection = AutoTab:Section({ Title = "Auto Enchant", Opened = true })

    -- Config & Variables
    local EnchantConfig = {
        Active = false,
        SelectedStone = "Enchant Stone",
        TargetEnchant = "Big Hunter I"
    }
    local EnchantThread = nil

    -- ID Database
    local StoneIDs = {
        ["Enchant Stone"] = 10,
        ["Evolved Enchant Stone"] = 558, 
        ["Transcendent Stone"] = 246
    }

    local EnchantIDs = {
        ["Big Hunter I"] = 3, ["Cursed I"] = 12, ["Empowered I"] = 9, ["Fairy Hunter I"] = 18,
        ["Glistening I"] = 1, ["Gold Digger I"] = 4, ["Leprechaun I"] = 5, ["Leprechaun II"] = 6,
        ["Mutation Hunter I"] = 7, ["Mutation Hunter II"] = 14, ["Mutation Hunter III"] = 22,
        ["Perfection"] = 15, ["Prismatic I"] = 13, ["Reeler I"] = 2, ["Reeler II"] = 21,
        ["SECRET Hunter"] = 16, ["Shark Hunter"] = 20, ["Stargazer I"] = 8, ["Stargazer II"] = 17,
        ["Stormhunter I"] = 11, ["Stormhunter II"] = 19, ["XPerienced I"] = 10,
        -- Tambahan umum (jika perlu)
        ["Steady I"] = 24, ["Lucky I"] = 25, ["Divine I"] = 26
    }

    -- Helpers
    local function getStoneUUID(targetId)
        local Replion = require(ReplicatedStorage.Packages.Replion)
        local playerData = Replion.Client:WaitReplion("Data", 5)
        if not playerData then return nil end
                
        local inventory = playerData:GetExpect("Inventory")
        if not inventory or not inventory.Items then return nil end

        for _, invItem in pairs(inventory.Items) do
            if invItem.Id == targetId then
                return invItem.UUID
            end
        end
        return nil
    end

    local function AutoEnchantLogic()
        local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
        local EquipRemote = Net["RE/EquipItem"]
        local HotbarRemote = Net["RE/EquipToolFromHotbar"]
        local RollRemote = Net["RE/RollEnchant"]
        
        -- Remote Altar
        local Altar1 = Net["RE/ActivateEnchantingAltar"] -- Biasa
        local Altar2 = Net["RE/ActivateSecondEnchantingAltar"] -- Transcendent/Deep

        while EnchantConfig.Active do
            -- 1. Cari Batu di Inventory
            local targetStoneId = StoneIDs[EnchantConfig.SelectedStone]
            local stoneUUID = getStoneUUID(targetStoneId)

            if not stoneUUID then
                WindUI:Notify({Title="Auto Enchant", Content="Batu " .. EnchantConfig.SelectedStone .. " Habis!", Icon="alert-circle"})
                EnchantConfig.Active = false
                -- Matikan toggle di UI secara visual (opsional, butuh akses object toggle)
                break
            end

            -- 2. Teleport ke Altar
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if EnchantConfig.SelectedStone == "Transcendent Stone" then
                    -- Altar 2 (Desolate Deep)
                    char.HumanoidRootPart.CFrame = CFrame.new(1478.03, 130.71, -613.82)
                else
                    -- Altar 1 (Vertigo)
                    char.HumanoidRootPart.CFrame = CFrame.new(3256.83, -1300.65, 1391.13)
                end
            end
            task.wait(1)

            -- 3. Equip Batu
            EquipRemote:FireServer(stoneUUID, "Enchant Stones")
            task.wait(0.5)
            
            -- Cari slot hotbar batu yang baru di-equip
            local Replion = require(ReplicatedStorage.Packages.Replion)
            local data = Replion.Client:WaitReplion("Data", 5)
            local assignedSlot = nil
            local sTime = tick()
            
            repeat
                local equipped = data:Get("EquippedItems")
                if equipped then
                    for slot, uuid in pairs(equipped) do
                        if uuid == stoneUUID then assignedSlot = tonumber(slot) break end
                    end
                end
                task.wait(0.1)
            until assignedSlot or (tick() - sTime > 3)

            if assignedSlot then
                HotbarRemote:FireServer(assignedSlot)
                task.wait(0.5)
                
                -- 4. Aktifkan Altar
                if EnchantConfig.SelectedStone == "Transcendent Stone" then
                    Altar2:FireServer()
                else
                    Altar1:FireServer()
                end

                -- 5. Tunggu Hasil (Roll)
                local success, resultArgs = pcall(function()
                    -- Tunggu event maksimal 10 detik biar gak hang selamanya
                    local event = RollRemote.OnClientEvent:Wait() 
                    return event -- Ini biasanya mengembalikan tuple, kita ambil argumennya nanti
                end)
                
                -- Karena Wait() mengembalikan tuple, kita perlu menangkap argumen spesifik.
                -- Cara aman menangkap argumen event di loop:
                -- Kita pakai connection temporary atau asumsi pcall return
                
                -- REVISI LOGIC WAIT AGAR LEBIH STABIL:
                -- Kita gunakan logic wait manual di luar pcall untuk menangkap return values
            else
                WindUI:Notify({Title="Error", Content="Gagal Equip Batu!", Icon="x"})
            end
            
            -- Jeda sebelum next loop (animasi enchant agak lama)
            task.wait(4)
        end
    end

    -- LOGIC UTAMA LOOP ENCHANT (DIPISAH SUPAYA BISA WAIT EVENT)
    local function StartEnchantLoop()
        local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
        local RollRemote = Net["RE/RollEnchant"]
        
        task.spawn(function()
            while EnchantConfig.Active do
                -- Step 1-4 (Cari Batu, Teleport, Equip, Fire Altar)
                -- Kita copy logic di atas tapi dioptimalkan
                local targetStoneId = StoneIDs[EnchantConfig.SelectedStone]
                local stoneUUID = getStoneUUID(targetStoneId)
                
                if not stoneUUID then
                    WindUI:Notify({Title="Auto Enchant", Content="Batu Habis / Tidak Ditemukan!", Icon="alert-circle"})
                    EnchantConfig.Active = false
                    break
                end

                -- Teleport
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    if EnchantConfig.SelectedStone == "Transcendent Stone" then
                        char.HumanoidRootPart.CFrame = CFrame.new(1478.03, 130.71, -613.82)
                    else
                        char.HumanoidRootPart.CFrame = CFrame.new(3256.83, -1300.65, 1391.13)
                    end
                end
                task.wait(0.8)

                -- Equip Process
                Net["RE/EquipItem"]:FireServer(stoneUUID, "Enchant Stones")
                task.wait(0.3)
                
                -- Auto Hand Equip (Simplified)
                -- Kita asumsikan slot 1 atau cari cepat, atau langsung fire activate
                -- Biasanya activate butuh tool di tangan. Kita pakai logic inventory check simple.
                local Replion = require(ReplicatedStorage.Packages.Replion)
                local data = Replion.Client:WaitReplion("Data", 5)
                local equipped = data:Get("EquippedItems")
                local slotFound = nil
                if equipped then
                    for slot, uuid in pairs(equipped) do
                        if uuid == stoneUUID then slotFound = tonumber(slot) break end
                    end
                end
                
                if slotFound then
                    Net["RE/EquipToolFromHotbar"]:FireServer(slotFound)
                    task.wait(0.5)
                    
                    -- Fire Altar
                    if EnchantConfig.SelectedStone == "Transcendent Stone" then
                        Net["RE/ActivateSecondEnchantingAltar"]:FireServer()
                    else
                        Net["RE/ActivateEnchantingAltar"]:FireServer()
                    end
                    
                    -- WAIT FOR RESULT (Blocking)
                    -- Kita tunggu sinyal dari server: "Enchant apa yang didapat?"
                    -- Argumen event RollEnchant biasanya: (Player, EnchantID, Variant...)
                    -- Tapi OnClientEvent di client biasanya nerima: (EnchantID, ???)
                    
                    local connection
                    local received = false
                    local gotEnchantID = nil
                    
                    connection = RollRemote.OnClientEvent:Connect(function(...)
                        local args = {...}
                        -- Cek argumen ke berapa yg isinya ID Enchant (biasanya ke-2 atau ke-1 tergantung game update)
                        -- Berdasarkan script kamu: args[2] adalah ID
                        gotEnchantID = args[2] 
                        received = true
                    end)
                    
                    -- Tunggu max 8 detik
                    local t = tick()
                    while not received and tick() - t < 8 do
                        task.wait(0.1)
                    end
                    
                    if connection then connection:Disconnect() end
                    
                    if received and gotEnchantID then
                        -- Cek apakah sesuai target?
                        local targetID = EnchantIDs[EnchantConfig.TargetEnchant]
                        if gotEnchantID == targetID then
                            WindUI:Notify({Title="Auto Enchant", Content="DAPAT: " .. EnchantConfig.TargetEnchant, Icon="check"})
                            -- STOP AUTO ENCHANT
                            EnchantConfig.Active = false
                            break
                        else
                            -- Cek nama enchant yg didapat untuk notif
                            local gotName = "Unknown"
                            for name, id in pairs(EnchantIDs) do
                                if id == gotEnchantID then gotName = name break end
                            end
                            -- WindUI:Notify({Title="Rolled", Content="Got: " .. gotName .. " (Skip)", Duration=1})
                        end
                    else
                        print("Timeout waiting for enchant result...")
                    end
                    
                    task.wait(1.5) -- Delay antar roll
                else
                    task.wait(1)
                end
            end
        end)
    end

    -- UI ELEMENTS (WRAPPED WITH ADDSAVE)

    AddSave("StoneTypeDropdown", EnchantSection:Dropdown({
        Title = "Select Stone Type",
        Values = {"Enchant Stone", "Evolved Enchant Stone", "Transcendent Stone"},
        Value = "Enchant Stone",
        Multi = false,
        Callback = function(val)
            EnchantConfig.SelectedStone = val
        end
    }))

    -- Urutkan Nama Enchant
    local EnchantNames = {}
    for name, _ in pairs(EnchantIDs) do table.insert(EnchantNames, name) end
    table.sort(EnchantNames)

    AddSave("TargetEnchantDropdown", EnchantSection:Dropdown({
        Title = "Target Enchant",
        Desc = "Script akan berhenti jika enchant ini didapatkan",
        Values = EnchantNames,
        Value = "Big Hunter I",
        Multi = false,
        Callback = function(val)
            EnchantConfig.TargetEnchant = val
        end
    }))

    AddSave("AutoEnchantToggle", EnchantSection:Toggle({
        Title = "Start Auto Enchant",
        Desc = "Pastikan punya banyak batu. Script otomatis stop jika dapat target.",
        Value = false,
        Callback = function(state)
            EnchantConfig.Active = state
            if state then
                StartEnchantLoop()
                WindUI:Notify({Title="Auto Enchant", Content="Started! Check F9 for logs", Icon="play"})
            else
                WindUI:Notify({Title="Auto Enchant", Content="Stopped", Icon="square"})
            end
        end
    }))

    -- [[ 3. AUTO PLACE TOTEM (FIXED: UI REFRESH & ITEM UTILITY) ]]
    local TotemSection = AutoTab:Section({ Title = "Auto Place Totem", Opened = true })

    -- Variables
    local TotemConfig = {
        Active = false,
        SelectedName = "",
        Delay = 60,
        UUIDs = {}
    }
    local TotemThread = nil

    -- Dependencies
    local SpawnRemote = nil
    pcall(function()
        SpawnRemote = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/SpawnTotem"]
    end)

    -- UI Reference
    local TotemDropdown = nil

    -- FUNCTION: SCAN TOTEM (LOGIC DARI SCRIPT YANG WORK)
    local function RefreshTotemList()
        -- Notif Diagnosa Awal
        if not isScriptLoading then WindUI:Notify({ Title = "System", Content = "Scanning Inventory...", Duration = 1 }) end

        local nameMap = {} 
        local namesList = {}
        local totalFound = 0
        
        pcall(function()
            -- 1. Load Modules Penting
            local Replion = require(ReplicatedStorage.Packages.Replion)
            local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility) -- INI KUNCINYA
            
            -- 2. Ambil Data Inventory
            local data = Replion.Client:WaitReplion("Data", 5)
            local inv = data:GetExpect("Inventory")
            
            if inv and inv.Totems then
                for _, totem in ipairs(inv.Totems) do
                    if totem.UUID and totem.Id then
                        -- Ambil Nama Pakai Utility Game (Pasti Benar)
                        local itemName = "Unknown Totem"
                        local itemData = ItemUtility.GetItemDataFromItemType("Totems", totem.Id)
                        
                        if itemData and itemData.Data then
                            itemName = itemData.Data.Name
                        end
                        
                        -- Masukkan ke Map
                        if not nameMap[itemName] then
                            nameMap[itemName] = {}
                            table.insert(namesList, itemName)
                        end
                        table.insert(nameMap[itemName], totem.UUID)
                        totalFound = totalFound + 1
                    end
                end
            end
        end)
        
        table.sort(namesList)
        TotemConfig.UUIDs = nameMap
        
        -- UPDATE UI (COBA SEMUA CARA BIAR PASTI MUNCUL)
        if TotemDropdown then
            pcall(function() TotemDropdown:Refresh(namesList) end)   -- Cara 1 (WindUI Baru)
            pcall(function() TotemDropdown:SetValues(namesList) end) -- Cara 2 (Fluent/Old WindUI)
            pcall(function() TotemDropdown:Set(namesList) end)       -- Cara 3 (Cadangan)
        end
        
        -- Notif Hasil Diagnosa
        if not isScriptLoading then
            if totalFound > 0 then
                WindUI:Notify({ Title = "Success", Content = "Found " .. totalFound .. " totems!", Icon = "check", Duration = 2 })
            else
                WindUI:Notify({ Title = "Empty", Content = "0 Totems found in bag.", Icon = "alert-triangle", Duration = 3 })
            end
        end
    end

    -- FUNCTION: MAIN LOOP SPAWN
    local function StartAutoTotem()
        TotemThread = task.spawn(function()
            local idx = 1
            while TotemConfig.Active do
                local availableUUIDs = TotemConfig.UUIDs[TotemConfig.SelectedName]
                
                if availableUUIDs and #availableUUIDs > 0 then
                    local currentUUID = availableUUIDs[idx]
                    if currentUUID then
                        pcall(function()
                            if not SpawnRemote then
                                SpawnRemote = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/SpawnTotem"]
                            end
                            if SpawnRemote then SpawnRemote:FireServer(currentUUID) end
                        end)
                        
                        if not isScriptLoading then
                            WindUI:Notify({ Title = "Totem", Content = "Spawned: " .. TotemConfig.SelectedName, Duration = 2 })
                        end
                        idx = (idx % #availableUUIDs) + 1
                    end
                else
                    RefreshTotemList() -- Auto Refresh kalau list kosong/habis
                end
                task.wait(TotemConfig.Delay * 60)
            end
        end)
    end

    -- UI ELEMENTS

    -- Tombol Refresh (GAK PERLU ADDSAVE, karena cuma tombol aksi)
    TotemSection:Button({
        Title = "Refresh Totem List",
        Desc = "Klik ini jika dropdown masih kosong",
        Icon = "refresh",
        Callback = function()
            RefreshTotemList()
        end
    })

    -- Dropdown Totem (PERLU DISAVE)
    -- Kita bungkus pakai AddSave, tapi tetap dimasukkan ke variable TotemDropdown
    TotemDropdown = AddSave("TotemSelectDropdown", TotemSection:Dropdown({
        Title = "Select Totem",
        Desc = "Pilih totem dari inventory",
        Values = {}, -- Akan terisi setelah Refresh
        Multi = false,
        Callback = function(val)
            TotemConfig.SelectedName = val
        end
    }))

    -- Input Delay (PERLU DISAVE)
    AddSave("TotemDelayInput", TotemSection:Input({
        Title = "Delay (Menit)",
        Desc = "Jeda waktu pasang",
        Placeholder = "60",
        Callback = function(v)
            local n = tonumber(v)
            if n then TotemConfig.Delay = n end
        end
    }))

    -- Toggle (PERLU DISAVE)
    AddSave("TotemToggle", TotemSection:Toggle({
        Title = "Enable Auto Totem",
        Desc = "Spawn totem otomatis",
        Value = false,
        Callback = function(state)
            TotemConfig.Active = state
            if state then
                if TotemConfig.SelectedName == "" then
                    if not isScriptLoading then WindUI:Notify({ Title = "Error", Content = "Pilih Totem dulu!", Duration = 2 }) end
                    TotemConfig.Active = false
                    return
                end
                StartAutoTotem()
                if not isScriptLoading then WindUI:Notify({ Title = "Auto Totem", Content = "Started", Icon = "check", Duration = 2 }) end
            else
                if TotemThread then task.cancel(TotemThread) end
                TotemThread = nil
                if not isScriptLoading then WindUI:Notify({ Title = "Auto Totem", Content = "Stopped", Icon = "x", Duration = 2 }) end
            end
        end
    }))

    -- Auto Refresh saat awal (Silent)
    task.spawn(function()
        task.wait(2)
        RefreshTotemList()
    end)

----------------------------------------------------
    -- ⭐ AUTO FAVORITE (CLEANED & ORIGINAL LOGIC)
    ----------------------------------------------------
    local AutoFavSection = AutoTab:Section({ Title = "Auto Favorite", Opened = true })

    -- 1. Variables
    local autoFavEnabled = false
    local selectedRarities = {}   
    local selectedMutations = {}
    local selectedFishNames = {}  -- BARU: Untuk select per nama ikan
    local favLoop = nil
    local favoriteCount = 0

    -- 2. Dependencies
    local Replion = require(ReplicatedStorage.Packages.Replion)
    local ItemsDatabase = require(ReplicatedStorage.Items)
    local VariantsDatabase = require(ReplicatedStorage.Variants)

    -- 3. FISH NAME SCANNER (RUN ONCE ON LOAD)
    local AvailableFishNames = {}
    local FishNameToIdMap = {}  -- Mapping nama → ID untuk lookup cepat

    local function ScanAllFishNames()
        local ItemsFolder = ReplicatedStorage:WaitForChild("Items")
        local scannedNames = {}
        
        for _, itemModule in ipairs(ItemsFolder:GetChildren()) do
            if itemModule:IsA("ModuleScript") then
                local success, itemData = pcall(function()
                    return require(itemModule)
                end)
                
                if success and itemData and itemData.Data then
                    local itemType = itemData.Data.Type
                    local itemName = itemData.Data.Name
                    local itemId = itemData.Data.Id
                    
                    -- Filter hanya Fish
                    if itemType == "Fish" and itemName and itemId then
                        if not scannedNames[itemName] then
                            table.insert(AvailableFishNames, itemName)
                            scannedNames[itemName] = true
                        end
                        -- Mapping nama ke ID
                        FishNameToIdMap[itemName] = itemId
                    end
                end
            end
        end
        table.sort(AvailableFishNames)
        print(string.format("[AutoFav] Scanned %d unique fish names", #AvailableFishNames))
    end

    -- Jalankan scan sekali saat load
    ScanAllFishNames()

    -- 4. CACHING SYSTEM (CPU OPTIMIZATION)
    local ItemCache = {}
    local VariantCache = {}

    local function InitializeCache()
        -- Cache Item Data
        for _, item in pairs(ItemsDatabase) do
            if item.Data and item.Data.Id then
                ItemCache[item.Data.Id] = item
            end
        end
        
        -- Cache Variant/Mutation Data
        for key, var in pairs(VariantsDatabase) do
            local realId = (var.Data and var.Data.Id) or key
            local realName = (var.Data and var.Data.Name) or key 
            
            if realId and realName then
                VariantCache[realId] = realName
            end
        end
    end

    InitializeCache()

    -- 5. HELPER FUNCTIONS
    local function getItemStaticData(targetId)
        return ItemCache[targetId]
    end

    local function getMutationNameById(variantId)
        return VariantCache[variantId]
    end

    local function isTierSelected(tierId)
        for _, id in pairs(selectedRarities) do
            if id == tierId then return true end
        end
        return false
    end

    local function isMutationSelected(mutName)
        if #selectedMutations == 0 then return false end
        if not mutName then return false end
        
        local targetLower = string.lower(tostring(mutName))
        
        for _, mName in pairs(selectedMutations) do
            if string.find(targetLower, string.lower(mName), 1, true) then 
                return true 
            end
        end
        return false
    end

    -- BARU: Cek apakah nama ikan dipilih
    local function isFishNameSelected(fishId)
        if #selectedFishNames == 0 then return false end
        
        local staticData = getItemStaticData(fishId)
        if not staticData or not staticData.Data.Name then return false end
        
        local fishName = staticData.Data.Name
        
        for _, selectedName in pairs(selectedFishNames) do
            if fishName == selectedName then
                return true
            end
        end
        return false
    end

    -- 6. SCANNING LOGIC (PRIORITY CHECK FIX)
    local function ScanInventoryForFavorites()
        local resultList = {}
        
        local playerData = Replion.Client:WaitReplion("Data", 5)
        if not playerData then return {} end
        
        local inventory = playerData:GetExpect("Inventory")
        if not inventory or not inventory.Items then return {} end

        local processCount = 0

        for _, invItem in pairs(inventory.Items) do
            -- Anti-Freeze setiap 500 item
            processCount = processCount + 1
            if processCount % 500 == 0 then task.wait() end

            if not invItem.Favorited then
                local staticData = getItemStaticData(invItem.Id)
                
                if staticData and staticData.Data.Type == "Fish" then
                    local shouldFavorite = false

                    -- [LOGIC 1] Cek Fish Name (PRIORITAS TERTINGGI)
                    if isFishNameSelected(invItem.Id) then
                        shouldFavorite = true
                    end

                    -- [LOGIC 2] Cek Rarity (Tier)
                    if not shouldFavorite and isTierSelected(staticData.Data.Tier) then
                        shouldFavorite = true
                    end

                    -- [LOGIC 3] Cek Mutasi
                    if not shouldFavorite and invItem.Metadata then
                        local mutationFound = false
                        
                        -- A. Cek via Cache (Database Variant)
                        if invItem.Metadata.VariantId then
                            local cacheName = getMutationNameById(invItem.Metadata.VariantId)
                            if cacheName and isMutationSelected(cacheName) then
                                mutationFound = true
                            end
                            
                            -- B. Fallback: Cek Raw VariantId
                            if not mutationFound and isMutationSelected(invItem.Metadata.VariantId) then
                                mutationFound = true
                            end
                        end
                        
                        -- C. Fallback: Cek field 'Mutation'
                        if not mutationFound and invItem.Metadata.Mutation and isMutationSelected(invItem.Metadata.Mutation) then
                            mutationFound = true
                        end

                        if mutationFound then
                            shouldFavorite = true
                        end
                    end
                    
                    -- Jika salah satu kriteria terpenuhi -> Masukkan antrian
                    if shouldFavorite then
                        table.insert(resultList, invItem.UUID)
                    end
                end
            end
        end

        return resultList
    end

    -- 7. NETWORK HANDLER
    local function favHandler(uuid)
        pcall(function()
            local netFolder = ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0")
            if netFolder then
                local REFavoriteItem = netFolder.net:FindFirstChild("RE/FavoriteItem")
                if REFavoriteItem then
                    REFavoriteItem:FireServer(uuid)
                    favoriteCount = favoriteCount + 1
                end
            end
        end)
    end

    -- 8. MAIN LOOP
    local function startAutoFavorite()
        favLoop = task.spawn(function()
            while autoFavEnabled do
                if #selectedRarities == 0 and #selectedMutations == 0 and #selectedFishNames == 0 then
                    task.wait(2)
                    continue -- Logic bawaan tetap dipertahankan
                end

                local itemsToFav = ScanInventoryForFavorites()

                if #itemsToFav > 0 then
                    for _, uuid in pairs(itemsToFav) do
                        if not autoFavEnabled then break end
                        favHandler(uuid)
                        task.wait(0.2)
                    end
                else
                    task.wait(1)
                end
                task.wait(0.5)
            end
        end)
    end

    -- [[ UI ELEMENTS ]] --

    -- A. FISH NAME
    NameDropdown = AddSave("AutoFavNameDropdown", AutoFavSection:Dropdown({
        Title = "Select Fish Name",
        Desc = "Prioritas Tertinggi",
        Values = AvailableFishNames, 
        Multi = true,
        Value = {},
        Callback = function(Value)
            selectedFishNames = {}
            if type(Value) == "table" then
                local isArray = #Value > 0
                
                if isArray then
                    print("[AutoFav] Processing as ARRAY format")
                    for _, fishName in ipairs(Value) do
                        table.insert(selectedFishNames, fishName)
                    end
                end
            end
            print(string.format("[AutoFav] Selected %d fish names", #selectedFishNames))
        end
    }))

    -- B. RARITY
    AddSave("AutoFavRarityDropdown", AutoFavSection:Dropdown({
        Title = "Select Rarity",
        Values = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"},
        Multi = true,
        Value = {},
        Callback = function(Value)
            selectedRarities = {}
            
            local RarityMap = {
                ["Common"] = 1, 
                ["Uncommon"] = 2, 
                ["Rare"] = 3,
                ["Epic"] = 4, 
                ["Legendary"] = 5, 
                ["Mythic"] = 6, 
                ["SECRET"] = 7
            }
            
            if type(Value) == "table" then
                local isArray = #Value > 0
                
                if isArray then
                    print("[AutoFav] Processing as ARRAY format")
                    for _, rarityName in ipairs(Value) do
                        if RarityMap[rarityName] then
                            table.insert(selectedRarities, RarityMap[rarityName])
                        end
                    end
                end
            end
            
            -- Sort for consistent order
            table.sort(selectedRarities)
        end
    }))

    -- C. MUTATION
    AddSave("AutoFavMutationDropdown", AutoFavSection:Dropdown({
        Title = "Select Mutation",
        Desc = "Pilih Mutasi (Bisa jalan sendiri)",
        Values = {
            "1x1x1x1","Albino","Artic Frost","Bloodmoon","Color Burn","Corrupt",
            "Crystalized","Disco","Fairy Dust","Festive","Frozen","Galaxy","Gemstone",
            "Ghost","Gold","Holographic", "Leviathan Rage", "Lightning", "Midnight", 
            "Moon Fragment", "Noob", "Radioactive", "Sandy", "Stone"
        },
        Multi = true,
        Value = {},
        Callback = function(Value)
            selectedMutations = {}
            if type(Value) == "table" then
                local isArray = #Value > 0
                
                if isArray then
                    print("[AutoFav] Processing as ARRAY format")
                    for _, mutationName in ipairs(Value) do
                        table.insert(selectedMutations, mutationName)
                    end
                end
            end
        end
    }))

    -- D. TOGGLE
    AddSave("AutoFavToggle", AutoFavSection:Toggle({
        Title = "Enable Auto Favorite",
        Desc = "Pastikan sudah pilih minimal 1 filter",
        Value = false,
        Callback = function(Value)
            autoFavEnabled = Value
            if Value then
                startAutoFavorite()
            else
                if favLoop then task.cancel(favLoop) end
                favLoop = nil
                print(string.format("[System] Auto Favorite Stopped | Total: %d", favoriteCount))
            end
        end
    }))

    -- E. UNFAVORITE BUTTON
    AutoFavSection:Button({
        Title = "Unfavorite ALL Fish",
        Desc = "Reset semua favorite di tas",
        Icon = "trash-2",
        Callback = function()
            WindUI:Notify({ Title = "System", Content = "Unfavoriting...", Duration = 2 })
            pcall(function()
                local playerData = Replion.Client:WaitReplion("Data", 5)
                if not playerData then return end
                local inventory = playerData:GetExpect("Inventory")
                local count = 0
                if inventory and inventory.Items then
                    for _, invItem in pairs(inventory.Items) do
                        local staticData = getItemStaticData(invItem.Id)
                        if staticData and staticData.Data.Type == "Fish" and invItem.Favorited then
                            favHandler(invItem.UUID)
                            count = count + 1
                            if count % 20 == 0 then task.wait() end
                        end
                    end
                end
                print("Unfavorited Count:", count)
            end)
        end
    })

    -- [[ 4. AUTO TRADE (STRICT LOGIC VERSION) ]]
    local TradeSection = AutoTab:Section({ Title = "Auto Trade System", Opened = true })

    -- [DEPENDENCIES]
    -- Pastikan Replion terload karena logic scan butuh ini
    local Replion = require(ReplicatedStorage.Packages.Replion)

    -- [VARIABLES TRADE]
    local TradeState = { isTrading = false, itemName = "", targetName = "", mode = "Non-Favorite", maxQty = 0, total = 0 }

    -- Remote Paths
    local Net = ReplicatedStorage.Packages._Index:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
    local EquipRemote = Net:WaitForChild("RE/EquipItem")
    local TradeRemote = Net:WaitForChild("RF/InitiateTrade")

    -- [FUNCTIONS]
    local function getAllUsernames()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do 
            if p ~= LocalPlayer then table.insert(list, p.Name) end 
        end
        return list
    end

    local function getInventoryItemNames()
        local names, seen = {}, {}
        pcall(function()
            local data = Replion.Client:WaitReplion("Data", 5)
            if data then
                local inv = data:GetExpect("Inventory")
                if inv and inv.Items then
                    for _, i in pairs(inv.Items) do
                        local static = ItemCache[i.Id]
                        if static and static.Data.Name and not seen[static.Data.Name] then
                            table.insert(names, static.Data.Name)
                            seen[static.Data.Name] = true
                        end
                    end
                end
            end
        end)
        table.sort(names)
        return #names > 0 and names or {"Empty/Error"}
    end

    local function scanTradeItems(name, mode)
        local q = {}
        pcall(function()
            local data = Replion.Client:WaitReplion("Data", 5)
            if data then
                local inv = data:GetExpect("Inventory")
                if inv and inv.Items then
                    for _, i in pairs(inv.Items) do
                        local static = ItemCache[i.Id]
                        if static and static.Data.Name == name then
                            local fav = i.Favorited or false
                            if (mode == "Non-Favorite" and not fav) or (mode == "Favorite" and fav) or mode == "All" then
                                table.insert(q, {UUID = i.UUID, Type = static.Data.Type})
                            end
                        end
                    end
                end
            end
        end)
        return q
    end

    -- [HOOK LOGIC]
    local onTrade, listener = false, nil
    local function ToggleTradeHook(s)
        if s then
            if listener then return end
            local r = Net:FindFirstChild("RE/TextNotification")
            if r then 
                listener = r.OnClientEvent:Connect(function(d)
                    if TradeState.isTrading and type(d)=="table" and d.Text then
                        if d.Text=="Trade completed!" then 
                            onTrade = false
                            TradeState.total = TradeState.total + 1
                        elseif d.Text=="Trade was declined" or d.Text=="You are too far away!" then 
                            onTrade = false 
                        end
                    end
                end) 
            end
        elseif listener then 
            listener:Disconnect()
            listener = nil 
        end
    end

    -- [UI ELEMENTS & MAIN LOOP]

    -- Dropdown Target
    local PDrop = AddSave("TradeTargetDropdown", TradeSection:Dropdown({ 
        Title = "Target Player", 
        Values = getAllUsernames(), 
        Multi = false, 
        Callback = function(v) TradeState.targetName = v end 
    }))

    TradeSection:Button({ Title = "Refresh Player", Icon = "refresh", Callback = function() PDrop:Refresh(getAllUsernames()) end })

    -- Dropdown Item
    local IDrop = AddSave("TradeItemDropdown", TradeSection:Dropdown({ 
        Title = "Select Item", 
        Values = {"Refresh First..."}, 
        Multi = false, 
        Callback = function(v) TradeState.itemName = v end 
    }))

    TradeSection:Button({ Title = "Refresh Item", Icon = "refresh", Callback = function() IDrop:Refresh(getInventoryItemNames()) end })

    AddSave("TradeQtyInput", TradeSection:Input({ 
        Title = "Quantity (0=All)", 
        Placeholder = "0", 
        Callback = function(v) TradeState.maxQty = tonumber(v) or 0 end 
    }))

    AddSave("TradeStatusDropdown", TradeSection:Dropdown({ 
        Title = "Status Filter", 
        Values = {"Non-Favorite", "Favorite", "All"}, 
        Value = "Non-Favorite", 
        Multi = false, 
        Callback = function(v) TradeState.mode = v end 
    }))

    AddSave("AutoTradeToggle", TradeSection:Toggle({ 
        Title = "Start Auto Trade", 
        Value = false, 
        Callback = function(s)
            TradeState.isTrading = s
            ToggleTradeHook(s)
            
            if s then
                -- Validasi Input
                if TradeState.targetName=="" or TradeState.itemName=="" then 
                    if not isScriptLoading then WindUI:Notify({Title="Error", Content="Isi Target & Item!"}) end
                    TradeState.isTrading = false 
                    return 
                end
                
                -- [MAIN LOOP LOGIC - EXACT MATCH]
                task.spawn(function()
                    TradeState.total = 0
                    while TradeState.isTrading do
                        -- Cek Limit
                        if TradeState.maxQty > 0 and TradeState.total >= TradeState.maxQty then 
                            TradeState.isTrading = false 
                            break 
                        end
                        
                        -- Cek Target
                        local target = Players:FindFirstChild(TradeState.targetName)
                        if not target then 
                            TradeState.isTrading = false 
                            break 
                        end
                        
                        -- Scan Items
                        local q = scanTradeItems(TradeState.itemName, TradeState.mode)
                        if #q > 0 then
                            if not isScriptLoading then WindUI:Notify({Title="Sending", Content="Items: "..#q}) end
                            
                            for _, i in ipairs(q) do
                                -- Cek kondisi berhenti di dalam loop
                                if not TradeState.isTrading or (TradeState.maxQty>0 and TradeState.total>=TradeState.maxQty) then break end
                                
                                -- Eksekusi Trade
                                EquipRemote:FireServer(i.UUID, i.Type)
                                pcall(function() TradeRemote:InvokeServer(target.UserId, i.UUID) end)
                                
                                onTrade = true
                                
                                -- [DELAY LOGIC 1: Wait for Trade Completion (Max 11s)]
                                local h = 0
                                while onTrade and h < 11 do 
                                    h = h + 1
                                    task.wait(1) 
                                end
                                
                                -- [DELAY LOGIC 2: Buffer after trade]
                                task.wait(5)
                            end
                        else 
                            -- [DELAY LOGIC 3: If no items found]
                            task.wait(5) 
                        end
                        
                        -- [DELAY LOGIC 4: Loop interval]
                        task.wait(1)
                    end
                    
                    -- Matikan Hook saat loop selesai
                    ToggleTradeHook(false)
                end)
            end
        end 
    }))

    -- [AUTO ACCEPT LOGIC - EXACT MATCH]
    local isAccept, secEv, qTab = false, nil, nil

    pcall(function()
        local PromptController = require(ReplicatedStorage.Controllers.PromptController)
        -- Ambil internal variables (Upvalues)
        secEv = debug.getupvalues(PromptController.Init)[4]
        qTab = debug.getupvalues(PromptController.FirePrompt)[1]
        
        -- Hook DrawPrompt
        if not getgenv().OrigPrompt then getgenv().OrigPrompt = PromptController.DrawPrompt end
        
        PromptController.DrawPrompt = function(s, d)
            if isAccept and secEv and qTab then
                task.spawn(function() 
                    -- [DELAY LOGIC 5: Accept Delay]
                    task.wait(0.2) 
                    
                    if qTab[1] == d then 
                        if d.ConfirmAction then 
                            -- [DELAY LOGIC 6: Confirm Delay]
                            task.wait(2) 
                            if qTab[1] == d then secEv:Fire(true) end 
                        else 
                            secEv:Fire(true) 
                        end 
                    end 
                end)
            end
            return getgenv().OrigPrompt(s, d)
        end
    end)

    AddSave("AutoAcceptTradeToggle", TradeSection:Toggle({ 
        Title = "Auto Accept Trade", 
        Value = false, 
        Callback = function(s) isAccept = s end 
    }))
end

------------
-- tab shop (WRAPPED WITH ADDSAVE)
------------

local function loadTabShop()

    -- [[ 1. FISHING ROD SHOP ]]
    local RodSection = ShopTab:Section({ Title = "Fishing Rod Shop", Opened = true })

    local SelectedRod = "Starter Rod (50$)"
    local RodIDs = {
        ["Starter Rod (50$)"] = 1,
        ["Luck Rod (350$)"] = 79,
        ["Carbon Rod (900$)"] = 76,
        ["Grass Rod (1500$)"] = 85,
        ["Desmascus Rod (3000$)"] = 77,
        ["Ice Rod (5000$)"] = 78,
        ["Lucky Rod (15000$)"] = 4,
        ["Midnight Rod (50000$)"] = 80,
        ["SteamPunk Rod (215000$)"] = 6,
        ["Chrome Rod (437000$)"] = 7,
        ["Fluorescent Rod (715000$)"] = 255,
        ["Astral Rod (1M$)"] = 5,
        ["Ares Rod (3M$)"] = 126,
        ["Angler Rod (8M$)"] = 168,
        ["Bambo Rod (12M$)"] = 258
    }

    -- Urutkan nama rod untuk dropdown
    local RodNames = {}
    for name, _ in pairs(RodIDs) do table.insert(RodNames, name) end
    table.sort(RodNames)

    AddSave("RodShopDropdown", RodSection:Dropdown({
        Title = "Select Fishing Rod",
        Desc = "Pilih joran yang ingin dibeli",
        Values = RodNames,
        Value = SelectedRod,
        Multi = false,
        Callback = function(val)
            SelectedRod = val
        end
    }))

    RodSection:Button({
        Title = "Purchase Rod",
        Desc = "Beli joran yang dipilih",
        Icon = "shopping-cart",
        Callback = function()
            local id = RodIDs[SelectedRod]
            if id then
                pcall(function()
                    NetPath["RF/PurchaseFishingRod"]:InvokeServer(id)
                end)
                if not isScriptLoading then
                    WindUI:Notify({ Title = "Shop", Content = "Membeli: " .. SelectedRod, Icon = "check", Duration = 2 })
                end
            end
        end
    })

    -- [[ 2. BAIT SHOP ]]
    local BaitSection = ShopTab:Section({ Title = "Bait Shop", Opened = true })

    local SelectedBait = "TopWater Bait (100$)"
    local BaitIDs = {
        ["TopWater Bait (100$)"] = 10,
        ["Luck Bait (1000$)"] = 2,
        ["Midnight Bait (3000$)"] = 3,
        ["Nature Bait (83500$)"] = 17,
        ["Chroma Bait (290000$)"] = 6,
        ["Dark Matter Bait (630000$)"] = 8,
        ["Corrupt Bait (1.15M$)"] = 15,
        ["Aether Bait (3.70M$)"] = 16,
        ["Floral Bait (4M$)"] = 20
    }

    local BaitNames = {}
    for name, _ in pairs(BaitIDs) do table.insert(BaitNames, name) end
    table.sort(BaitNames)

    AddSave("BaitShopDropdown", BaitSection:Dropdown({
        Title = "Select Bait",
        Values = BaitNames,
        Value = SelectedBait,
        Multi = false,
        Callback = function(val)
            SelectedBait = val
        end
    }))

    BaitSection:Button({
        Title = "Purchase Bait",
        Desc = "Beli umpan yang dipilih",
        Icon = "bug",
        Callback = function()
            local id = BaitIDs[SelectedBait]
            if id then
                pcall(function()
                    NetPath["RF/PurchaseBait"]:InvokeServer(id)
                end)
                if not isScriptLoading then
                    WindUI:Notify({ Title = "Shop", Content = "Membeli: " .. SelectedBait, Icon = "check", Duration = 2 })
                end
            end
        end
    })

    -- [[ 3. AUTO BUY WEATHER (FIXED) ]]
    local WeatherSection = ShopTab:Section({ Title = "Auto Buy Weather", Opened = true })

    local SelectedWeathers = {} -- Menyimpan nama cuaca
    local AutoWeatherActive = false

    -- Definisikan Remote Path langsung di sini biar aman
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local PurchaseRemote = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net")
        :WaitForChild("RF/PurchaseWeatherEvent")

    AddSave("WeatherSelectDropdown", WeatherSection:Dropdown({
        Title = "Select Weather (Multi)",
        Values = {"Wind", "Storm", "Radiant", "Cloudy", "Snow", "Shark Hunt"},
        Multi = true,
        Value = {}, 
        Callback = function(val)
            SelectedWeathers = val
        end
    }))

    AddSave("AutoWeatherToggle", WeatherSection:Toggle({
        Title = "Auto Buy Weather",
        Desc = "Spam beli cuaca (2 detik)",
        Value = false,
        Callback = function(state)
            AutoWeatherActive = state
            
            if state then
                if not isScriptLoading then
                    WindUI:Notify({ Title = "Auto Weather", Content = "Aktif (Cek Console F9 jika error)", Icon = "cloud-rain", Duration = 2 })
                end
                
                task.spawn(function()
                    while AutoWeatherActive do
                        -- Loop diperbaiki: Ambil Value-nya (v), bukan Index-nya (_)
                        for _, weatherName in pairs(SelectedWeathers) do
                            if weatherName and typeof(weatherName) == "string" then
                                task.spawn(function()
                                    pcall(function()
                                        -- Kirim request sesuai Spy: "Wind", "Storm", dll
                                        PurchaseRemote:InvokeServer(weatherName)
                                    end)
                                end)
                            end
                        end
                        task.wait(2) -- Jeda 2 detik
                    end
                end)
            else
                if not isScriptLoading then
                    WindUI:Notify({ Title = "Auto Weather", Content = "Mati", Icon = "x", Duration = 2 })
                end
            end
        end
    }))

    -- [[ 4. MERCHANT SHOP ]]
    local MerchantSection = ShopTab:Section({ Title = "Merchant Shop", Opened = true })

    local MerchantItem = "Fluorescent Rod"
    local MerchantIDs = {
        ["Fluorescent Rod"] = 1,
        ["Hazmat Rod"] = 2,
        ["Singularity Bait"] = 3,
        ["Royal Bait"] = 4,
        ["Luck Totem"] = 5,
        ["Shiny Totem"] = 7,
        ["Mutation Totem"] = 8
    }

    MerchantSection:Button({
        Title = "Open Merchant GUI",
        Desc = "Buka menu merchant dimanapun",
        Icon = "store",
        Callback = function()
            local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
            if GuiControl then
                GuiControl:Open("Merchant")
            end
        end
    })

    AddSave("MerchantItemDropdown", MerchantSection:Dropdown({
        Title = "Select Merchant Item",
        Values = {"Fluorescent Rod", "Hazmat Rod", "Singularity Bait", "Royal Bait", "Luck Totem", "Shiny Totem", "Mutation Totem"},
        Value = MerchantItem,
        Multi = false,
        Callback = function(val)
            MerchantItem = val
        end
    }))

    local AutoMerchantActive = false
    AddSave("AutoMerchantToggle", MerchantSection:Toggle({
        Title = "Auto Buy Merchant Item",
        Desc = "Spam beli item merchant (1 detik)",
        Value = false,
        Callback = function(state)
            AutoMerchantActive = state
            if state then
                task.spawn(function()
                    while AutoMerchantActive do
                        local id = MerchantIDs[MerchantItem]
                        if id then
                            pcall(function()
                                NetPath["RF/PurchaseMarketItem"]:InvokeServer(id)
                            end)
                        end
                        task.wait(1)
                    end
                end)
                if not isScriptLoading then WindUI:Notify({ Title = "Merchant", Content = "Auto Buy Aktif", Duration = 2 }) end
            else
                if not isScriptLoading then WindUI:Notify({ Title = "Merchant", Content = "Auto Buy Mati", Duration = 2 }) end
            end
        end
    }))
end

------------
-- tab teleport
------------

local function loadTabTeleport()

    -- Teleport Locations
    local TeleportLocations = {
        -- Lokasi dari input sebelumnya (yang belum ada di update baru)
        ["Fisherman Island"] = CFrame.new(-19.0017929, 9.53157043, 2732.60181, -0.0352761336, -3.61086094e-08, -0.999377608, -2.01366319e-08, 1, -3.54203138e-08, 0.999377608, 1.88746085e-08, -0.0352761336),
        ["Mutation Cellar"] = CFrame.new(-1740.15625, -222.600388, 23891.416, -0.998281837, 2.1648729e-08, 0.0585951991, 2.42207214e-08, 1, 4.31840519e-08, -0.0585951991, 4.45290702e-08, -0.998281837),
        ["Ocean"] = CFrame.new(-2568.91602, 5.07336473, -24.0376396, 0.91680795, -5.10048679e-08, 0.399328381, 5.86647246e-08, 1, -6.96024083e-09, -0.399328381, 2.98076941e-08, 0.91680795),
        ["Kohana Volcano"] = CFrame.new(-648.820435, 45.7505226, 170.849945, -0.935509741, -1.00212056e-07, 0.353300929, -1.08844581e-07, 1, -4.56581351e-09, -0.353300929, -4.27262528e-08, -0.935509741),
        ["Weather Mechine"] = CFrame.new(-1505.14, 6.50, 1890.95), -- Versi lama, mungkin beda ketinggian
        ["Crystalline Passage"] = CFrame.new(6050.52, -538.90, 4389.68),
        ["Secret Passage"] = CFrame.new(3446.78442, -287.844818, 3399.77393, -0.934207439, 3.25567413e-08, -0.356730253, 3.83170709e-12, 1, 9.12542717e-08, 0.356730253, 8.52490558e-08, -0.934207439),
        ["Crystal Depths"] = CFrame.new(5808.42529, -899.366394, 15353.1709, -0.997745156, 3.95877414e-10, 0.0671164095, 4.13268725e-10, 1, 2.45237053e-10, -0.0671164095, 2.72421197e-10, -0.997745156),
        ["Leviathan Den"] = CFrame.new(3473.8938, -287.84317, 3474.09253, -0.9540658, -7.05655339e-08, -0.299597085, -3.95649451e-08, 1, -1.09540359e-07, 0.299597085, -9.26551706e-08, -0.9540658),

        -- Lokasi dari UPDATE BARU (Menggantikan atau Menambah)
        ["Fisherman"] = CFrame.new(-18.065, 9.532, 2734, -0.113811, 0, -0.993502, 0, 1, 0, 0.993502, 0, -0.113811),
        ["Sisyphus Statue"] = CFrame.new(-3754.441, -135.074, -895.376, 0.943844, 0, -0.330393, 0, 1, 0, 0.330393, 0, 0.943844),
        ["Coral Reefs"] = CFrame.new(-3030.043, 2.509, 2271.429, 0.304264, 0, 0.952588, 0, 1, 0, -0.952588, 0, 0.304264),
        ["Esoteric Depths"] = CFrame.new(3271.979, -1301.53, 1402.762, -0.981542, 0, -0.191249, 0, 1, 0, 0.191249, 0, -0.981542),
        ["Crater Island 1"] = CFrame.new(990.61, 21.142, 5060.255, 0.998865, 0, -0.047632, 0, 1, 0, 0.047632, 0, 0.998865), -- Update nama biar unik
        ["Crater Island 2"] = CFrame.new(1040.036, 55.714, 5131.443, 0.551438, 0, 0.834216, 0, 1, 0, -0.834216, 0, 0.551438), -- Update nama biar unik
        ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801),
        ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298), -- Update koordinat
        ["Tropical Grove"] = CFrame.new(-2132.597, 53.488, 3631.235, -0.664326, 0, 0.747443, 0, 1, 0, -0.747443, 0, -0.664326),
        ["Treasure Room"] = CFrame.new(-3630, -279.074, -1599.287, 0.721647, 0, -0.692261, 0, 1, 0, 0.692261, 0, 0.721647),
        ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875),
        ["Kohana 2"] = CFrame.new(-530.529, 8.75, -72.149, -0.910784, 0, -0.412883, 0, 1, 0, 0.412883, 0, -0.910784), -- Ganti spasi biar rapi
        ["Underground Cellar"] = CFrame.new(2110.109, -91.199, -699.79, 0.744219, 0, -0.667935, 0, 1, 0, 0.667935, 0, 0.744219),
        ["Ancient Jungle"] = CFrame.new(1837.352, 5.894, -297.224, 0.38862, 0, -0.921398, 0, 1, 0, 0.921398, 0, 0.38862),
        ["Ancient Jungle 2"] = CFrame.new(1468.971, 6.512, -326.397, -0.458676, 0, -0.888603, 0, 1, 0, 0.888603, 0, -0.458676),
        ["Sacred Temple"] = CFrame.new(1459.217, -22.375, -637.787, 0.924266, 0, 0.38175, 0, 1, 0, -0.38175, 0, 0.924266),
        ["Ancient Ruins"] = CFrame.new(6097.176, -585.924, 4644.443, -0.514758, 0, 0.857336, 0, 1, 0, -0.857336, 0, -0.514758),
        ["Megalodon"] = CFrame.new(-1172.987, 7.924, 3620.589, 0.706693, 0, 0.707521, 0, 1, 0, -0.707521, 0, 0.706693),
        ["Pirate Cove"] = CFrame.new(3396.73, 4.192, 3469.213) * CFrame.Angles(0, -1.447, 0),
        ["Pirate Treasure Room"] = CFrame.new(3324.07397, -306.475647, 3087.99927, 0.999340534, -1.78439805e-8, 0.0363113917, 2.01013268e-8, 1, -6.18013019e-8, -0.0363113917, 6.24904501e-8, 0.999340534)
    }

    -- Variables untuk player teleport
    local SelectedLocation = nil
    local SelectedPlayer = nil
    local PlayerList = {}

    -- Function untuk teleport ke lokasi
    local function TeleportToLocation(locationName)
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local cframe = TeleportLocations[locationName]
            if cframe then
                character.HumanoidRootPart.CFrame = cframe
                WindUI:Notify({ 
                    Title = "Teleport", 
                    Content = "Teleported to " .. locationName, 
                    Duration = 2, 
                    Icon = "check" 
                })
            end
        else
            WindUI:Notify({ 
                Title = "Error", 
                Content = "Character not found!", 
                Duration = 2, 
                Icon = "x" 
            })
        end
    end

    -- Function untuk update player list
    local function UpdatePlayerList()
        PlayerList = {}
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(PlayerList, player.Name)
            end
        end
        return PlayerList
    end

    -- Function untuk teleport ke player
    local function TeleportToPlayer(playerName)
        local targetPlayer = game.Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                WindUI:Notify({ 
                    Title = "Teleport", 
                    Content = "Teleported to " .. playerName, 
                    Duration = 2, 
                    Icon = "check" 
                })
            end
        else
            WindUI:Notify({ 
                Title = "Error", 
                Content = "Player not found or not in game!", 
                Duration = 2, 
                Icon = "x" 
            })
        end
    end

    -- Sort location names
    local LocationNames = {}
    for name, _ in pairs(TeleportLocations) do
        table.insert(LocationNames, name)
    end
    table.sort(LocationNames)

    -- [[ TELEPORT TAB (PARTIALLY WRAPPED) ]]

    -- SECTION: Teleport to Island
    local IslandSection = TeleportTab:Section({
        Title = "Teleport to Island",
        Opened = true
    })

    -- Dropdown Lokasi (DISAVE - Biar ingat lokasi terakhir)
    AddSave("TeleportLocationDropdown", IslandSection:Dropdown({
        Title = "Select Location",
        Desc = "Pilih lokasi untuk teleport",
        Multi = false,
        Value = LocationNames[1],
        Values = LocationNames,
        Callback = function(selected)
            SelectedLocation = selected
        end
    }))

    -- Tombol Teleport (AKSI - TIDAK PERLU SAVE)
    IslandSection:Button({
        Title = "Teleport",
        Desc = "Teleport ke lokasi yang dipilih",
        Icon = "map-pin",
        Callback = function()
            if SelectedLocation then
                TeleportToLocation(SelectedLocation)
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Pilih lokasi terlebih dahulu!", 
                    Duration = 2, 
                    Icon = "alert-triangle" 
                })
            end
        end
    })

    -- SECTION: Teleport to Player
    local PlayerSection = TeleportTab:Section({
        Title = "Teleport to Player",
        Opened = true
    })

    -- Update player list pertama kali
    UpdatePlayerList()

    -- Dropdown Player (JANGAN DISAVE - Karena player beda-beda tiap server)
    local PlayerDropdown = PlayerSection:Dropdown({
        Title = "Select Player",
        Desc = "Pilih player untuk teleport",
        Multi = false,
        Value = PlayerList[1] or "No players",
        Values = #PlayerList > 0 and PlayerList or {"No players"},
        Callback = function(selected)
            SelectedPlayer = selected
        end
    })

    PlayerSection:Button({
        Title = "Refresh Player List",
        Desc = "Perbarui daftar player",
        Icon = "refresh-cw",
        Callback = function()
            UpdatePlayerList()
            if #PlayerList > 0 then
                PlayerDropdown:Refresh(PlayerList)
                WindUI:Notify({ 
                    Title = "Success", 
                    Content = "Player list updated!", 
                    Duration = 2, 
                    Icon = "check" 
                })
            else
                PlayerDropdown:Refresh({"No players"})
                WindUI:Notify({ 
                    Title = "Info", 
                    Content = "No other players in server", 
                    Duration = 2, 
                    Icon = "info" 
                })
            end
        end
    })

    PlayerSection:Button({
        Title = "Teleport to Player",
        Desc = "Teleport ke player yang dipilih",
        Icon = "users",
        Callback = function()
            if SelectedPlayer and SelectedPlayer ~= "No players" then
                TeleportToPlayer(SelectedPlayer)
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Pilih player terlebih dahulu!", 
                    Duration = 2, 
                    Icon = "alert-triangle" 
                })
            end
        end
    })

    -- Auto refresh player list when player joins/leaves
    game.Players.PlayerAdded:Connect(function()
        task.wait(1)
        UpdatePlayerList()
        if PlayerDropdown then
            PlayerDropdown:Refresh(#PlayerList > 0 and PlayerList or {"No players"})
        end
    end)

    game.Players.PlayerRemoving:Connect(function()
        task.wait(1)
        UpdatePlayerList()
        if PlayerDropdown then
            PlayerDropdown:Refresh(#PlayerList > 0 and PlayerList or {"No players"})
        end
    end)
end

------------
-- tab event
------------

local function loadTabEvent()

    ----------------------------------------------------
    -- 🎁 LIMITED EVENT SECTION (PIRATE & SANTA)
    ----------------------------------------------------
    local LimitedSection = EventTab:Section({ Title = "Limited Event", Opened = true })

    -- [[ LOGIC PIRATE COVE DARI SCRIPT KAMU ]] --
    local function activatePrompt(prompt)
        if not prompt or not prompt.Enabled then return end
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin()
            if prompt.HoldDuration > 0 then
                task.wait(prompt.HoldDuration)
            end
            prompt:InputHoldEnd()
        end
    end

    local function teleportAndInteract()
        local player = game.Players.LocalPlayer -- Definisi player
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            warn("Karakter belum siap!")
            return
        end
        local rootPart = character.HumanoidRootPart

        -- TAHAP 1: AMBIL SEMUA TNT
        local folderAda, tntFolder = pcall(function() 
            return workspace:WaitForChild("!!! SEARCH ITEM SPAWNS"):WaitForChild("TNT") 
        end)
        
        if folderAda and tntFolder then
            print("--- Memulai Pengambilan TNT ---")
            
            for _, item in pairs(tntFolder:GetChildren()) do
                if not player.Character then break end
                rootPart = player.Character:WaitForChild("HumanoidRootPart")

                local targetCFrame = nil
                if item:IsA("Model") then
                    targetCFrame = item:GetPivot()
                elseif item:IsA("BasePart") then
                    targetCFrame = item.CFrame
                end

                if targetCFrame then
                    rootPart.CFrame = targetCFrame
                    task.wait(0.2) 

                    local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        activatePrompt(prompt)
                    end
                    task.wait(0.5) 
                end
            end
        end

        print("--- Semua TNT Selesai! Menuju Pirate's Cove... ---")
        
        -- TAHAP 2: TELEPORT KE PIRATE'S COVE (FIXED PATH)
        local islands = workspace:WaitForChild("Islands")
        local cove = islands:WaitForChild("Pirate's Cove")
        local wall = cove:WaitForChild("PirateCoveWall")
        local promptPart = wall:WaitForChild("Prompt") 
        local finalPrompt = promptPart:WaitForChild("ProximityPrompt")
        
        if not player.Character then return end
        rootPart = player.Character:WaitForChild("HumanoidRootPart")
        
        if promptPart and finalPrompt then
            rootPart.CFrame = promptPart.CFrame
            task.wait(0.3) 
            
            print("Mengaktifkan Prompt Terakhir...")
            activatePrompt(finalPrompt)
            print("SELESAI!")
        else
            warn("Path ke Prompt Pirate's Cove salah atau belum loading!")
        end
        task.wait(0.5)
        
        rootPart.CFrame = CFrame.new(3414.21558, 10.1964693, 3382.90698, 0.988952875, -3.56650638e-08, 0.148230448, 3.63117536e-08, 1, -1.65651781e-09, -0.148230448, 7.02072533e-09, 0.988952875)
    end

    LimitedSection:Button({
        Title = "Open Pirate Cove Wall",
        Desc = "Open Wall to Maze (Ambil TNT -> Buka Wall)",
        Callback = function()
            local args = { "Carpenter", 2, 1 }
            -- Fire remote dialogue
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/DialogueEnded"):FireServer(unpack(args))
            end)
            task.wait(0.5)
            teleportAndInteract()
        end
    })

    -- [[ LOGIC AUTO SANTA DARI SCRIPT KAMU ]] --
    local FactoryThread = nil

    local function AutoSantaLogic()
        -- Load Dependencies lokal biar aman
        local Replion = require(ReplicatedStorage.Packages.Replion)
        local Net = ReplicatedStorage.Packages._Index:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
        local EquipItemRemote = Net:FindFirstChild("RE/EquipItem")
        local HotbarRemote = Net:FindFirstChild("RE/EquipToolFromHotbar")
        local success, data = pcall(function() return Replion.Client:WaitReplion("Data", 5) end)

        local Presents = {}

        local function getPresentsID()
            local playerData = Replion.Client:WaitReplion("Data", 5)
            if not playerData then return {} end
                    
            local inventory = playerData:GetExpect("Inventory")
            if not inventory or not inventory.Items then return {} end

            local processCount = 0
            Presents = {}

            for _, invItem in pairs(inventory.Items) do
                if invItem.Id == 996 or invItem.Id == 997 or invItem.Id == 998 or invItem.Id == 999 then
                    processCount = processCount + 1
                    table.insert(Presents, invItem.UUID)
                end
            end
            print("Found " .. processCount .. " Present to submit.")
        end

        local function EquipSpecificPresent(uuid)
                pcall(EquipItemRemote.FireServer, EquipItemRemote, uuid, "Gears")
                local assignedSlot = nil
                local startTime = tick()
                repeat
                    local equipped = data:Get("EquippedItems")
                    if equipped then
                        for slot, id in pairs(equipped) do
                            if id == uuid then assignedSlot = tonumber(slot) break end
                        end
                    end
                    task.wait(0.1)
                until assignedSlot or (tick() - startTime > 3)
                
                if assignedSlot then
                    pcall(HotbarRemote.FireServer, HotbarRemote, assignedSlot)
                    task.wait(0.1)
                    return true
                end
                return false
        end

        while true do
            getPresentsID()
            for _, uuid in pairs(Presents) do
                EquipSpecificPresent(uuid)
                task.wait(0.2)
                pcall(function()
                    game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net["RF/RedeemGift"]:InvokeServer()
                end)
                task.wait(0.1)
            end
            task.wait(0.2)
        end
    end

    LimitedSection:Toggle({
        Title = "Auto Present Factory",
        Desc = "Otomatis Submit semua present ke Santa",
        Value = false,
        Callback = function(Value)
            if Value then
                FactoryThread = task.spawn(function()
                    AutoSantaLogic()
                end)
                WindUI:Notify({ Title = "Auto Santa", Content = "Auto Santa Aktif", Duration = 3, Icon = "check" })
            else
                if FactoryThread then
                    task.cancel(FactoryThread)
                    FactoryThread = nil
                end
                WindUI:Notify({ Title = "Auto Santa", Content = "Auto Santa Mati", Duration = 3, Icon = "x" })
            end
        end
    })

    -- ===== SETTINGS =====
    local Settings = {
        Enabled = true,
        
        AutoEquipItem = true,
        ItemIDToEquip = 20220,  -- Crystal Detector item
        
        TPDelay = 0.3,          -- Delay setelah TP
        InteractDelay = 0.2,    -- Delay setelah interact
    }

    -- ===== VARIABLES =====
    local isRunning = false

    -- Get item UUID by ID from inventory
    local function getItemUUIDByID(data, itemId)
        local inventory = data:GetExpect("Inventory")
        if not inventory or not inventory.Items then 
            return nil 
        end
        
        for _, invItem in pairs(inventory.Items) do
            if invItem.Id == itemId then
                return invItem.UUID
            end
        end
        
        return nil
    end

    -- Equip item by ID (proper method)
    local function equipItem(itemId)
        if not Settings.AutoEquipItem then
            print("⚠️  Auto-equip disabled, assuming item already equipped")
            return true
        end
        
        print("🎒 Equipping item ID: " .. itemId .. "...")
        
        local success, result = pcall(function()
            local Replion = require(ReplicatedStorage.Packages.Replion)
            local Net = ReplicatedStorage.Packages._Index:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
            local EquipItemRemote = Net:FindFirstChild("RE/EquipItem")
            local HotbarRemote = Net:FindFirstChild("RE/EquipToolFromHotbar")
            
            -- Get player data
            local data = Replion.Client:WaitReplion("Data", 5)
            if not data then
                warn("❌ Failed to get player data")
                return false
            end
            
            -- Get item UUID
            local uuid = getItemUUIDByID(data, itemId)
            if not uuid then
                warn("❌ Item ID " .. itemId .. " not found in inventory!")
                return false
            end
            
            print("📦 Found item UUID: " .. uuid)
            
            -- Step 1: Fire EquipItem remote
            pcall(EquipItemRemote.FireServer, EquipItemRemote, uuid, "Gears")
            
            -- Step 2: Wait for item to appear in EquippedItems and get slot
            local assignedSlot = nil
            local startTime = tick()
            
            repeat
                local equipped = data:Get("EquippedItems")
                if equipped then
                    for slot, id in pairs(equipped) do
                        if id == uuid then 
                            assignedSlot = tonumber(slot)
                            break 
                        end
                    end
                end
                task.wait(0.1)
            until assignedSlot or (tick() - startTime > 3)
            
            if not assignedSlot then
                warn("❌ Failed to get hotbar slot (timeout)")
                return false
            end
            
            print("🎰 Item assigned to slot: " .. assignedSlot)
            
            -- Step 3: Equip from hotbar
            pcall(HotbarRemote.FireServer, HotbarRemote, assignedSlot)
            task.wait(0.3)
            
            print("✅ Item equipped successfully!")
            return true
        end)
        
        if success and result then
            return true
        else
            warn("❌ Failed to equip item: " .. tostring(result))
            return false
        end
    end

    -- Get all crystals with ProximityPrompt
    local function getCrystalsWithPrompt()
        local crystals = {}
        
        local success, crystalFolder = pcall(function()
            return workspace.Islands["Crystal Depths"].Crystals
        end)
        
        if not success or not crystalFolder then
            warn("❌ Crystal Depths not found!")
            return crystals
        end
        
        for _, crystal in pairs(crystalFolder:GetChildren()) do
            local prompt = crystal:FindFirstChild("ProximityPrompt", true)
            if prompt then
                table.insert(crystals, {
                    Model = crystal,
                    Prompt = prompt
                })
            end
        end
        
        return crystals
    end

    -- TP to crystal
    local function tpToCrystal(crystal)
        local char = game.Players.LocalPlayer.Character
        if not char then return false end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        
        -- Get crystal position
        local targetPos = crystal:GetPivot()
        
        -- TP with offset (slightly above)
        hrp.CFrame = targetPos * CFrame.new(0, 3, 0)
        
        return true
    end

    -- Interact with ProximityPrompt
    local function interactPrompt(prompt)
        if not prompt or not prompt.Enabled then
            return false
        end
        
        -- Fire proximity prompt
        fireproximityprompt(prompt)
        return true
    end

    -- Main collection function
    local function collectCrystals()
        local oldLocation = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame or nil

        if isRunning then return end -- Prevent double run
        isRunning = true
        
        -- Step 1: Equip item
        if not equipItem(Settings.ItemIDToEquip) then
            warn("❌ not equipped pickace, aborting...")
            isRunning = false
            return
        end

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5808.42529, -899.366394, 15353.1709, -0.997745156, 3.95877414e-10, 0.0671164095, 4.13268725e-10, 1, 2.45237053e-10, -0.0671164095, 2.72421197e-10, -0.997745156)
        
        task.wait(1.5)
        
        local crystals = getCrystalsWithPrompt()
        
        if #crystals == 0 then
            warn("❌ No crystals found!")
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldLocation
            isRunning = false
            return
        end
        
        print("✅ Found " .. #crystals .. " crystals to collect")
        
        -- Step 3: TP & Interact each crystal
        local collected = 0
        
        for i, crystalData in pairs(crystals) do
            if not Settings.Enabled then
                break
            end
            
            
            -- TP to crystal
            local tpSuccess = tpToCrystal(crystalData.Model)
            if not tpSuccess then
                continue
            end
            
            task.wait(Settings.TPDelay)
            
            -- Interact
            local interactSuccess = interactPrompt(crystalData.Prompt)
            if interactSuccess then
                collected = collected + 1
            else
            end
            
            task.wait(Settings.InteractDelay)
        end
        
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldLocation
        isRunning = false -- Release lock
    end

    -- ===== REMOTE LISTENER =====

    local function StartListener()
        local Net = ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0")
        if not Net then warn("❌ Net package not found!") return end
        
        local NotificationRemote = Net.net:FindFirstChild("RE/TextNotification")
        if not NotificationRemote then warn("❌ Notification Remote not found!") return end
        
        -- [PENTING] Cek apakah ada listener lama yang masih jalan, kalau ada matikan dulu
        if getgenv().CrystalJobConnection then
            getgenv().CrystalJobConnection:Disconnect()
        end
        
        
        -- Simpan koneksi ke variabel global 'CrystalJobConnection'
        getgenv().CrystalJobConnection = NotificationRemote.OnClientEvent:Connect(function(data)
            if type(data) == "table" and data.Text then
                if string.find(string.lower(data.Text), "crystals are glowing") then
                    
                    if not isRunning then
                        task.spawn(collectCrystals)
                    else
                    end
                end
            end
        end)
    end

    LimitedSection:Toggle({
        Title = "Auto Mining Crystal",
        Desc = "Otomatis mining semua crystal",
        Value = false,
        Callback = function(Value)
            if Value then
                collectCrystals()
                task.wait(1)
                StartListener()
                WindUI:Notify({ Title = "Auto Crystal", Content = "Auto Crystal Aktif", Duration = 3, Icon = "check" })
            else
                -- SCRIPT PEMUTUS HUBUNGAN (KILL SWITCH)
                if getgenv().CrystalJobConnection then
                    getgenv().CrystalJobConnection:Disconnect()
                    getgenv().CrystalJobConnection = nil
                    
                    -- Opsional: Matikan variabel settings juga
                    getgenv().isRunning = false 
                end
                WindUI:Notify({ Title = "Auto Crystal", Content = "Auto Crystal Mati", Duration = 3, Icon = "x" })
            end
        end
    })

    ----------------------------------------------------
    -- 🎯 TELEPORT TO EVENT SECTION
    ----------------------------------------------------
    local EventSection = EventTab:Section({ Title = "Event Teleport", Opened = true })

    EventSection:Paragraph({
        Title = "Event Teleport System",
        Content = "Teleport otomatis ke lokasi event seperti Megalodon Hunt, Shark Hunt, dan lainnya."
    })

    -- Variables
    local selectedEvent = "Megalodon Hunt"
    local teleportEnabled = false
    local bodyVelocity = nil
    local lastPosition = nil
    local hackerThread = nil

    -- Function untuk cari lokasi event (LOGIC PERSIS DARI KODE MU)
    local function findEventLocation(eventName)
        if not workspace then return nil end
        
        if eventName == "Megalodon Hunt" then
            for _, child in pairs(workspace:GetChildren()) do
                local megalodon = child:FindFirstChild("Megalodon Hunt")
                if megalodon and megalodon:IsA("Model") then
                    return megalodon.PrimaryPart or megalodon:FindFirstChildWhichIsA("BasePart")
                end
            end
        
        elseif eventName == "Ghost Shark Hunt" then
            for _, child in pairs(workspace:GetChildren()) do
                local ghostShark = child:FindFirstChild("Ghost Shark Hunt")
                if ghostShark and ghostShark:IsA("Model") then
                    return ghostShark.PrimaryPart or ghostShark:FindFirstChildWhichIsA("BasePart")
                end
            end
        
        elseif eventName == "Shark Hunt" then
            for _, child in pairs(workspace:GetChildren()) do
                local shark = child:FindFirstChild("Shark Hunt")
                if shark and shark:IsA("Model") then
                    return shark.PrimaryPart or shark:FindFirstChildWhichIsA("BasePart")
                end
            end
        
        elseif eventName == "Worm Fish" then
            for _, child in pairs(workspace:GetChildren()) do
                local model = child:FindFirstChild("Model")
                if model and model:IsA("Model") then
                    local children = model:GetChildren()
                    if #children >= 3 then
                        local thirdChild = children[3]
                        if thirdChild and thirdChild:IsA("BasePart") then
                            return thirdChild
                        end
                    end
                end
            end
        end
        
        return nil
    end

    -- Function freeze position
    local function freezePosition(position)
        local char = LocalPlayer.Character
        if not char then return end
        
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        bodyVelocity.P = 10000
        bodyVelocity.Parent = rootPart
        rootPart.CFrame = CFrame.new(position)
    end

    -- Function unfreeze
    local function unfreezePosition()
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end

    -- Function save position
    local function saveCurrentPosition()
        local char = LocalPlayer.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        lastPosition = rootPart.CFrame
    end

    -- Function balik ke posisi awal
    local function returnToLastPosition()
        if not lastPosition then return end
        unfreezePosition()
        local char = LocalPlayer.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        rootPart.CFrame = lastPosition
    end

    -- Function teleport ke event
    local function teleportToEvent(EventName)
        local onLocation = false
        saveCurrentPosition()
        task.wait(0.5)
        while teleportEnabled do
            local eventPart = findEventLocation(EventName)
            if eventPart then 
                if not onLocation then
                    local char = LocalPlayer.Character
                    if not char then return false end
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    if not rootPart then return false end
                    
                    -- Random offset biar ga stuck
                    local randomX = eventPart.Position.X + math.random(-10, 10)
                    local randomZ = eventPart.Position.Z + math.random(-10, 10)
                    local yOffset = eventPart.Position.Y + 50
                    
                    local targetPosition = Vector3.new(randomX, yOffset, randomZ)
                    pcall(function()
                        freezePosition(targetPosition)
                    end)
                    onLocation = true
                end
            else
                if onLocation then
                    returnToLastPosition()
                    onLocation = false
                end
            end
            task.wait(1)
        end
    end

    -- Dropdown pilih event (DISAVE)
    AddSave("EventSelectDropdown", EventSection:Dropdown({
        Title = "Select Event",
        Values = {"Megalodon Hunt", "Ghost Shark Hunt", "Shark Hunt", "Worm Fish"},
        Value = selectedEvent,
        Multi = false,
        Callback = function(Value)
            selectedEvent = Value
            
            -- [[ TAMBAHAN: Cek loading dulu biar gak spam notif ]]
            if not isScriptLoading then
                WindUI:Notify({ 
                    Title = "Event Selected", 
                    Content = "You chose: " .. Value, 
                    Duration = 2 
                })
            end
        end
    }))

    -- Toggle teleport & freeze (DISAVE)
    AddSave("EventTeleportToggle", EventSection:Toggle({
        Title = "Teleport to Event",
        Desc = "Auto teleport & freeze di lokasi event",
        Value = false,
        Callback = function(Value)
            teleportEnabled = Value
            if Value then
                task.spawn(function()
                    teleportToEvent(selectedEvent)
                end)
                WindUI:Notify({ Title = "Event Teleport", Content = "Teleported to " .. selectedEvent, Duration = 3, Icon = "check" })
            else
                returnToLastPosition()
                WindUI:Notify({ Title = "Event Teleport", Content = "Returned to last position", Duration = 2, Icon = "info" })
            end
        end
    }))

    -- HACKER EVENT LOGIC
    local hacker = nil

    local function teleportToHacker()
        for _, item in pairs(workspace:GetChildren()) do
            if item.Name == "Props" then
                local possibleTarget = item:FindFirstChild("Black Hole")
                if possibleTarget then
                    hacker = possibleTarget
                    break 
                end
            end
        end
        if hacker then
            local hackerPivot = hacker:GetPivot()
            local targetCFrame = hackerPivot + Vector3.new(0, -130, 0)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = targetCFrame
            end
        end
    end

    -- Toggle Hacker Event (DISAVE)
    AddSave("HackerEventToggle", EventSection:Toggle({
        Title = "Teleport to Hacker Event",
        Desc = "Auto teleport & freeze di lokasi event",
        Value = false,
        Callback = function(Value)
            if Value then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    lastPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
                end
                
                hackerThread = task.spawn(function()
                    while true do
                        teleportToHacker()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local pos = LocalPlayer.Character.HumanoidRootPart.Position
                            freezePosition(pos)
                        end
                        task.wait(1)
                    end
                end)
                WindUI:Notify({ Title = "Event Teleport", Content = "Teleported to Hacker Event", Duration = 3, Icon = "check" })
            else
                if hackerThread then
                    task.cancel(hackerThread)
                    hackerThread = nil
                end
                returnToLastPosition()
                WindUI:Notify({ Title = "Event Teleport", Content = "Returned to last position", Duration = 2, Icon = "info" })
            end
        end
    }))


    ----------------------------------------------------
    -- 🏛️ ADMIN EVENT SECTION (ANCIENT)
    ----------------------------------------------------
    local AdminEvent = EventTab:Section({ Title = "Admin Event Teleport", Opened = true })

    local AncientThread = nil
    local inAncient = false

    local function teleLocation(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = val
        end
    end

    local function startAncient()
        AncientThread = task.spawn(function()
            local oldLocation = nil
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                oldLocation = LocalPlayer.Character.HumanoidRootPart.CFrame
            end

            local possibleLocations = {
                CFrame.new(6004.65723, -585.924683, 4668.50098, 0.133287504, 1.14295382e-08, -0.991077423, -1.43028247e-08, 1, 9.60888702e-09, 0.991077423, 1.28944615e-08, 0.133287504),
                CFrame.new(6032.07861, -585.924194, 4621.81104, -0.485085577, 5.42905418e-08, -0.874466658, 2.6711453e-09, 1, 6.06024315e-08, 0.874466658, 2.70615388e-08, -0.485085577),
                CFrame.new(6097.37549, -585.924683, 4670.46924, -0.0517133214, 1.92589189e-09, 0.998661995, 8.37135019e-08, 1, 2.40643105e-09, -0.998661995, 8.37259364e-08, -0.0517133214),
                CFrame.new(6048.59082, -585.924683, 4714.64258, 0.999989688, -7.29190006e-08, -0.00454619853, 7.31706464e-08, 1, 5.51861596e-08, 0.00454619853, -5.55182389e-08, 0.999989688),
                CFrame.new(6071.62695, -585.924194, 4711.09277, 0.784384608, -1.03745997e-07, 0.620274782, 9.13267968e-08, 1, 5.17684455e-08, -0.620274782, 1.60413389e-08, 0.784384608),
                CFrame.new(6082.60889, -585.924194, 4700.89893, 0.7194435, 1.01807021e-10, 0.694550991, -8.44169012e-10, 1, 7.27844174e-10, -0.694550991, -1.10996123e-09, 0.7194435),
            }

            local location = possibleLocations[math.random(1, #possibleLocations)]
            local teleOldLocation = true
            
            while true do
                pcall(function()
                    local tracker = workspace:FindFirstChild("!!! DEPENDENCIES") 
                                    and workspace["!!! DEPENDENCIES"]:FindFirstChild("Event Tracker")
                    
                    if tracker then
                        local text = tracker.Main.Gui.Content.Items.Countdown.Header.Text

                        if text ~= "STARTS IN:" then
                            teleOldLocation = true
                            inAncient = true
                            teleLocation(location)
                        else
                            if teleOldLocation then
                                if oldLocation then teleLocation(oldLocation) end
                                location = possibleLocations[math.random(1, #possibleLocations)]
                            else
                                inAncient = false
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    oldLocation = LocalPlayer.Character.HumanoidRootPart.CFrame
                                end
                            end
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and oldLocation == LocalPlayer.Character.HumanoidRootPart.CFrame then
                                teleOldLocation = false
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end

    -- Info: Countdown Timer (TIDAK PERLU SAVE)
    local AncientTimerUI = AdminEvent:Paragraph({
        Title = "Countdown Ancient Lochness",
        Content = "Waiting for data..."
    })

    -- Realtime UI Update Loop
    task.spawn(function()
        while true do
            pcall(function()
                local tracker = workspace:FindFirstChild("!!! DEPENDENCIES") 
                                and workspace["!!! DEPENDENCIES"]:FindFirstChild("Event Tracker")
                if tracker then
                    local header = tracker.Main.Gui.Content.Items.Countdown.Header.Text
                    if header == "STARTS IN:" then
                        local timerText = tracker.Main.Gui.Content.Items.Countdown.Label.Text
                        if AncientTimerUI.SetDesc then
                            AncientTimerUI:SetDesc(timerText)
                        else
                            AncientTimerUI.Content = timerText -- Fallback
                        end
                    else
                        if AncientTimerUI.SetDesc then AncientTimerUI:SetDesc("EVENT ACTIVE!") end
                    end
                end
            end)
            task.wait(1)
        end
    end)

    -- Toggle Ancient Event (DISAVE)
    AddSave("AncientEventToggle", AdminEvent:Toggle({
        Title = "Auto Ancient Ruin Event",
        Desc = "Auto teleport & freeze di lokasi event",
        Value = false,
        Callback = function(Value)
            if Value then
                startAncient()
                WindUI:Notify({ Title = "Ancient Event Teleport", Content = "Auto Teleport Started", Duration = 3, Icon = "check" })
            else
                if AncientThread then
                    task.cancel(AncientThread)
                    AncientThread = nil
                end
                WindUI:Notify({ Title = "Ancient Event Teleport", Content = "Auto Teleport Stopped", Duration = 2, Icon = "x" })
            end
        end
    }))
end

------------
-- tab webhook (SAVED)
------------

local function loadTabWebhook()
    
    local WebhookSection = WebhookTab:Section({ Title = "Discord Webhook Configuration", Opened = true })

    -- [VARIABLES]
    local RS = game:GetService("ReplicatedStorage")
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- [MODULE LOAD SAFE]
    local TierUtility = nil
    pcall(function()
        local Shared = RS:WaitForChild("Shared", 5)
        if Shared then
            TierUtility = require(Shared:WaitForChild("TierUtility", 5))
        end
    end)

    local TierMap = {[1]="Common",[2]="Uncommon",[3]="Rare",[4]="Epic",[5]="Legendary",[6]="Mythic",[7]="SECRET"}
    local FishData = {}
    local FishImages = {}
    
    local WebhookState = {
        enabled = false, 
        url = "", 
        rarities = {}, 
        connection = nil, 
        serverConnection = nil,
        mode = "Player"
    }

    local LOGO_URL = "https://raw.githubusercontent.com/zuperminghub/Zuperming-Code/refs/heads/main/image.png"
    local FISH_DB_URL = "https://raw.githubusercontent.com/vandawam2/REPONAME/refs/heads/main/fish.json" -- GANTI REPONAME JIKA PERLU

    local RARITY_COLORS = {
        Common = 0xFFFAF6, Uncommon = 0xC3FF55, Rare = 0x55A2FF, Epic = 0xAD4FFF,
        Legendary = 0xFFB82A, Mythic = 0xFF1818, SECRET = 0x17FF97
    }

    ----------------------------------------------------
    -- FUNCTIONS
    ----------------------------------------------------

    local function LoadFishImages()
        task.spawn(function()
            local req = (syn and syn.request) or (http and http.request) or http_request or request
            if not req then return end
            
            local ok, response = pcall(req, {Url=FISH_DB_URL, Method="GET"})
            if ok and response and response.Body then
                local success, data = pcall(HttpService.JSONDecode, HttpService, response.Body)
                if success and data then
                    for _, fish in pairs(data) do
                        if fish.name and fish.image then 
                            FishImages[fish.name] = fish.image
                        elseif fish.name and fish.imageUrl then
                            FishImages[fish.name] = fish.imageUrl
                        end
                    end
                    -- print("Webhook: Loaded Images for fishes") 
                end
            end
        end)
    end

    local function ScanFish()
        task.wait(1) 
        local folder = RS:WaitForChild("Items", 5)
        if not folder then return end
        
        for _, m in ipairs(folder:GetDescendants()) do
            if m:IsA("ModuleScript") then
                local ok, d = pcall(require, m)
                if ok and d and d.Data then
                    local realTier = d.Data.Tier or 1
                    if d.Probability and d.Probability.Chance and TierUtility then
                        local s, tInfo = pcall(function() return TierUtility:GetTierFromRarity(d.Probability.Chance) end)
                        if s and tInfo then realTier = tInfo.Tier end
                    end
                    
                    if d.Data.Id and d.Data.Name then
                        FishData[d.Data.Id] = {
                            name = tostring(d.Data.Name), 
                            tier = realTier
                        }
                    end
                end
            end
        end
        -- print("Webhook: Scanned Fish Data") 
    end

    local function SendWebhook(fishId, weight, mutation, targetPlayer)
        if not WebhookState.enabled or WebhookState.url == "" then return end
        
        local fish = FishData[fishId]
        if not fish then return end 
        
        local rarity = TierMap[fish.tier] or "Unknown"
        
        if not WebhookState.rarities[rarity] then return end
        
        local weightStr = type(weight) == "number" and string.format("%.2f Kg", weight) or "N/A"
        local mutationStr = type(mutation) == "string" and string.format(mutation) or "-"
        local username = targetPlayer and ("||"..targetPlayer.Name.."||") or "||Unknown||"
        
        local embed = {
            title = "🎣 New Fish Caught!",
            description = string.format("**%s** caught a **%s** fish!", username, rarity),
            color = RARITY_COLORS[rarity] or 0x00FFAA,
            author = {name="Zuperming Hub", icon_url=LOGO_URL},
            fields = {
                {name="🐟 Fish", value="```\n"..fish.name.."\n```", inline=false},
                {name="✨ Mutation", value="```\n"..mutationStr.."\n```", inline=false},
                {name="⚖️ Weight", value="```\n"..weightStr.."\n```", inline=true},
                {name="⭐ Tier", value="```\n"..rarity.."\n```", inline=true}
            },
            footer = {text="Zuperming • Mode: "..WebhookState.mode, icon_url=LOGO_URL},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
        
        if FishImages[fish.name] then 
            embed.thumbnail = {url=FishImages[fish.name]}
        end
        
        local payload = {username="Zuperming Bot", avatar_url=LOGO_URL, embeds={embed}, content = "|| @everyone ||"}
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        
        if req then
            task.spawn(function()
                pcall(req, {
                    Url = WebhookState.url,
                    Method = "POST",
                    Headers = {["Content-Type"]="application/json"},
                    Body = HttpService:JSONEncode(payload)
                })
            end)
        end
    end

    local function ConnectEvent()
        if WebhookState.connection then WebhookState.connection:Disconnect() WebhookState.connection = nil end
        if WebhookState.serverConnection then WebhookState.serverConnection:Disconnect() WebhookState.serverConnection = nil end
        
        if not WebhookState.enabled then return end
        
        local net = RS.Packages._Index:FindFirstChild("sleitnick_net@0.2.0")
        if not net then return end
        local NetFolder = net.net
        
        if WebhookState.mode == "Player" then
            local event = NetFolder:FindFirstChild("RE/ObtainedNewFishNotification")
            if event then
                WebhookState.connection = event.OnClientEvent:Connect(function(fishId, weightData)
                    local w = type(weightData) == "table" and weightData.Weight or weightData
                    local m = type(weightData) == "table" and weightData.VariantId or (type(weightData) == "table" and weightData.Shiny == true and "Shiny") or "-"
                    SendWebhook(fishId, w, m, LocalPlayer)
                end)
            end
        elseif WebhookState.mode == "Server" then
            local event = NetFolder:FindFirstChild("RE/CaughtFishVisual")
            if event then
                WebhookState.serverConnection = event.OnClientEvent:Connect(function(targetPlayer, position, fishName, weightData)
                    local fishId = nil
                    for id, data in pairs(FishData) do
                        if data.name == fishName then fishId = id break end
                    end
                    
                    if fishId then
                        local w = type(weightData) == "table" and weightData.Weight or weightData
                        local m = type(weightData) == "table" and weightData.VariantId or (type(weightData) == "table" and weightData.Shiny == true and "Shiny") or "-"
                        SendWebhook(fishId, w, m, targetPlayer)
                    end
                end)
            end
        end
    end

    task.spawn(ScanFish)
    task.spawn(LoadFishImages)


    -- [UI ELEMENTS - SAVED]

    AddSave("WebhookUrlInput", WebhookSection:Input({
        Title = "Webhook Url", 
        Desc = "Link Discord Webhook", 
        Placeholder = "https://discord.com...",
        Callback = function(v) 
            WebhookState.url = v
        end
    }))

    AddSave("WebhookModeDropdown", WebhookSection:Dropdown({
        Title = "Detection Mode", 
        Values = {"Player", "Server"}, 
        Value = "Player", 
        Multi = false,
        Callback = function(v) 
            WebhookState.mode = v; 
            if WebhookState.enabled then ConnectEvent() end 
        end
    }))

    AddSave("WebhookRarityDropdown", WebhookSection:Dropdown({
        Title = "Rarity Filter", 
        Values = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","SECRET"}, 
        Value = {"SECRET"}, 
        Multi = true,
        Callback = function(v) 
            if type(v) ~= "table" then return end
            local newMap = {}
            for _, val in pairs(v) do
                newMap[val] = true
            end
            WebhookState.rarities = newMap
        end
    }))

    AddSave("WebhookEnableToggle", WebhookSection:Toggle({
        Title = "Enable Webhook", 
        Value = false,
        Callback = function(v)
            WebhookState.enabled = v
            if v then
                ConnectEvent()
                if not isScriptLoading then
                    WindUI:Notify({
                        Title = "Webhook Activated",
                        Content = "Mode: " .. WebhookState.mode,
                        Duration = 3,
                        Icon = "check"
                    })
                end
            else
                if WebhookState.connection then WebhookState.connection:Disconnect() end
                if WebhookState.serverConnection then WebhookState.serverConnection:Disconnect() end
                
                if not isScriptLoading then
                    WindUI:Notify({
                        Title = "Webhook Deactivated",
                        Content = "Logger Stopped",
                        Duration = 3,
                        Icon = "x"
                    })
                end
            end
        end
    }))
end

------------
-- tab performance
------------

local function loadTabPerformance()

    local PerformanceSection = PerformanceTab:Section({ Title = "Optimization", Opened = true })

    -- [[ 4. ULTRA OPTIMIZER (LOGIC DARI KAMU) ]]
    PerformanceSection:Button({
        Title = "Ultra FPS Boost + Flat Water",
        Desc = "EXTREME: Hapus efek, air jadi datar, smooth plastic (Potato Mode)",
        Icon = "solar:rocket-2-bold",
        Callback = function()
            WindUI:Notify({ Title = "Optimizer", Content = "Memulai optimasi ekstrem...", Icon = "info" })
            
            task.spawn(function()
                local Lighting = game:GetService("Lighting")
                local Workspace = game:GetService("Workspace")
                local Terrain = Workspace:FindFirstChildOfClass("Terrain")
                
                -- 1. NUKE VISUAL EFFECTS & LIGHTING
                pcall(function()
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 9e9
                    Lighting.Brightness = 0
                    Lighting.EnvironmentDiffuseScale = 0
                    Lighting.EnvironmentSpecularScale = 0
                    Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
                    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
                    
                    for _, v in pairs(Lighting:GetChildren()) do
                        if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
                            v:Destroy()
                        end
                    end
                    
                    -- Coba set technology (Support executor tertentu)
                    pcall(function() sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility) end)
                end)

                -- 2. NUKE WATER (FLAT WATER)
                if Terrain then
                    pcall(function()
                        Terrain.WaterWaveSize = 0
                        Terrain.WaterWaveSpeed = 0
                        Terrain.WaterReflectance = 0
                        Terrain.WaterTransparency = 0.3
                        Terrain.Decoration = false
                        Terrain.WaterColor = Color3.fromRGB(12, 84, 92)
                    end)
                end

                -- 3. EXTREME PART OPTIMIZATION
                local optimizedCount = 0
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.CastShadow = false
                        obj.Reflectance = 0
                        
                        -- Hapus tekstur
                        if obj:IsA("MeshPart") then
                            obj.RenderFidelity = Enum.RenderFidelity.Performance
                        end
                        
                        -- Matikan collision dekorasi
                        if obj.Name:lower():find("deco") or obj.Name:lower():find("detail") then
                            obj.CanCollide = false
                        end
                        optimizedCount = optimizedCount + 1
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = 1
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                        obj.Enabled = false
                    end
                end

                -- 4. NETWORK OPTIMIZATION
                if settings then
                    pcall(function()
                        settings().Network.IncomingReplicationLag = 0
                        settings().Network.PhysicsSend = 10
                        settings().Network.PhysicsReceive = 10
                    end)
                end
                
                WindUI:Notify({ 
                    Title = "Success", 
                    Content = "Optimasi Selesai! (" .. optimizedCount .. " parts)", 
                    Icon = "check" 
                })
            end)
        end
    })

    -- [[ NEW: NO ANIMATION (FISHING FREEZE) ]]
    -- Ditaruh di atas Disable Rod Effect sesuai request
    local noAnimConnection = nil
    
    AddSave("NoAnimToggle", PerformanceSection:Toggle({
        Title = "No Animation",
        Desc = "Karakter diam (Freeze) untuk hemat FPS saat mancing",
        Value = false,
        Callback = function(Value)
            if Value then
                -- Aktifkan Logic No Anim
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    local animator = hum and hum:FindFirstChild("Animator")
                    if animator then
                        -- 1. Stop animasi yang sedang jalan
                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                            track:Stop(0)
                        end
                        
                        -- 2. Cegah animasi baru
                        if noAnimConnection then noAnimConnection:Disconnect() end
                        noAnimConnection = animator.AnimationPlayed:Connect(function(track)
                            track:Stop(0)
                        end)
                    end
                end
                if not isScriptLoading then 
                    WindUI:Notify({ Title = "Performance", Content = "Animation Disabled (Freeze)", Duration = 2 }) 
                end
            else
                -- Matikan Logic (Restore)
                if noAnimConnection then 
                    noAnimConnection:Disconnect() 
                    noAnimConnection = nil 
                end
                if not isScriptLoading then 
                    WindUI:Notify({ Title = "Performance", Content = "Animation Restored", Duration = 2 }) 
                end
            end
        end
    }))

    -- [[ 1. DISABLE ROD EFFECTS (VFX) ]]
    local rodVFXDisabled = false
    local originalVFX = nil
    local oldCreate = nil

    AddSave("RodVFXToggle", PerformanceSection:Toggle({
        Title = "Disable Rod Effects",
        Desc = "Matikan efek visual joran (Aura/Trail)",
        Value = false,
        Callback = function(Value)
            rodVFXDisabled = Value
            local Shared = ReplicatedStorage:FindFirstChild("Shared")
            local VFXUtility = Shared and Shared:FindFirstChild("VFXUtility")

            if not VFXUtility then
                return
            end
            
            if Value then
                originalVFX = require(VFXUtility)

                if originalVFX and typeof(originalVFX.CreateContainer) == "function" then
                    oldCreate = originalVFX.CreateContainer
                    originalVFX.CreateContainer = function(...)
                        return nil -- Return nil biar gak ada efek yang ke-create
                    end
                    
                    if not isScriptLoading then
                        WindUI:Notify({ Title = "VFX", Content = "Rod Effects Disabled", Duration = 2 })
                    end
                end
            else
                -- Restore
                if originalVFX and oldCreate then
                    originalVFX.CreateContainer = oldCreate
                    if not isScriptLoading then
                        WindUI:Notify({ Title = "VFX", Content = "Rod Effects Restored", Duration = 2 })
                    end
                end
            end
        end
    }))

    -- [[ 2. DISABLE CUTSCENES (ANTI-CINEMATIC) ]]
    local ProximityPromptService = game:GetService("ProximityPromptService")
    local cutsceneThread = nil

    local function StartAntiCutscene()
        -- A. Override GuiControl
        local successGui, GuiControl = pcall(function() return require(ReplicatedStorage.Modules.GuiControl) end)
        if successGui and GuiControl then
            GuiControl.FishingLock = function(self)
                self._fishingLocked = false
                self._locked = false
            end
            local originalSetHUD = GuiControl.SetHUDVisibility
            GuiControl.SetHUDVisibility = function(self, visible)
                return originalSetHUD(self, true) -- Force True
            end
            if GuiControl.FishingUnlock then GuiControl:FishingUnlock() end
            GuiControl._fishingLocked = false
        end

        -- B. Override CutsceneController
        local successCutscene, CutsceneController = pcall(function() return require(ReplicatedStorage.Controllers.CutsceneController) end)
        if successCutscene and CutsceneController then
            CutsceneController.Play = function() 
                if GuiControl then GuiControl._fishingLocked = false end
                LocalPlayer:SetAttribute("InCutscene", false)
                LocalPlayer:SetAttribute("IgnoreFOV", false)
                return 
            end
        end

        -- C. Nullify Individual Cutscenes
        local CutscenesFolder = ReplicatedStorage.Controllers.CutsceneController:FindFirstChild("Cutscenes")
        if CutscenesFolder then
            for _, module in pairs(CutscenesFolder:GetChildren()) do
                if module:IsA("ModuleScript") then
                    task.spawn(function()
                        local s, m = pcall(require, module)
                        if s and m then m.Play = function() end end
                    end)
                end
            end
        end

        -- Loop Monitoring
        while true do
            if GuiControl and GuiControl._fishingLocked then
                GuiControl._fishingLocked = false
                GuiControl._locked = false
            end
            if LocalPlayer:GetAttribute("InCutscene") then
                LocalPlayer:SetAttribute("InCutscene", false)
            end
            if not ProximityPromptService.Enabled then
                ProximityPromptService.Enabled = true
            end
            task.wait(0.1) 
        end
    end

    AddSave("CutsceneToggle", PerformanceSection:Toggle({
        Title = "Disable Cutscenes",
        Desc = "Skip semua animasi sinematik ikan/bos",
        Value = false,
        Callback = function(Value)
            if Value then
                if not isScriptLoading then WindUI:Notify({ Title = "Cutscene", Content = "Disabled", Duration = 2 }) end
                cutsceneThread = task.spawn(StartAntiCutscene)
            else
                if not isScriptLoading then WindUI:Notify({ Title = "Cutscene", Content = "Restored", Duration = 2 }) end
                if cutsceneThread then task.cancel(cutsceneThread) end
            end
        end
    }))

    -- [[ 3. DISABLE NOTIFICATIONS ]]
    local notifDisabled = false
    AddSave("NotificationToggle", PerformanceSection:Toggle({
        Title = "Disable Pop-Up Notifications",
        Desc = "Blokir pop-up yang mengganggu",
        Value = false,
        Callback = function(Value)
            notifDisabled = Value
            local playerGui = LocalPlayer:WaitForChild("PlayerGui")
            if Value then
                task.spawn(function()
                    while notifDisabled do
                        pcall(function()
                            local notifGui = playerGui:FindFirstChild("Small Notification")
                            if notifGui then notifGui.Enabled = false end
                        end)
                        task.wait(0.01)
                    end
                end)
                if not isScriptLoading then WindUI:Notify({ Title = "Notification", Content = "Blocked", Duration = 2 }) end
            else
                local notifGui = playerGui:FindFirstChild("Small Notification")
                if notifGui then notifGui.Enabled = true end
                if not isScriptLoading then WindUI:Notify({ Title = "Notification", Content = "Restored", Duration = 2 }) end
            end
        end
    }))

    PerformanceSection:Space()

-- [[ SECTION 2: DRAGGABLE STATS (ULTRA MODERN HUD + MOBILE OPTIMIZED) ]]
local DisplaySection = PerformanceTab:Section({ Title = "Display Performance", Opened = true })

_G.DraggableStatsActive = false
local StatsGuiInstance = nil

-- [SERVICES]
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- [NEW] Helper: Logic Dragging yang Super Smooth di HP & PC
local function MakeDraggableSmooth(Frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        -- Gunakan Tween biar gerakannya halus (Smooth)
        local targetPos = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        -- Instant update tapi smooth render
        Frame.Position = targetPos
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- [NEW] Helper: Logic Auto Scale Khusus Mobile (Force Kecil)
local function MakeResponsiveMobile(frame)
    local uiscale = frame:FindFirstChild("UIScale") or Instance.new("UIScale")
    uiscale.Parent = frame

    local function updateScale()
        local camera = workspace.CurrentCamera
        local isMobile = UIS.TouchEnabled -- Deteksi apakah layar sentuh
        
        if isMobile then
            -- Jika HP, Paksa ukuran jadi 0.55 (Kecil & Pas)
            uiscale.Scale = 0.55 
        elseif camera.ViewportSize.X < 900 then
            -- Jika PC layar kecil / Laptop
            uiscale.Scale = 0.8
        else
            -- PC Monitor Normal
            uiscale.Scale = 1.0 
        end
    end

    updateScale()
    -- Update kalau layar diputar (Landscape/Portrait)
    local conn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    frame.Destroying:Connect(function() conn:Disconnect() end)
end

AddSave("StatsHUDToggle", DisplaySection:Toggle({
    Title = "Show Performance Stats",
    Desc = "Display Real Ping, FPS, and CPU Usage (Mobile Optimized)",
    Value = false,
    Callback = function(Value)
        _G.DraggableStatsActive = Value

        if Value then
            -- [1] SETUP GUI
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "WindUI_ModernStats"
            if gethui then ScreenGui.Parent = gethui()
            elseif game:GetService("CoreGui") then ScreenGui.Parent = game:GetService("CoreGui")
            else ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
            StatsGuiInstance = ScreenGui

            -- [2] MAIN CONTAINER (Glass Effect)
            local MainFrame = Instance.new("Frame")
            MainFrame.Size = UDim2.new(0, 260, 0, 110) 
            MainFrame.Position = UDim2.new(0.5, -130, 0.15, 0)
            MainFrame.BackgroundColor3 = Color3.fromHex("#0f172a") 
            MainFrame.BackgroundTransparency = 0.2 
            MainFrame.BorderSizePixel = 0
            MainFrame.Active = true -- Penting buat touch
            MainFrame.Parent = ScreenGui

            -- PASANG FITUR BARU DI SINI
            MakeDraggableSmooth(MainFrame) -- Dragging Baru
            MakeResponsiveMobile(MainFrame) -- Scale Baru

            -- Styling Utama 
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 16)
            UICorner.Parent = MainFrame

            local UIStroke = Instance.new("UIStroke")
            UIStroke.Color = Color3.fromHex("#38bdf8") 
            UIStroke.Thickness = 2
            UIStroke.Transparency = 0.3
            UIStroke.Parent = MainFrame

            local UIGradient = Instance.new("UIGradient")
            UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHex("#0f172a")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#1e293b"))
            }
            UIGradient.Rotation = 45
            UIGradient.Parent = MainFrame

            -- [3] HEADER
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 35)
            Header.BackgroundTransparency = 1
            Header.Parent = MainFrame

            local Logo = Instance.new("ImageLabel")
            Logo.Size = UDim2.new(0, 24, 0, 24)
            Logo.Position = UDim2.new(0, 12, 0.5, -12)
            Logo.BackgroundTransparency = 1
            Logo.Image = "rbxassetid://84078385121142" 
            Logo.ImageColor3 = Color3.new(1,1,1)
            Logo.Parent = Header

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -50, 1, 0)
            Title.Position = UDim2.new(0, 45, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = "SYSTEM MONITOR"
            Title.Font = Enum.Font.GothamBlack
            Title.TextSize = 14
            Title.TextColor3 = Color3.fromHex("#e2e8f0")
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Header

            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, -24, 0, 1)
            Divider.Position = UDim2.new(0, 12, 0, 35)
            Divider.BackgroundColor3 = Color3.fromHex("#334155")
            Divider.BorderSizePixel = 0
            Divider.Parent = MainFrame

            -- [4] STATS CONTAINER
            local StatsContainer = Instance.new("Frame")
            StatsContainer.Size = UDim2.new(1, -20, 1, -45)
            StatsContainer.Position = UDim2.new(0, 10, 0, 42)
            StatsContainer.BackgroundTransparency = 1
            StatsContainer.Parent = MainFrame

            local UIList = Instance.new("UIListLayout")
            UIList.FillDirection = Enum.FillDirection.Horizontal
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Padding = UDim.new(0, 8)
            UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIList.Parent = StatsContainer

            local function CreateCard(name, unit)
                local Card = Instance.new("Frame")
                Card.Size = UDim2.new(0.31, 0, 1, 0) 
                Card.BackgroundColor3 = Color3.fromHex("#1e293b")
                Card.BackgroundTransparency = 0.5
                Card.Parent = StatsContainer
                
                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 8)
                CardCorner.Parent = Card
                
                local NameLabel = Instance.new("TextLabel")
                NameLabel.Size = UDim2.new(1, 0, 0, 20)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = name
                NameLabel.Font = Enum.Font.GothamMedium
                NameLabel.TextSize = 10
                NameLabel.TextColor3 = Color3.fromHex("#94a3b8")
                NameLabel.Parent = Card
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(1, 0, 0, 30)
                ValueLabel.Position = UDim2.new(0, 0, 0, 15)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = "0"
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextSize = 20 
                ValueLabel.TextColor3 = Color3.new(1,1,1)
                ValueLabel.Parent = Card
                
                local UnitLabel = Instance.new("TextLabel")
                UnitLabel.Size = UDim2.new(1, 0, 0, 15)
                UnitLabel.Position = UDim2.new(0, 0, 1, -15)
                UnitLabel.BackgroundTransparency = 1
                UnitLabel.Text = unit
                UnitLabel.Font = Enum.Font.Gotham
                UnitLabel.TextSize = 10
                UnitLabel.TextColor3 = Color3.fromHex("#64748b")
                UnitLabel.Parent = Card

                local Bar = Instance.new("Frame")
                Bar.Size = UDim2.new(0.6, 0, 0, 2)
                Bar.Position = UDim2.new(0.2, 0, 1, -4)
                Bar.BackgroundColor3 = Color3.new(1,1,1)
                Bar.BorderSizePixel = 0
                Bar.Parent = Card
                
                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = Bar

                return ValueLabel, Bar
            end

            local PingVal, PingBar = CreateCard("PING", "ms")
            local FpsVal, FpsBar   = CreateCard("FPS", "frames")
            local CpuVal, CpuBar   = CreateCard("CPU", "ms")

            -- [5] LOGIC UPDATE
            local RunService = game:GetService("RunService")
            local StatsService = game:GetService("Stats")
            local FrameCount = 0
            local TimeElapsed = 0

            task.spawn(function()
                while _G.DraggableStatsActive and StatsGuiInstance do
                    local start = tick()
                    RunService.RenderStepped:Wait()
                    local dt = tick() - start

                    FrameCount = FrameCount + 1
                    TimeElapsed = TimeElapsed + dt

                    if TimeElapsed >= 1 then
                        local fps = math.floor(FrameCount / TimeElapsed)
                        local ping = 0
                        local cpu = (TimeElapsed / FrameCount) * 1000
                        
                        pcall(function() 
                            ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) 
                        end)
                        
                        PingVal.Text = tostring(ping)
                        if ping < 100 then 
                            PingVal.TextColor3 = Color3.fromHex("#4ade80")
                            PingBar.BackgroundColor3 = Color3.fromHex("#4ade80")
                        elseif ping < 200 then 
                            PingVal.TextColor3 = Color3.fromHex("#facc15")
                            PingBar.BackgroundColor3 = Color3.fromHex("#facc15")
                        else 
                            PingVal.TextColor3 = Color3.fromHex("#f87171")
                            PingBar.BackgroundColor3 = Color3.fromHex("#f87171")
                        end

                        FpsVal.Text = tostring(fps)
                        if fps >= 50 then 
                            FpsVal.TextColor3 = Color3.fromHex("#4ade80")
                            FpsBar.BackgroundColor3 = Color3.fromHex("#4ade80")
                        elseif fps >= 30 then 
                            FpsVal.TextColor3 = Color3.fromHex("#facc15")
                            FpsBar.BackgroundColor3 = Color3.fromHex("#facc15")
                        else 
                            FpsVal.TextColor3 = Color3.fromHex("#f87171")
                            FpsBar.BackgroundColor3 = Color3.fromHex("#f87171")
                        end

                        CpuVal.Text = string.format("%.1f", cpu)
                        if cpu < 16 then 
                            CpuVal.TextColor3 = Color3.fromHex("#4ade80")
                            CpuBar.BackgroundColor3 = Color3.fromHex("#4ade80")
                        elseif cpu < 33 then 
                            CpuVal.TextColor3 = Color3.fromHex("#facc15")
                            CpuBar.BackgroundColor3 = Color3.fromHex("#facc15")
                        else 
                            CpuVal.TextColor3 = Color3.fromHex("#f87171")
                            CpuBar.BackgroundColor3 = Color3.fromHex("#f87171")
                        end

                        FrameCount = 0
                        TimeElapsed = 0
                    end
                end
                if StatsGuiInstance then StatsGuiInstance:Destroy() end
            end)
            
            WindUI:Notify({ Title = "System", Content = "HUD Mode Activated", Icon = "monitor" })
        else
            if StatsGuiInstance then StatsGuiInstance:Destroy() end
            StatsGuiInstance = nil
            WindUI:Notify({ Title = "System", Content = "HUD Closed", Icon = "eye-off" })
        end
    end
}))

-- [[ 5. NOTIFICATION COUNTER (FINAL NEON HUD) ]]
local NotifCounterState = { Gui = nil, Connections = {} }

AddSave("NotifHUDToggle", DisplaySection:Toggle({
    Title = "Show Notif Counter",
    Desc = "Hitung notifikasi aktif (Mobile Optimized)",
    Value = false,
    Callback = function(Value)
        if NotifCounterState.Gui then NotifCounterState.Gui:Destroy() end
        for _, conn in pairs(NotifCounterState.Connections) do conn:Disconnect() end
        NotifCounterState.Connections = {}

        if Value then
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "WindUI_NotifCounter"
            if gethui then ScreenGui.Parent = gethui()
            elseif game:GetService("CoreGui") then ScreenGui.Parent = game:GetService("CoreGui")
            else ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
            NotifCounterState.Gui = ScreenGui

            local MainFrame = Instance.new("Frame")
            MainFrame.Size = UDim2.new(0, 200, 0, 95) 
            MainFrame.Position = UDim2.new(0.5, -100, 0.15, 0)
            MainFrame.BackgroundColor3 = Color3.fromHex("#0f172a") 
            MainFrame.BackgroundTransparency = 0.2
            MainFrame.BorderSizePixel = 0
            MainFrame.Active = true
            MainFrame.Parent = ScreenGui

            -- PASANG FITUR BARU DI SINI JUGA
            MakeDraggableSmooth(MainFrame)
            MakeResponsiveMobile(MainFrame)

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 16)
            UICorner.Parent = MainFrame

            local UIStroke = Instance.new("UIStroke")
            UIStroke.Color = Color3.fromHex("#38bdf8") 
            UIStroke.Thickness = 2.5
            UIStroke.Transparency = 0
            UIStroke.Parent = MainFrame

            local UIGradient = Instance.new("UIGradient")
            UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHex("#0f172a")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#1e293b"))
            }
            UIGradient.Rotation = 45
            UIGradient.Parent = MainFrame

            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 35)
            Header.BackgroundTransparency = 1
            Header.Parent = MainFrame

            local Logo = Instance.new("ImageLabel")
            Logo.Size = UDim2.new(0, 24, 0, 24)
            Logo.Position = UDim2.new(0, 12, 0.5, -12)
            Logo.BackgroundTransparency = 1
            Logo.Image = "rbxassetid://84078385121142" 
            Logo.ImageColor3 = Color3.new(1,1,1)
            Logo.Parent = Header

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -50, 1, 0)
            Title.Position = UDim2.new(0, 45, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = "NOTIFICATIONS"
            Title.Font = Enum.Font.GothamBlack
            Title.TextSize = 13
            Title.TextColor3 = Color3.fromHex("#e2e8f0")
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Header

            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, -24, 0, 1)
            Divider.Position = UDim2.new(0, 12, 0, 35)
            Divider.BackgroundColor3 = Color3.fromHex("#334155")
            Divider.BorderSizePixel = 0
            Divider.Parent = MainFrame

            local CountContainer = Instance.new("Frame")
            CountContainer.Size = UDim2.new(1, -24, 1, -45) 
            CountContainer.Position = UDim2.new(0, 12, 0, 40)
            CountContainer.BackgroundColor3 = Color3.fromHex("#1e293b")
            CountContainer.BackgroundTransparency = 0.6
            CountContainer.Parent = MainFrame
            
            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(0, 8)
            ContainerCorner.Parent = CountContainer

            local UIList = Instance.new("UIListLayout")
            UIList.Parent = CountContainer
            UIList.FillDirection = Enum.FillDirection.Vertical
            UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIList.VerticalAlignment = Enum.VerticalAlignment.Center
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Padding = UDim.new(0, -2)

            local CountLabel = Instance.new("TextLabel")
            CountLabel.Size = UDim2.new(1, 0, 0, 38)
            CountLabel.BackgroundTransparency = 1
            CountLabel.TextColor3 = Color3.fromHex("#f0f9ff")
            CountLabel.TextSize = 34
            CountLabel.Font = Enum.Font.GothamBold
            CountLabel.Text = "0"
            CountLabel.LayoutOrder = 1
            CountLabel.Parent = CountContainer
            
            local SubLabel = Instance.new("TextLabel")
            SubLabel.Size = UDim2.new(1, 0, 0, 15)
            SubLabel.BackgroundTransparency = 1
            SubLabel.TextColor3 = Color3.fromHex("#94a3b8")
            SubLabel.TextSize = 10
            SubLabel.Font = Enum.Font.GothamBold
            SubLabel.Text = "ACTIVE"
            SubLabel.LayoutOrder = 2
            SubLabel.Parent = CountContainer

            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
                local NotifGui = PlayerGui:WaitForChild("Text Notifications", 5)
                if not NotifGui then CountLabel.Text = "ERR" return end
                
                local NotifContainer = NotifGui:WaitForChild("Frame", 5)
                if not NotifContainer then CountLabel.Text = "ERR" return end

                local function UpdateCount()
                    local count = 0
                    for _, child in pairs(NotifContainer:GetChildren()) do
                        if child:IsA("Frame") then 
                            count = count + 1 
                        end
                    end
                    
                    local finalCount = count - 1
                    CountLabel.Text = tostring(finalCount)
                    
                    if finalCount > 10 then
                        CountLabel.TextColor3 = Color3.fromHex("#f87171")
                        UIStroke.Color = Color3.fromHex("#f87171") 
                        Title.TextColor3 = Color3.fromHex("#f87171")
                    else
                        CountLabel.TextColor3 = Color3.fromHex("#f0f9ff")
                        UIStroke.Color = Color3.fromHex("#38bdf8") 
                        Title.TextColor3 = Color3.fromHex("#e2e8f0")
                    end
                end

                table.insert(NotifCounterState.Connections, NotifContainer.ChildAdded:Connect(UpdateCount))
                table.insert(NotifCounterState.Connections, NotifContainer.ChildRemoved:Connect(UpdateCount))
                UpdateCount()
            end)
            
            WindUI:Notify({ Title = "Notif Counter", Content = "HUD Mode Active", Icon = "check" })
        else
            WindUI:Notify({ Title = "Notif Counter", Content = "Overlay Closed", Icon = "x" })
        end
    end
}))
end
------------
-- tab config (FULL FIXED VERSION)
------------

local function loadTabConfig()

    local ConfigSection = ConfigTab:Section({ Title = "Configuration System", Opened = true })

    -- Variables
    local SelectedConfig = ""
    local ConfigNameInput = ""
    local ConfigDropdown = nil

    -- Fungsi Refresh List (FIXED: Refresh Dulu Baru Cek)
    local function RefreshConfigList()
        local list = {}
        if isfolder(ConfigFolder) then
            for _, file in pairs(listfiles(ConfigFolder)) do
                if file:sub(-5) == ".json" then
                    -- Ambil nama file saja tanpa path folder
                    local name = file:match("[^\\/]+$"):sub(1, -6)
                    table.insert(list, name)
                end
            end
        end
        table.sort(list)
        
        -- 1. UPDATE ISI DROPDOWN DULUAN
        if ConfigDropdown and ConfigDropdown.Refresh then 
            ConfigDropdown:Refresh(list)
        end
        
        -- 2. Cek apakah config yang sedang dipilih masih ada filenya?
        local stillExists = false
        if SelectedConfig ~= "" then
            for _, v in pairs(list) do
                if v == SelectedConfig then 
                    stillExists = true 
                    break 
                end
            end
        end

        -- 3. Kalau filenya udah gak ada, reset tampilan dropdown jadi kosong
        if not stillExists then
            SelectedConfig = ""
            if ConfigDropdown and ConfigDropdown.Set then 
                pcall(function() ConfigDropdown:Set(nil) end) -- Hapus teks di UI
            end
        end

        return list
    end

    -- Fungsi Save (FIXED: Menggunakan SaveElements)
    local function SaveConfig(name)
        if name == "" or name == nil then 
            WindUI:Notify({Title="Config", Content="Masukkan nama config!", Icon="alert-triangle"}) 
            return 
        end
        
        local data = {}
        local count = 0
        
        -- Ambil data dari semua UI yang sudah di-AddSave
        for key, element in pairs(SaveElements) do
            if element.Value ~= nil then
                data[key] = element.Value
                count = count + 1
            end
        end
        
        if count == 0 then
            WindUI:Notify({Title="Config", Content="Tidak ada settingan untuk disave! (Gunakan AddSave)", Icon="alert-circle"}) 
            return
        end

        -- Simpan ke file
        local success, err = pcall(function()
            writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
        end)

        if success then
            WindUI:Notify({Title="Config", Content="Saved: " .. name, Icon="check", Duration=2})
            RefreshConfigList() -- Refresh biar muncul di list
        else
            WindUI:Notify({Title="Error", Content="Gagal save file!", Icon="x"})
            warn("Save Error:", err)
        end
    end

    -- Fungsi Load (FIXED: Update UI Otomatis)
    local function LoadConfig(name)
        local path = ConfigFolder .. "/" .. name .. ".json"
        if not isfile(path) then 
            WindUI:Notify({Title="Config", Content="File tidak ditemukan!", Icon="x"})
            RefreshConfigList()
            return 
        end
        
        local content = readfile(path)
        local decoded, data = pcall(function() return HttpService:JSONDecode(content) end)
        
        if not decoded or not data then
            WindUI:Notify({Title="Config", Content="File Corrupt/Rusak!", Icon="x"})
            return
        end
        
        local loadedCount = 0
        
        for key, value in pairs(data) do
            if SaveElements[key] then
                -- Update UI secara aman
                task.spawn(function()
                    if SaveElements[key].Set then
                        SaveElements[key]:Set(value)
                    else
                        SaveElements[key].Value = value
                    end
                end)
                loadedCount = loadedCount + 1
            end
        end
        
        WindUI:Notify({Title="Config", Content="Loaded " .. loadedCount .. " settings", Icon="check", Duration=2})
    end

    -- UI ELEMENTS
    ConfigSection:Input({
        Title = "Config Name",
        Desc = "Nama untuk config baru",
        Placeholder = "MySettings",
        Callback = function(v) ConfigNameInput = v end
    })

    ConfigSection:Button({
        Title = "Create / Save Config",
        Desc = "Simpan settingan saat ini",
        Icon = "save",
        Callback = function()
            SaveConfig(ConfigNameInput)
        end
    })

    ConfigSection:Space()

    ConfigDropdown = ConfigSection:Dropdown({
        Title = "Config List",
        Desc = "Pilih file config",
        Values = RefreshConfigList(),
        Multi = false,
        Callback = function(v) SelectedConfig = v end
    })

    ConfigSection:Button({
        Title = "Refresh List",
        Icon = "refresh",
        Callback = function() RefreshConfigList() end
    })

    ConfigSection:Button({
        Title = "Load Selected Config",
        Desc = "Load config yang dipilih di dropdown",
        Icon = "upload",
        Callback = function()
            if SelectedConfig ~= "" then 
                LoadConfig(SelectedConfig) 
            else
                WindUI:Notify({Title="Config", Content="Pilih config dulu!", Icon="alert-triangle"})
            end
        end
    })

    ConfigSection:Button({
        Title = "Overwrite Config",
        Desc = "Timpa file yang dipilih dengan settingan sekarang",
        Icon = "edit",
        Callback = function()
            if SelectedConfig ~= "" then 
                SaveConfig(SelectedConfig) 
            else
                WindUI:Notify({Title="Config", Content="Pilih config dulu!", Icon="alert-triangle"})
            end
        end
    })

    ConfigSection:Button({
        Title = "Delete Config",
        Icon = "trash-2",
        Callback = function()
            if SelectedConfig ~= "" then
                local path = ConfigFolder .. "/" .. SelectedConfig .. ".json"
                
                if isfile(path) then
                    delfile(path) -- Hapus file
                    
                    local deletedName = SelectedConfig
                    
                    -- Paksa UI Reset DULUAN
                    if ConfigDropdown then
                        pcall(function() ConfigDropdown:Set(nil) end)
                    end
                    SelectedConfig = "" 
                    
                    RefreshConfigList() -- Refresh list
                    
                    WindUI:Notify({Title="Config", Content="Deleted: " .. deletedName, Icon="trash"})
                else
                    WindUI:Notify({Title="Error", Content="File sudah tidak ada!", Icon="x"})
                    RefreshConfigList()
                end
            else
                WindUI:Notify({Title="Config", Content="Pilih config dulu di list!", Icon="alert-triangle"})
            end
        end
    })

    ConfigSection:Space()

    ConfigSection:Button({
        Title = "Set as Autoload",
        Desc = "Config ini akan jalan otomatis saat join",
        Icon = "zap",
        Callback = function()
            if SelectedConfig ~= "" then
                writefile(ConfigFile, SelectedConfig)
                WindUI:Notify({Title="Config", Content="Autoload set to: " .. SelectedConfig, Icon="check"})
            else
                WindUI:Notify({Title="Config", Content="Pilih config dulu!", Icon="alert-triangle"})
            end
        end
    })

    ConfigSection:Button({
        Title = "Reset Autoload",
        Desc = "Matikan fitur autoload",
        Icon = "x-circle",
        Callback = function()
            if isfile(ConfigFile) then
                delfile(ConfigFile)
                WindUI:Notify({Title="Config", Content="Autoload removed", Icon="check"})
            end
        end
    })

    -- AUTO LOAD LOGIC (Jalankan di akhir script)
    task.spawn(function()
        task.wait(2) -- Tunggu UI ready
        if isfile(ConfigFile) then
            local autoName = readfile(ConfigFile)
            if autoName and isfile(ConfigFolder .. "/" .. autoName .. ".json") then
                WindUI:Notify({Title="Autoload", Content="Loading " .. autoName .. "...", Duration=2})
                LoadConfig(autoName)
            end
        end
    end)
end

------------
-- tab misc (WRAPPED WITH ADDSAVE)
------------

local function loadTabMisc()

    -- [[ SECTION 1: STREAMER MODE ]]
    local PlayerSection = MiscTab:Section({ Title = "Streamer Mode", Opened = true })

    -- Config & Variables
    local HideNameConfig = {
        Active = false,
        Connections = {}, 
        TargetName = "#ZuperMingOnTop",
        TargetLevel = "???"
    }

    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")

    -- [FUNGSI 1] UI MASKING (Karakter & Overhead)
    local function MaskCharacterUI(char, player)
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayName = HideNameConfig.TargetName end
        
        local function ProcessObj(obj)
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible then
                local text = obj.Text
                if text:find(player.Name) or text:find(player.DisplayName) then
                    obj.Text = HideNameConfig.TargetName
                elseif (text:match("%d+") or text:lower():find("lvl")) and #text < 10 then
                    obj.Text = HideNameConfig.TargetLevel
                end
            end
        end
        
        for _, desc in pairs(char:GetDescendants()) do
            if desc:IsA("BillboardGui") then
                for _, item in pairs(desc:GetDescendants()) do ProcessObj(item) end
            end
        end
        
        local conn = char.DescendantAdded:Connect(function(desc)
            if not HideNameConfig.Active then return end
            if desc:IsA("BillboardGui") or desc:IsA("TextLabel") then
                task.wait() 
                ProcessObj(desc)
                for _, item in pairs(desc:GetDescendants()) do ProcessObj(item) end
            end
        end)
        table.insert(HideNameConfig.Connections, conn)
    end

    -- [FUNGSI 2] PLAYERLIST SPOOFING
    local function SpoofLeaderboard()
        local PlayerList = CoreGui:FindFirstChild("PlayerList")
        if not PlayerList then return end

        for _, obj in pairs(PlayerList:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if obj.Text ~= "" and obj.Text ~= HideNameConfig.TargetName then
                    local isPlayerName = false
                    if Players:FindFirstChild(obj.Text) then isPlayerName = true end
                    if not isPlayerName then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p.DisplayName == obj.Text then isPlayerName = true; break end
                        end
                    end
                    if isPlayerName then obj.Text = HideNameConfig.TargetName end
                end
            end
        end
    end

    -- TOGGLE STREAMER MODE (DISAVE)
    AddSave("StreamerModeToggle", PlayerSection:Toggle({
        Title = "Streamer Mode (Hide All)",
        Desc = "Samarkan nama di Karakter & Leaderboard",
        Value = false,
        Callback = function(state)
            HideNameConfig.Active = state
            for _, c in pairs(HideNameConfig.Connections) do if c then c:Disconnect() end end
            HideNameConfig.Connections = {}
            
            if state then
                WindUI:Notify({ Title = "Streamer Mode", Content = "Names Hidden: " .. HideNameConfig.TargetName, Duration = 3, Icon = "eye-off" })
                local renderConn = RunService.RenderStepped:Connect(function() pcall(SpoofLeaderboard) end)
                table.insert(HideNameConfig.Connections, renderConn)
                
                for _, plr in pairs(Players:GetPlayers()) do
                    MaskCharacterUI(plr.Character, plr)
                    local charConn = plr.CharacterAdded:Connect(function(char)
                        task.wait(1)
                        if HideNameConfig.Active then MaskCharacterUI(char, plr) end
                    end)
                    table.insert(HideNameConfig.Connections, charConn)
                end
                
                local playerConn = Players.PlayerAdded:Connect(function(plr)
                    local charConn = plr.CharacterAdded:Connect(function(char)
                        task.wait(1)
                        if HideNameConfig.Active then MaskCharacterUI(char, plr) end
                    end)
                    table.insert(HideNameConfig.Connections, charConn)
                end)
                table.insert(HideNameConfig.Connections, playerConn)
            else
                WindUI:Notify({ Title = "Streamer Mode", Content = "Restoring Names...", Duration = 3, Icon = "eye" })
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr.Character then
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hum then hum.DisplayName = plr.DisplayName end
                    end
                end
            end
        end
    }))

    -- [[ SECTION 2: GENERAL FEATURES ]]
    local MiscSection = MiscTab:Section({
        Title = "General Features",
        Opened = true
    })

-- [ANTI-AFK: VIRTUAL USER + FORCE START]
local AntiAfk = {conn = nil}
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Definisikan Logic di Fungsi Terpisah (Supaya bisa dipanggil paksa)
local function StartAntiAFKLogic()
    -- Bersihkan koneksi lama jika ada (biar gak numpuk)
    if AntiAfk.conn then 
        AntiAfk.conn:Disconnect() 
        AntiAfk.conn = nil 
    end

    -- Logic Asli Pilihan Kamu:
    pcall(function()
        AntiAfk.conn = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new()) -- Klik Virtual saat Idle
        end)
        
        -- Trigger awal untuk memastikan controller tertangkap
        VirtualUser:CaptureController()
    end)
end

local function StopAntiAFKLogic()
    if AntiAfk.conn then
        AntiAfk.conn:Disconnect()
        AntiAfk.conn = nil
    end
end

-- 2. UI Toggle (WindUI Version)
AddSave("AntiAFKToggle", MiscSection:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents kick (VirtualUser - Invisible Method)",
    Value = true, -- Default ON
    Callback = function(Value)
        if Value then
            StartAntiAFKLogic()
            if not isScriptLoading then
                WindUI:Notify({Title = "Anti-AFK", Content = "Enabled (Invisible Method)", Duration = 3, Icon = "shield-check"})
            end
        else
            StopAntiAFKLogic()
            if not isScriptLoading then
                WindUI:Notify({Title = "Anti-AFK", Content = "Disabled", Duration = 2, Icon = "x"})
            end
        end
    end
}))

-- 3. FORCE START SYSTEM (Anti Bug Callback)
-- Kode di bawah ini memaksa Anti-AFK jalan TANPA menunggu tombol UI dipencet.
task.spawn(function()
    StartAntiAFKLogic()
    print("[MingHub] Anti-AFK (VirtualUser) Forced Start Successful!")
end)

----------------------------------------------------
    -- 🎮 PLAYER UTILITIES (INPUT VERSION)
    ----------------------------------------------------
    local PlayerUtil = MiscTab:Section({ Title = "Player Utilities", Opened = true })

    -- [SERVICES]
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    -- [VARIABLES GLOBAL]
    local flySpeed = 50 -- Default speed

    -- ==================================================
    -- 1. WALK ON WATER (LOGIC DARI KAMU)
    -- ==================================================
    local wowEnabled = false
    local waterPart = nil
    local wowLoop = nil

    local function createWaterPlatform()
        if waterPart then waterPart:Destroy() end
        waterPart = Instance.new("Part")
        waterPart.Name = "WalkOnWater_Fixed"
        waterPart.Size = Vector3.new(20, 1, 20)
        waterPart.Transparency = 1 
        waterPart.Anchored = true
        waterPart.CanCollide = true
        waterPart.CastShadow = false
        waterPart.Parent = Workspace
    end

    local function startWalkOnWater()
        if not waterPart then createWaterPlatform() end
        
        wowLoop = RunService.Heartbeat:Connect(function()
            if not wowEnabled then return end
            
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")
            
            if root and humanoid then
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Include
                raycastParams.FilterDescendantsInstances = {Workspace.Terrain} 
                raycastParams.IgnoreWater = false 
                
                local rayOrigin = root.Position + Vector3.new(0, 10, 0) 
                local rayDirection = Vector3.new(0, -500, 0)
                local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                local shouldPlatform = false
                local targetY = -1000
                
                if rayResult then
                    if rayResult.Material == Enum.Material.Water then
                        shouldPlatform = true
                        targetY = rayResult.Position.Y
                    elseif humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                        shouldPlatform = true
                        targetY = root.Position.Y - 0.5 
                    end
                end

                if shouldPlatform then
                    if (root.Position.Y - targetY) < 15 then
                        waterPart.CFrame = CFrame.new(root.Position.X, targetY - 0.5, root.Position.Z)
                        if root.Velocity.Y < -30 then
                            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                        end
                    else
                        waterPart.CFrame = CFrame.new(0, -1000, 0)
                    end
                else
                    waterPart.CFrame = CFrame.new(0, -1000, 0)
                end
            end
        end)
    end

    PlayerUtil:Toggle({
        Title = "Walk on Water",
        Desc = "Berjalan di atas air",
        Value = false,
        Callback = function(Value)
            wowEnabled = Value
            if Value then
                createWaterPlatform()
                startWalkOnWater()
            else
                if wowLoop then wowLoop:Disconnect() wowLoop = nil end
                if waterPart then waterPart:Destroy() waterPart = nil end
            end
        end
    })

    -- ==================================================
    -- 2. NO CLIP (LOGIC DARI KAMU)
    -- ==================================================
    local NoclipLoop = nil 

    local function EnableNoclip()
        if NoclipLoop then return end
        NoclipLoop = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end

    local function DisableNoclip()
        if NoclipLoop then
            NoclipLoop:Disconnect()
            NoclipLoop = nil
        end
    end

    PlayerUtil:Toggle({
        Title = "Noclip",
        Desc = "Tembus tembok dan objek",
        Value = false,
        Callback = function(Value)
            if Value then EnableNoclip() else DisableNoclip() end
        end
    })

    -- ==================================================
    -- 3. FLY SYSTEM (LOGIC DARI KAMU + MOBILE UI)
    -- ==================================================
    local ControlModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    local flyEnabled = false
    local flyBodyGyro = nil
    local flyBodyVelocity = nil
    local flyLoop = nil
    local mobileGui = nil 
    local verticalState = { Up = false, Down = false }

    local function createMobileUI()
        if mobileGui then mobileGui:Destroy() end
        if UserInputService.TouchEnabled then
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "FlyControls"
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            ScreenGui.DisplayOrder = 100 
            
            local function makeBtn(text, pos)
                local btn = Instance.new("TextButton")
                btn.Parent = ScreenGui
                btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
                btn.BackgroundTransparency = 0.5
                btn.Position = pos
                btn.Size = UDim2.new(0, 60, 0, 60)
                btn.Font = Enum.Font.GothamBold
                btn.Text = text
                btn.TextColor3 = Color3.new(1,1,1)
                btn.TextSize = 30
                Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
                return btn
            end

            local btnUp = makeBtn("⬆", UDim2.new(0.85, 0, 0.55, 0))
            local btnDown = makeBtn("⬇", UDim2.new(0.85, 0, 0.68, 0))

            local function bind(btn, key)
                btn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        verticalState[key] = true
                    end
                end)
                btn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        verticalState[key] = false
                    end
                end)
            end
            bind(btnUp, "Up")
            bind(btnDown, "Down")
            mobileGui = ScreenGui
        end
    end

    local function removeMobileUI()
        if mobileGui then mobileGui:Destroy() mobileGui = nil end
        verticalState.Up = false
        verticalState.Down = false
    end

    local function startFly()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not root or not hum then return end

        hum.PlatformStand = true
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 9e4
        flyBodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.cframe = root.CFrame
        flyBodyGyro.Parent = root
        
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Parent = root
        
        createMobileUI()

        flyLoop = RunService.RenderStepped:Connect(function()
            if not flyEnabled or not root then return end
            
            local moveVec = ControlModule:GetMoveVector()
            local camCF = Camera.CFrame
            local moveDir = Vector3.new(0,0,0)
            
            if moveVec.Magnitude > 0 then
                moveDir = moveDir + (camCF.LookVector * -moveVec.Z) + (camCF.RightVector * moveVec.X)
            end

            if verticalState.Up or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if verticalState.Down or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            
            flyBodyGyro.CFrame = camCF
            flyBodyVelocity.Velocity = moveDir * flySpeed
        end)
    end

    local function stopFly()
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
        removeMobileUI()
        
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end

    PlayerUtil:Toggle({
        Title = "Enable Fly",
        Desc = "Terbang (WASD / Joystick + Q/E)",
        Value = false,
        Callback = function(Value)
            flyEnabled = Value
            if Value then startFly() else stopFly() end
        end
    })

    -- ==================================================
    -- 4. SPEED INPUT (PENGGANTI SLIDER)
    -- ==================================================
    PlayerUtil:Input({
        Title = "Fly Speed",
        Desc = "Masukkan angka kecepatan (Contoh: 50, 100)",
        Placeholder = "50",
        Numeric = true, -- Hanya boleh angka
        Finished = true, -- Update saat tekan enter/selesai ketik
        Callback = function(Value)
            local num = tonumber(Value)
            if num then
                flySpeed = num
            end
        end
    })

    -- ==================================================
    -- 5. FREE CAM (PELENGKAP)
    -- ==================================================
    local Freecam = { Enabled = false, Speed = 1 }
    local fcConnection = nil
    local FCInput = { W=false, A=false, S=false, D=false, Q=false, E=false, RightClick=false }

    -- Input Listener Sekali Saja
    UserInputService.InputBegan:Connect(function(input, gp)
        if not Freecam.Enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then FCInput.RightClick = true end
        if input.KeyCode == Enum.KeyCode.W then FCInput.W = true end
        if input.KeyCode == Enum.KeyCode.S then FCInput.S = true end
        if input.KeyCode == Enum.KeyCode.A then FCInput.A = true end
        if input.KeyCode == Enum.KeyCode.D then FCInput.D = true end
        if input.KeyCode == Enum.KeyCode.Q then FCInput.Q = true end
        if input.KeyCode == Enum.KeyCode.E then FCInput.E = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then FCInput.RightClick = false end
        if input.KeyCode == Enum.KeyCode.W then FCInput.W = false end
        if input.KeyCode == Enum.KeyCode.S then FCInput.S = false end
        if input.KeyCode == Enum.KeyCode.A then FCInput.A = false end
        if input.KeyCode == Enum.KeyCode.D then FCInput.D = false end
        if input.KeyCode == Enum.KeyCode.Q then FCInput.Q = false end
        if input.KeyCode == Enum.KeyCode.E then FCInput.E = false end
    end)

    local function EnableFreecam()
        Freecam.Enabled = true
        Camera.CameraType = Enum.CameraType.Scriptable
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
        end
        
        fcConnection = RunService.RenderStepped:Connect(function(dt)
            local speed = flySpeed / 20 -- Sesuaikan speed input dengan freecam
            local move = Vector3.new(0,0,0)
            if FCInput.W then move = move + Vector3.new(0, 0, -1) end
            if FCInput.S then move = move + Vector3.new(0, 0, 1) end
            if FCInput.A then move = move + Vector3.new(-1, 0, 0) end
            if FCInput.D then move = move + Vector3.new(1, 0, 0) end
            if FCInput.Q then move = move + Vector3.new(0, -1, 0) end
            if FCInput.E then move = move + Vector3.new(0, 1, 0) end
            
            if FCInput.RightClick then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                local delta = UserInputService:GetMouseDelta()
                local rot = Camera.CFrame.Rotation * CFrame.Angles(-math.rad(delta.Y)*0.5, -math.rad(delta.X)*0.5, 0)
                Camera.CFrame = rot + Camera.CFrame.Position
            else
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
            
            Camera.CFrame = Camera.CFrame * CFrame.new(move * speed * 60 * dt)
        end)
    end

    local function DisableFreecam()
        Freecam.Enabled = false
        if fcConnection then fcConnection:Disconnect() fcConnection = nil end
        Camera.CameraType = Enum.CameraType.Custom
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end

    PlayerUtil:Toggle({
        Title = "Free Cam",
        Desc = "Kamera Bebas (Shift+P)",
        Value = false,
        Callback = function(Value)
            if Value then EnableFreecam() else DisableFreecam() end
        end
    })


    -- [5] INFINITE ZOOM OUT (LOGIC BARU)
    local function SetZoom()
        if not zoomEnabled then return end
        LocalPlayer.CameraMaxZoomDistance = 50000
        LocalPlayer.CameraMinZoomDistance = 0.5
    end

    local function EnableInfiniteZoom()
        SetZoom()
        -- Loop Enforcement (Biar gak direset game)
        zoomLoop = task.spawn(function()
            while zoomEnabled do
                SetZoom()
                task.wait(1)
            end
        end)
        -- Signal Enforcement
        table.insert(zoomConnections, LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(SetZoom))
    end

    local function DisableInfiniteZoom()
        if zoomLoop then task.cancel(zoomLoop) zoomLoop = nil end
        for _, v in pairs(zoomConnections) do v:Disconnect() end
        zoomConnections = {}
        LocalPlayer.CameraMaxZoomDistance = 128 -- Reset ke normal
    end

    PlayerUtil:Toggle({
        Title = "Infinite Zoom",
        Desc = "Bisa zoom out sangat jauh",
        Value = false,
        Callback = function(Value)
            zoomEnabled = Value
            if Value then EnableInfiniteZoom() else DisableInfiniteZoom() end
        end
    })

    ------------------------------------------------------------------
    -- [[ SECTION 3: ANTI-STAFF SYSTEM (AUTO DISCONNECT) ]]
    ------------------------------------------------------------------
    local StaffSection = MiscTab:Section({ Title = "Safety & Anti-Staff", Opened = true })

    -- [VARIABLES]
    local AntiStaffState = { Active = false, Connections = {}, Loops = {} }
    local StaffGroupId = 35102746
    local AuthorizedUserIds = {}
    local SeniorStaffIds = { 192821024, 65042011, 2243687249, 5098885657 }

    -- [LOAD STAFF DATABASE]
    task.spawn(function()
        pcall(function()
            local auth = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("AuthorizedUserIds"))
            if type(auth) == "table" then
                for _, userId in pairs(auth) do table.insert(AuthorizedUserIds, userId) end
            end
        end)
    end)

    -- [DETECTION LOGIC]
    local function isStaff(player)
        local userId = player.UserId
        
        -- 1. Check ID Lists
        if table.find(AuthorizedUserIds, userId) then return true, "Owner/Dev" end
        if table.find(SeniorStaffIds, userId) then return true, "Senior Staff" end
        
        -- 2. Check Attributes
        if player:GetAttribute("Dev") or player:GetAttribute("Tester") or player:GetAttribute("Contributor") or player:GetAttribute("Staff") or player:GetAttribute("SeniorStaff") then
            return true, "Staff Attribute"
        end
        
        -- 3. Check Group Rank
        local success, rank = pcall(function() return player:GetRankInGroup(StaffGroupId) end)
        if success and rank and rank >= 4 then -- Rank 4 ke atas biasanya mod
            return true, "Group Rank: " .. rank
        end
        
        -- 4. Check Cmdr GUI
        local pGui = player:FindFirstChild("PlayerGui")
        if pGui and pGui:FindFirstChild("Cmdr") and (pGui.Cmdr:FindFirstChild("Frame") or pGui.Cmdr:FindFirstChild("Window")) then
            return true, "Cmdr UI Detected"
        end

        -- 5. Module Fallback
        local pSuccess, priority = pcall(function()
            return require(game:GetService("ReplicatedStorage").Shared.UserPriority):GetPriorityLevel(player)
        end)
        if pSuccess and priority and priority >= 3 then return true, "Priority Level " .. priority end

        return false, nil
    end

    -- [ACTION: DISCONNECT / KICK ONLY]
    local function TriggerSafety(staffName, reason)
        if not AntiStaffState.Active then return end
        
        -- Notif Alert
        WindUI:Notify({
            Title = "STAFF DETECTED!",
            Content = staffName .. " [" .. reason .. "]\nDISCONNECTING...",
            Duration = 5,
            Icon = "alert-triangle"
        })
        
        warn("[MingHub] STAFF DETECTED: " .. staffName .. " (" .. reason .. ")")
        
        -- LANGSUNG KICK (DISCONNECT)
        task.wait(0.5) -- Jeda sebentar biar notif kebaca
        LocalPlayer:Kick("\n\n🛡️ ZuperMing Safety 🛡️\n\nStaff Detected: " .. staffName .. "\nReason: " .. reason .. "\n\nDisconnected automatically for safety.")
    end

    -- [MAIN LOOPS]
    local function StartAntiStaff()
        -- 1. Scan Existing Players
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                task.spawn(function()
                    local detected, reason = isStaff(plr)
                    if detected then TriggerSafety(plr.Name, reason) end
                end)
            end
        end

        -- 2. Monitor New Players
        local addedConn = Players.PlayerAdded:Connect(function(plr)
            task.wait(1) -- Tunggu data load
            local detected, reason = isStaff(plr)
            if detected then TriggerSafety(plr.Name, reason) end
            
            -- Deep Check (Wait for Group/Attributes)
            task.delay(5, function()
                if not AntiStaffState.Active then return end
                local d2, r2 = isStaff(plr)
                if d2 then TriggerSafety(plr.Name, r2) end
            end)
        end)
        table.insert(AntiStaffState.Connections, addedConn)

        -- 3. Periodic Scan (Buat jaga-jaga kalau Cmdr baru muncul)
        local loop = task.spawn(function()
            while AntiStaffState.Active do
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer then
                        local detected, reason = isStaff(plr)
                        if detected then TriggerSafety(plr.Name, reason) return end
                    end
                end
                task.wait(10) -- Scan tiap 10 detik
            end
        end)
        table.insert(AntiStaffState.Loops, loop)
    end

    local function StopAntiStaff()
        for _, conn in pairs(AntiStaffState.Connections) do conn:Disconnect() end
        for _, loop in pairs(AntiStaffState.Loops) do task.cancel(loop) end
        AntiStaffState.Connections = {}
        AntiStaffState.Loops = {}
    end

    -- [UI TOGGLE]
    AddSave("AntiStaffToggle", StaffSection:Toggle({
        Title = "Enable Anti-Staff",
        Desc = "Auto Disconnect (Kick) jika ada Admin/Mod",
        Value = false,
        Callback = function(Value)
            AntiStaffState.Active = Value
            if Value then
                StartAntiStaff()
                if not isScriptLoading then WindUI:Notify({Title="Anti-Staff", Content="Monitoring Active (Kick Mode)", Icon="shield"}) end
            else
                StopAntiStaff()
                if not isScriptLoading then WindUI:Notify({Title="Anti-Staff", Content="Disabled", Icon="x"}) end
            end
        end
    }))

end

-- [[ CUSTOM TOGGLE BUTTON (AUTO DESTROY & SMART HIDE) ]]
task.spawn(function()
    local CoreGui = game:GetService("CoreGui")
    
    -- 1. ANTI-DOUBLE (Hapus tombol lama kalau ada, biar gak numpuk)
    if CoreGui:FindFirstChild("ZuperMingToggle") then
        CoreGui.ZuperMingToggle:Destroy()
    end

    -- 2. SETUP GUI
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ZuperMingToggle"
    ToggleGui.Parent = CoreGui
    ToggleGui.ResetOnSpawn = false
    
    local Btn = Instance.new("ImageButton")
    Btn.Name = "OpenBtn"
    Btn.Parent = ToggleGui
    Btn.BackgroundColor3 = Color3.fromHex("#6A5ACD")
    Btn.Position = UDim2.new(0.12, 0, 0.12, 0)
    Btn.Size = UDim2.new(0, 50, 0, 50)
    Btn.Image = "rbxassetid://84078385121142" -- ID Logo Kamu
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0.25, 0)
    Corner.Parent = Btn
    
    -- 3. DRAG LOGIC (GESER)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    Btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- 4. LOGIC KLIK PINTAR (Hide/Show)
    -- Kita simpan referensi UI Utama di sini biar bisa dipake buat Auto-Destroy juga
    local MainUI_Ref = nil 

    local function FindMainUI()
        if MainUI_Ref then return MainUI_Ref end -- Kalau udah ketemu, pake yg lama
        
        for _, gui in pairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "ZuperMingToggle" then
                -- Ciri khas WindUI: Punya 'Main' atau 'Instance'
                if gui:FindFirstChild("Main") or gui:FindFirstChild("Instance") then
                    MainUI_Ref = gui
                    return gui
                end
            end
        end
        return nil
    end

    Btn.MouseButton1Click:Connect(function()
        -- Coba toggle via Window object dulu
        if Window and type(Window.Toggle) == "function" then
            Window:Toggle()
            return
        end
        
        -- Kalau gagal, cari manual
        local target = FindMainUI()
        if target then
            target.Enabled = not target.Enabled
            -- Efek Visual
            if target.Enabled then
                Btn.ImageColor3 = Color3.new(1, 1, 1)
            else
                Btn.ImageColor3 = Color3.new(0.6, 0.6, 0.6)
            end
        else
            warn("[ZuperMing] UI Utama tidak ditemukan!")
        end
    end)

    -- 5. LOGIC AUTO-DESTROY (TALI NYAWA)
    -- Tugas: Mencari UI Utama, lalu mengikat nasib tombol ini ke UI Utama
    task.spawn(function()
        task.wait(1) -- Tunggu sebentar biar WindUI loading dulu
        local target = FindMainUI()
        
        if target then
            print("[ZuperMing] Tombol terikat dengan: " .. target.Name)
            
            -- KETIKA UI UTAMA DIHANCURKAN (DESTROYING), TOMBOL IKUT HANCUR
            target.Destroying:Connect(function()
                if ToggleGui then
                    ToggleGui:Destroy()
                end
                print("[ZuperMing] UI Utama dihapus, Tombol ikut menghilang.")
            end)
        else
            -- Fallback: Kalau gak ketemu event destroy, cek manual tiap 2 detik
            -- (Jaga-jaga kalau WindUI ganti parent bukannya destroy)
            while ToggleGui.Parent do
                local check = FindMainUI()
                if not check and MainUI_Ref then 
                    -- Tadi ada, sekarang hilang -> Hancurkan tombol
                    ToggleGui:Destroy()
                    break 
                end
                task.wait(2)
            end
        end
    end)
end)

------------
-- initialization
------------

-- Auto Select Tab Info
task.spawn(function()
    loadTabInfo()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabMain()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabAuto()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabShop()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabTeleport()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabEvent()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabWebhook()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabPerformance()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabConfig()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    loadTabMisc()
    task.wait(0.5) -- Tunggu sebentar biar UI stabil
    Window:SelectTab(1)
    
    -- [[ TAMBAHKAN INI ]]
    isScriptLoading = false -- Loading selesai, sekarang notif boleh muncul
    
    -- Notifikasi Final bahwa script sudah siap
    WindUI:Notify({
        Title = "ZuperMing",
        Content = "Script Loaded Successfully!",
        Duration = 5,
        Icon = "rbxassetid://84078385121142"
    })
end)
