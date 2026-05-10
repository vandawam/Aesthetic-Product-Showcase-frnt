-- -- -- ============================================================
-- -- -- CORE SECURITY: ANTI-HOOK, ANTI-SPY, & ANTI-TAMPER V3.2
-- -- -- -- ============================================================
-- local Proteksi = { Aman = true }

-- local function Banned(alasan)
--     Proteksi.Aman = false
--     local p = game:GetService("Players").LocalPlayer
--     if p then
--         p:Kick("Access Denied: " .. alasan)
--     end
--     task.wait(9e9)
-- end

-- pcall(function()
--     local dummyEvent = Instance.new("RemoteEvent")
--     local dummyFunc = Instance.new("RemoteFunction")

--     local realFire = dummyEvent.FireServer
--     local realInvoke = dummyFunc.InvokeServer

--     if ishooked then
--         if ishooked(realFire) and ishooked(realInvoke) then
--             Banned("RemoteSpy Detected (FireServer & InvokeServer Hook)")
--         end
--     end

--     if iscclosure and islclosure then
--         if islclosure(realFire) and islclosure(realInvoke) then
--             Banned("RemoteSpy Detected (Remote Closure Hook)")
--         end
--     end

--     local KataTerlarang = {"hydroxide", "turtle spy", "cobalt", "bypasser", "remote spy", "simple spy", "ultimate debugging suite", "dark dex"}
--     local SafeWords = {"codex", "index", "pokedex", "delta", "arceus", "fluxus", "hydrogen", "macsploit", "vegas", "evon", "furk", "trigon", "executor", "menu", "hub", "isylhub"}
--     local IgnoreGuis = {"robloxgui", "chat", "bubblechat", "playerlist", "teleportgui", "robloxpromptgui", "purchaseprompt", "corescriptsroot"}

--     local function isDexOrSpy(str)
--         str = string.lower(str)
--         if str == "dex" or str == "spy" then return false end

--         if string.find(str, "dex") or string.find(str, "spy") then
--             for _, safe in ipairs(SafeWords) do
--                 if string.find(str, safe) then return false end
--             end
--             return true
--         end
--         return false
--     end

--     task.spawn(function()
--         while Proteksi.Aman do
--             task.wait(3)
--             local currentContainers = {game:GetService("CoreGui")}
--             pcall(function() if gethui then table.insert(currentContainers, gethui()) end end)
            
--             for _, container in ipairs(currentContainers) do
--                 pcall(function()
--                     for _, ui in ipairs(container:GetChildren()) do
--                         pcall(function()
--                             local name = string.lower(ui.Name)
--                             if table.find(IgnoreGuis, name) then return end

--                             -- SCAN 1: Cek Nama dari UI (GUI Name)
--                             for _, bad in ipairs(KataTerlarang) do
--                                 if string.find(name, bad) then Banned("Illegal UI Detected ("..bad..")") end
--                             end
--                             if isDexOrSpy(name) then Banned("Illegal UI Detected ("..name..")") end
                            
--                             -- SCAN 2: Cek Isi Teks di dalam UI
--                             for _, desc in pairs(ui:GetDescendants()) do
--                                 pcall(function()
--                                     if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
--                                         local text = string.lower(desc.Text)
--                                         if string.len(text) < 40 then
--                                             -- Kita HANYA mencari kata terlarang spesifik (seperti "dark dex")
--                                             for _, bad in ipairs(KataTerlarang) do
--                                                 if string.find(text, bad) then
--                                                     Banned("Illegal Text Element Detected ("..text..")")
--                                                 end
--                                             end
                                            
--                                             -- FIX V3.2:
--                                             -- Pengecekan isDexOrSpy(text) DIHAPUS dari sini!
--                                             -- Ini mencegah false positive saat ada notifikasi game/executor
--                                             -- yang bertuliskan nama player seperti "you've joined dex".
--                                         end
--                                     end
--                                 end)
--                             end
--                         end)
--                     end
--                 end)
--             end
--         end
--     end)
-- end)

-- if not Proteksi.Aman then
--     return 
-- end

-- -- -- -- -- -- -- ============================================================
-- -- -- -- -- -- -- KEY SYSTEM & TRACKING
-- -- -- -- -- -- -- ============================================================

-- local function showWarningUI(message)
--     local ScreenGui = Instance.new("ScreenGui")
--     local Frame = Instance.new("Frame")
--     local UICorner = Instance.new("UICorner")
--     local Title = Instance.new("TextLabel")
--     local Key = Instance.new("TextLabel")
--     local Description = Instance.new("TextLabel")
--     local ButtonClose = Instance.new("TextButton")
--     local UICorner_2 = Instance.new("UICorner")
--     local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
--     local Background = Instance.new("Frame")
--     local UIStroke = Instance.new("UIStroke")

--     ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
--     ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
--     ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
--     ScreenGui.ScreenInsets = Enum.ScreenInsets.None

--     Background.Name = "Background"
--     Background.Parent = ScreenGui
--     Background.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
--     Background.BackgroundTransparency = 0.300
--     Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Background.BorderSizePixel = 0
--     Background.Size = UDim2.new(1, 0, 1, 0)
--     Background.ZIndex = 0

--     Frame.Parent = ScreenGui
--     Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
--     Frame.BackgroundTransparency = 0.100
--     Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Frame.BorderSizePixel = 0
--     Frame.Position = UDim2.new(0.248725787, 0, 0.40242058, 0)
--     Frame.Size = UDim2.new(0.502548397, 0, 0.146747351, 0)

--     UICorner.CornerRadius = UDim.new(0.0500000007, 0)
--     UICorner.Parent = Frame
    
--     UIStroke.Parent = Frame
--     UIStroke.Color = Color3.fromRGB(255, 255, 255)
--     UIStroke.Thickness = 1

--     Title.Name = "Title"
--     Title.Parent = Frame
--     Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--     Title.BackgroundTransparency = 1.000
--     Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Title.BorderSizePixel = 0
--     Title.Position = UDim2.new(0.198198214, 0, 0, 0)
--     Title.Size = UDim2.new(0.6006006, 0, 0.289151847, 0)
--     Title.Font = Enum.Font.GothamBold
--     Title.Text = "Napoleon | Warning"
--     Title.TextColor3 = Color3.fromRGB(255, 255, 255)
--     Title.TextScaled = true
--     Title.TextSize = 14.000
--     Title.TextWrapped = true

--     Key.Name = "Key"
--     Key.Parent = Frame
--     Key.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--     Key.BackgroundTransparency = 1.000
--     Key.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Key.BorderSizePixel = 0
--     Key.Position = UDim2.new(0.22862418, 0, 0.550000012, 0)
--     Key.Size = UDim2.new(0.533663452, 0, 0.154971421, 0)
--     Key.Font = Enum.Font.GothamBold
--     Key.Text = "discord.gg/napoleonsc"
--     Key.TextColor3 = Color3.fromRGB(106, 106, 124)
--     Key.TextScaled = true
--     Key.TextSize = 14.000
--     Key.TextWrapped = true

--     Description.Name = "Description"
--     Description.Parent = Frame
--     Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--     Description.BackgroundTransparency = 1.000
--     Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     Description.BorderSizePixel = 0
--     Description.Position = UDim2.new(0.060851898, 0, 0.306907117, 0)
--     Description.Size = UDim2.new(0.871821165, 0, 0.216986924, 0)
--     Description.Font = Enum.Font.Gotham
--     Description.Text = message
--     Description.TextColor3 = Color3.fromRGB(255, 255, 255)
--     Description.TextScaled = true
--     Description.TextSize = 14.000
--     Description.TextWrapped = true

--     ButtonClose.Name = "ButtonClose"
--     ButtonClose.Parent = Frame
--     ButtonClose.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
--     ButtonClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
--     ButtonClose.BorderSizePixel = 0
--     ButtonClose.Position = UDim2.new(0.385395527, 0, 0.747835159, 0)
--     ButtonClose.Size = UDim2.new(0.229208946, 0, 0.206185549, 0)
--     ButtonClose.Font = Enum.Font.GothamBold
--     ButtonClose.Text = "Close"
--     ButtonClose.TextColor3 = Color3.fromRGB(255, 255, 255)
--     ButtonClose.TextScaled = true
--     ButtonClose.TextSize = 14.000
--     ButtonClose.TextWrapped = true

--     UICorner_2.CornerRadius = UDim.new(1, 0)
--     UICorner_2.Parent = ButtonClose

--     UITextSizeConstraint.Parent = ButtonClose
--     UITextSizeConstraint.MaxTextSize = 14
    
--     ButtonClose.MouseButton1Click:Connect(function()
--         ScreenGui:Destroy()
--     end)
-- end

-- local key = getgenv().Key or _G.Key
-- if not key then
--     showWarningUI("Key tidak ditemukan! Silahkan masukkan getgenv().Key")
--     return
-- end

-- local hwid = tostring(game:GetService("Players").LocalPlayer.UserId)
-- local checkUrl = "http://napoleon-script.my.id/api/check?key=" .. key .. "&hwid=" .. hwid

-- -- Decrypt XOR (mirror dari server encryptXOR)
-- local function decryptXOR(hexStr, secretKey)
--     local result = ""
--     local charIdx = 0
--     for i = 1, #hexStr, 2 do
--         local hexByte = hexStr:sub(i, i + 1)
--         local byte = tonumber(hexByte, 16)
--         if not byte then return nil end
--         local keyChar = secretKey:byte((charIdx % #secretKey) + 1)
--         result = result .. string.char(bit32.bxor(byte, keyChar))
--         charIdx = charIdx + 1
--     end
--     return result
-- end

-- local SECRET_KEY = "HOEEEE_MALING_PANGSIT"

-- local successCheck, responseCheck = pcall(function()
--     return game:HttpGet(checkUrl)
-- end)

-- if successCheck then
--     local HttpService = game:GetService("HttpService")
--     local decrypted = decryptXOR(responseCheck, SECRET_KEY)
--     local ok, data = pcall(function() return HttpService:JSONDecode(decrypted or "") end)
--     if ok and type(data) == "table" then
--         if not data.valid then
--             showWarningUI(data.message or "Key tidak valid / Belum reset HWID!")
--             return
--         end
--     else
--         showWarningUI("Invalid response dari server.")
--         return
--     end
-- else
--     showWarningUI("Gagal terhubung ke server validasi key.")
--     return
-- end

-- -- Track eksekusi script ke backend
-- local function getExecutorName()
--     if identifyexecutor then return identifyexecutor() end
--     if syn then return "Synapse X"
--     elseif Ronix then return "Ronix"
--     elseif fluxus then return "Fluxus"
--     elseif DELTA_VERSION then return "Delta"
--     else return "Unknown" end
-- end

-- task.spawn(function()
--     pcall(function()
--         local currentTime = os.time()
--         local logPath = "Napoleon_SlimeRNG_LastExec.txt"
        
--         -- Cooldown: 1 Jam (3600 detik) untuk mencegah spam di eksekusi/server hop
--         if isfile and readfile and writefile then
--             if isfile(logPath) then
--                 local lastTime = tonumber(readfile(logPath))
--                 if lastTime and (currentTime - lastTime) < 3600 then
--                     return -- Jangan kirim log lagi jika belum 1 jam
--                 end
--             end
--             writefile(logPath, tostring(currentTime))
--         else
--             if getgenv()._Napoleon_ExecLogged_Slime then return end
--             getgenv()._Napoleon_ExecLogged_Slime = true
--         end

--         local player = game:GetService("Players").LocalPlayer
--         if player then
--             local userid = tostring(player.UserId)
--             local username = player.Name
--             local executor = getExecutorName()
--             local placeid = tostring(game.PlaceId)
            
--             local url = "http://napoleon-script.my.id/api/track"
--                 .. "?script=slime-rng"
--                 .. "&userid=" .. userid
--                 .. "&username=" .. username
--                 .. "&executor=" .. (executor:gsub(" ", "%%20"))
--                 .. "&placeid=" .. placeid
--                 .. "&key=" .. key
                
--             game:HttpGet(url)
--         end
--     end)
-- end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local DashEvent = ReplicatedStorage:WaitForChild("DashEvent")
local ZoneConfig = require(ReplicatedStorage.Modules.ZoneConfig)
local LocalPlayer = Players.LocalPlayer

local RemoteGUI = ReplicatedStorage:WaitForChild("RemoteGUI", 5)
local UNotifyEvent = RemoteGUI and RemoteGUI:WaitForChild("UNotifyEvent", 5)

local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes", 5)
local OpenBlockEvent = RemotesFolder and RemotesFolder:WaitForChild("OpenBlockEffect", 5)
local SellEvent = RemotesFolder and RemotesFolder:WaitForChild("SellEvent", 5)

-- ==========================================
-- GET CURRENT POWER & ZONE CFRAME
-- ==========================================
local Suffixes = {
    k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18, sx = 1e21, sp = 1e24, oc = 1e27, no = 1e30, dc = 1e33, ud = 1e36, dd = 1e39
}

local function ParseNumber(str)
    if type(str) == "number" then return str end
    if type(str) ~= "string" then return 0 end
    local numStr, suffix = string.match(str, "^([%d%.]+)%s*([a-zA-Z]*)$")
    if not numStr then return tonumber(str) or 0 end
    local num = tonumber(numStr)
    if not num then return 0 end
    if suffix and suffix ~= "" then
        local lowerSuffix = string.lower(suffix)
        if Suffixes[lowerSuffix] then return num * Suffixes[lowerSuffix] end
    end
    return num
end

local function GetCurrentPower()
    -- Prioritaskan membaca langsung dari leaderstats (Paling Akurat)
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            local name = string.lower(stat.Name)
            if (string.find(name, "power") or string.find(name, "stamina") or string.find(name, "strength") or string.find(name, "energy")) and not string.find(name, "total") then
                return ParseNumber(stat.Value)
            end
        end
    end

    local highest = 0
    local function CheckStat(stat)
        local name = string.lower(stat.Name)
        -- ABAIKAN SEMUA STATS YANG BERHUBUNGAN DENGAN UANG/REBIRTH/TOTAL
        if string.find(name, "coin") or string.find(name, "cash") or string.find(name, "money") or string.find(name, "gem") or string.find(name, "rebirth") or string.find(name, "total") then return end
        
        if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
            local val = ParseNumber(stat.Value)
            if val > highest then highest = val end
        end
    end
    
    for _, folder in ipairs(LocalPlayer:GetChildren()) do
        if folder:IsA("Folder") then
            for _, stat in ipairs(folder:GetChildren()) do CheckStat(stat) end
        end
    end
    for _, stat in ipairs(LocalPlayer:GetChildren()) do CheckStat(stat) end
    
    return highest
end

local ZoneCFrames = {
    ["Common"] = CFrame.new(-1.500546, 3.000000, -794.521301, 0.999944, -0.000000, 0.010624, 0.000000, 1.000000, -0.000000, -0.010624, 0.000000, 0.999944),
    ["Uncommon"] = CFrame.new(-2.914163, 1.962595, -1888.243652, 0.999714, 0.004276, -0.023546, -0.000000, 0.983906, 0.178686, 0.023931, -0.178635, 0.983624),
    ["Rare"] = CFrame.new(0.970530, 6.349766, -2927.494629, 0.999566, -0.005125, 0.029020, 0.000000, 0.984759, 0.173925, -0.029469, -0.173849, 0.984331),
    ["Epic"] = CFrame.new(0.787923, 8.745147, -3895.961426, 0.999844, 0.001461, -0.017589, 0.000000, 0.996566, 0.082796, 0.017650, -0.082783, 0.996411),
    ["Legendary"] = CFrame.new(1.771295, 9.329849, -4885.696289, 0.999972, -0.001390, 0.007352, 0.000000, 0.982583, 0.185823, -0.007482, -0.185818, 0.982556),
    ["Legend"] = CFrame.new(1.771295, 9.329849, -4885.696289, 0.999972, -0.001390, 0.007352, 0.000000, 0.982583, 0.185823, -0.007482, -0.185818, 0.982556),
    ["Mythic"] = CFrame.new(-0.092139, 4.745176, -5885.226074, 0.999966, 0.001057, -0.008158, 0.000000, 0.991710, 0.128497, 0.008226, -0.128492, 0.991676),
    ["Secret"] = CFrame.new(-2.597495, 10.002420, -6909.431152, 0.999935, 0.002139, -0.011164, -0.000000, 0.982131, 0.188200, 0.011367, -0.188187, 0.982067),
    ["Cosmic"] = CFrame.new(1.192654, 7.479439, -7922.613281, 0.999999, -0.000206, 0.001181, -0.000000, 0.985177, 0.171543, -0.001199, -0.171543, 0.985176),
    ["Celestial"] = CFrame.new(-1.366044, 4.917008, -8900.107422, 0.999999, -0.000151, 0.001189, 0.000000, 0.992018, 0.126098, -0.001199, -0.126098, 0.992017),
    ["Divine"] = CFrame.new(1.471819, 11.813887, -9906.136719, 0.999714, 0.004219, -0.023557, -0.000000, 0.984335, 0.176308, 0.023932, -0.176257, 0.984053),
    ["Godly"] = CFrame.new(-0.717083, 21.495840, -10909.266602, 0.999832, 0.002228, -0.018170, 0.000000, 0.992563, 0.121733, 0.018306, -0.121712, 0.992397),
    ["Admin"] = CFrame.new(6.314745, 17.440834, -11953.287109, 1.000000, 0.000026, -0.000154, -0.000000, 0.986011, 0.166678, 0.000156, -0.166678, 0.986011),
    ["Infinity] = CFrame.new(0.347630888, 2.99999976, -12933.0205, 0.99594903, 7.43072306e-08, -0.0899197981, -7.99019659e-08, 1, -5.86194879e-08, 0.0899197981, 6.55667876e-08, 0.99594903)        
}

local function GetMaxSafeZone(currentPower)
    local maxZoneName = "Common"
    for i, rankName in ipairs(ZoneConfig.RANKS) do
        local requiredPower = ParseNumber(ZoneConfig.REQUIREMENTS[i])
        if currentPower >= requiredPower then 
            for k, _ in pairs(ZoneCFrames) do
                if string.lower(k) == string.lower(rankName) then
                    maxZoneName = k
                    break
                end
            end
        else 
            break 
        end
    end
    return maxZoneName
end

local function WaitForReward(timeoutSeconds)
    -- Menunggu secara penuh (Hard Wait) agar animasi Brainrot bisa selesai dengan normal tanpa terpotong
    task.wait(timeoutSeconds)
end

-- ============================================================
-- Napoleon UI Library
-- ============================================================
_G.ScriptFullyLoaded = false 

local Library = loadstring(game:HttpGet("https://hewiijuaeqvftlzkjlzr.supabase.co/storage/v1/object/public/scripts/NewUI.lua"))()

local function notif(content, duration, title)
    if not _G.ScriptFullyLoaded then return end
    if Library and Library.MakeNotify then Library:MakeNotify({ Title = title or "Napoleon", Content = content, Delay = duration or 4, Icon = "rbxassetid://96531489912535" }) end
end

local Window = Library:Window({
    Title = "Napoleon", Footer = "Be A Flash For Brainrot",
    Color = Color3.fromRGB(255, 255, 255), Color2 = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130, Image = "136289055140268", WindowIMG = "93732999692312", LogoHUB = "136289055140268"
})
local Tabs = Window

local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "rbxassetid://10723415903" })
local InfoSection = InfoTab:AddSection("Napoleon - Script", true)
InfoSection:AddParagraph({ 
    Title = "Script Info", 
    Content = "Auto Farm: Auto Kick + Fly to Target.\nAuto Snap: Auto Cancel Gacha (Filter).\nAuto Place: Auto place brainrot to Plot.\nAuto Collect: Auto grab cash from plot." 
})

local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rbxassetid://10723415903" })

-- ==========================================
-- SECTION: AUTO ENDWARP
-- ==========================================
local FarmSection = MainTab:AddSection("Auto Farm")

local function startAutoEndWarp()
    if getgenv().AutoEndWarpLoop then task.cancel(getgenv().AutoEndWarpLoop) end
    if getgenv().PosLock then getgenv().PosLock:Disconnect() getgenv().PosLock = nil end
    
    getgenv().AutoEndWarpLoop = task.spawn(function()
        local mutEvent = ReplicatedStorage:FindFirstChild("ApplyMutation") or ReplicatedStorage:WaitForChild("ApplyMutation", 5)
        
        while getgenv().AutoEndWarp do
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local currentPower = GetCurrentPower()
                local targetZoneName = GetMaxSafeZone(currentPower)
                
                DashEvent:FireServer(3)
                task.wait(0.15)
                
                local zoneCFrame = ZoneCFrames[targetZoneName]
                if zoneCFrame then
                    local targetCFrame = zoneCFrame * CFrame.new(0, 3, 0)
                    hrp.CFrame = targetCFrame
                    
                    if getgenv().AutoMutation then
                        local mutEvent = ReplicatedStorage:FindFirstChild("ApplyMutation")
                        if mutEvent and getgenv().SelectedMutation and getgenv().SelectedMutation ~= "None" then
                            pcall(function() mutEvent:FireServer(getgenv().SelectedMutation) end)
                        end
                    end
                    task.wait(0.15)

                    DashEvent:FireServer("EndWarp")
                    WaitForReward(3.5)
                end
            end
            task.wait(0.5)
        end
    end)
end

FarmSection:AddToggle({
    Title = "Auto Farm", Title2 = "Enable", Content = "Auto detect power & farm max zone", Default = false,
    Callback = function(val)
        getgenv().AutoEndWarp = val
        if val then 
            startAutoEndWarp() 
            notif("Auto Farm ON", 3, "Farm") 
        else 
            if getgenv().PosLock then getgenv().PosLock:Disconnect() getgenv().PosLock = nil end
            notif("Auto Farm OFF", 3, "Farm") 
        end
    end
})

local MutationListUI = {"None", "Normal", "Gold", "Diamond", "Rainbow", "Candy", "Lava", "Blizzard", "Lightning", "Hacker"}
FarmSection:AddDropdown({
    Title = "Select Mutation", Content = "Select mutation for Auto Apply", Options = MutationListUI, Default = "None",
    Callback = function(val) getgenv().SelectedMutation = val end
})

FarmSection:AddToggle({
    Title = "Auto Mutation", Title2 = "Enable", Content = "Otomatis Mutation", Default = false,
    Callback = function(val) getgenv().AutoMutation = val end
})

-- ==========================================
-- SECTION: AUTO SNAP DENGAN "SAFE LIST" (IDE JENIUS)
-- ==========================================
local SnapSection = MainTab:AddSection("Auto Snap")

local AutoSnapConfig = {
    Enabled = false,
    KeepTargets = {"None"},
    KeepRarities = {"None"},
    KeepMutations = {"None"}
}

local SafeInstances = {}  -- Daftar barang lama yang kebal
local IncomingTrash = {}  -- Antrean nama barang yang mau dijual
local openBlockConn = nil
local backpackConn = nil

local function FormatItemName(name)
    return string.lower(string.gsub(name, "[%s_]", ""))
end

local function isMatch(list, value)
    if not value then return false end
    local lowerVal = string.lower(tostring(value))
    for _, v in ipairs(list) do
        if string.lower(tostring(v)) == lowerVal then return true end
    end
    return false
end

-- Fungsi untuk menyimpan barang lama ke dalam Safe List
local function ScanOldItems()
    SafeInstances = {}
    local count = 0
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then SafeInstances[item] = true; count = count + 1 end
        end
    end
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then SafeInstances[item] = true; count = count + 1 end
        end
    end
end

local function StartAutoSnap()
    if not OpenBlockEvent or not SellEvent then return end

    -- 1. Scan semua barang lama agar tidak pernah dijual
    ScanOldItems()

    -- 2. Deteksi Hasil Gacha
    openBlockConn = OpenBlockEvent.OnClientEvent:Connect(function(itemData, rarity, mutation)
        if not AutoSnapConfig.Enabled then return end
        
        local itemName = itemData.name or "Unknown"
        local itemRarity = itemData.rarity or rarity or "Common" 
        local itemMutation = mutation or "Normal"
        
        local keep = false
        local keepReason = ""
        
        if not table.find(AutoSnapConfig.KeepTargets, "None") and isMatch(AutoSnapConfig.KeepTargets, itemName) then 
            keep = true; keepReason = "Filter Nama ("..itemName..")"
        elseif not table.find(AutoSnapConfig.KeepRarities, "None") and isMatch(AutoSnapConfig.KeepRarities, itemRarity) then 
            keep = true; keepReason = "Filter Rarity ("..itemRarity..")"
        elseif not table.find(AutoSnapConfig.KeepMutations, "None") and isMatch(AutoSnapConfig.KeepMutations, itemMutation) then 
            keep = true; keepReason = "Filter Mutasi ("..itemMutation..")"
        end
        
        -- JIKA AMPAS, masukkan ke Antrean Sampah
        if not keep then
            table.insert(IncomingTrash, FormatItemName(itemName))
        end
    end)
    
    -- 3. Pantau Tas secara cerdas
    local backpack = LocalPlayer:WaitForChild("Backpack")
    backpackConn = backpack.ChildAdded:Connect(function(newItem)
        if not AutoSnapConfig.Enabled then return end
        
        if newItem:IsA("Tool") then
            -- JIKA INI BARANG LAMA YANG CUMA DI-UNEQUIP -> ABAIKAN!
            if SafeInstances[newItem] then return end
            
            -- Daftarkan barang baru ini ke Safe List (berjaga-jaga kalau dia nggak dijual)
            SafeInstances[newItem] = true
            
            task.wait(0.1) -- Jeda atribut server
            
            local formattedNewName = FormatItemName(newItem.Name)
            local trashIndex = table.find(IncomingTrash, formattedNewName)
            
            -- JIKA BARANG BARU INI ADALAH TARGET SAMPAH
            if trashIndex then
                -- Hapus dari daftar antrean
                table.remove(IncomingTrash, trashIndex)
                
                pcall(function() SellEvent:FireServer(newItem) end)
            end
        end
    end)
end

local function StopAutoSnap()
    if openBlockConn then openBlockConn:Disconnect() openBlockConn = nil end
    if backpackConn then backpackConn:Disconnect() backpackConn = nil end
    SafeInstances = {}
    IncomingTrash = {}
end

-- ==========================================
-- SMART DROPDOWN LOGIC
-- ==========================================
local function CreateSmartDropdown(title, content, options, targetConfigKey)
    local isUpdating = false
    local drop
    
    drop = SnapSection:AddDropdown({
        Title = title, Content = content, Options = options, Default = {"None"}, Multi = true,
        Callback = function(values)
            if isUpdating then return end
            values = values or {}
            
            local hasNone = table.find(values, "None")
            local totalValues = #values
            
            isUpdating = true
            
            if totalValues == 0 then
                task.spawn(function() drop:Set({"None"}) end)
                AutoSnapConfig[targetConfigKey] = {"None"}
            elseif hasNone and totalValues > 1 then
                local newVals = {}
                for _, v in ipairs(values) do
                    if v ~= "None" then table.insert(newVals, v) end
                end
                if values[totalValues] == "None" then
                    task.spawn(function() drop:Set({"None"}) end)
                    AutoSnapConfig[targetConfigKey] = {"None"}
                else
                    task.spawn(function() drop:Set(newVals) end)
                    AutoSnapConfig[targetConfigKey] = newVals
                end
            else
                AutoSnapConfig[targetConfigKey] = values
            end
            
            isUpdating = false
        end
    })
    return drop
end

local function GetBrainrotNames()
    local names = {"None"}
    local brainrotsFolder = ReplicatedStorage:FindFirstChild("Brainrots")
    if brainrotsFolder then
        for _, item in ipairs(brainrotsFolder:GetChildren()) do
            if not table.find(names, item.Name) then table.insert(names, item.Name) end
        end
    end
    return names
end

local BrainrotNames = GetBrainrotNames()
local RarityList = {"None", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Cosmic", "Celestial", "Divine", "Godly", "Admin", "Infinity"}
local MutationList = {"None", "Normal", "Gold", "Diamond", "Rainbow", "Candy", "Lava", "Blizzard", "Lightning", "Hacker"}

local dropTarget = CreateSmartDropdown("Target To Keep", "Select NAME of item to KEEP", BrainrotNames, "KeepTargets")
local dropRarity = CreateSmartDropdown("Rarity To Keep", "Select RARITY to KEEP", RarityList, "KeepRarities")
local dropMut = CreateSmartDropdown("Mutation To Keep", "Select MUTATION to KEEP", MutationList, "KeepMutations")

SnapSection:AddButton({
    Title = "Reset All Filters (Force None)",
    Callback = function()
        dropTarget:Set({"None"}) dropRarity:Set({"None"}) dropMut:Set({"None"})
        notif("All filters reset to None!", 3, "Filter Reset")
    end
})

SnapSection:AddToggle({
    Title = "Auto Sell Trash (Filter)", Title2 = "Enable Snap",
    Content = "Safe List Logic: Your old items are 100% SAFE!",
    Default = false,
    Callback = function(val)
        AutoSnapConfig.Enabled = val
        if val then
            StartAutoSnap()
            notif("Auto Snap ON (Safe List Aktif)", 3, "Filter")
        else
            StopAutoSnap()
            notif("Auto Snap OFF", 3, "Filter")
        end
    end
})

local AutoTab = Tabs:AddTab({ Name = "Auto", Icon = "rbxassetid://10723415903" })

local function StripRichText(text)
    return tostring(text):gsub("<[^>]+>", "")
end

local function GetMyPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    for _, plot in ipairs(plots:GetChildren()) do
        -- Cek khusus ala Tendang Blok (Decorations -> PlotOwner -> OwnerGUI -> TextLabel)
        local isDecoOwner = false
        pcall(function()
            local deco = plot:FindFirstChild("Decorations")
            local ownerObj = deco and deco:FindFirstChild("PlotOwner")
            local ownerGUI = ownerObj and ownerObj:FindFirstChild("OwnerGUI")
            local label = ownerGUI and ownerGUI:FindFirstChild("TextLabel")
            if label and (string.find(label.Text, LocalPlayer.Name) or string.find(label.Text, LocalPlayer.DisplayName)) then
                isDecoOwner = true
            end
        end)
        if isDecoOwner then return plot end
        
        -- Cek langsung object Owner
        local ownerObj = plot:FindFirstChild("Owner")
        if ownerObj then
            if typeof(ownerObj.Value) == "Instance" and ownerObj.Value == LocalPlayer then return plot end
            if type(ownerObj.Value) == "string" and string.find(ownerObj.Value, LocalPlayer.Name) then return plot end
        end
        
        -- Cek Id
        local ownerId = plot:FindFirstChild("OwnerId")
        if ownerId and ownerId.Value == LocalPlayer.UserId then return plot end
        
        -- Cek attribute
        if plot:GetAttribute("OwnerId") == LocalPlayer.UserId then return plot end
        if plot:GetAttribute("Owner") == LocalPlayer.Name then return plot end

        -- Bruteforce Cek Sign atau Descendant Text
        local isMyPlot = false
        pcall(function()
            for _, desc in ipairs(plot:GetDescendants()) do
                if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                    if string.find(desc.Text, LocalPlayer.Name) or string.find(desc.Text, LocalPlayer.DisplayName) then
                        isMyPlot = true
                        break
                    end
                elseif desc:IsA("StringValue") and (desc.Value == LocalPlayer.Name or desc.Value == LocalPlayer.DisplayName) then
                    isMyPlot = true
                    break
                elseif desc:IsA("ObjectValue") and desc.Value == LocalPlayer then
                    isMyPlot = true
                    break
                end
            end
        end)
        
        if isMyPlot then return plot end
    end
    return nil
end

-- ==========================================
-- SECTION: AUTO PLACE (FILTER)
-- ==========================================
local PlaceSection = AutoTab:AddSection("Auto Place / Filter")

local AutoPlaceConfig = {
    Rarity = {"None"},
    Mutation = {"None"}
}

local function CreatePlaceDropdown(title, content, options, targetConfigKey)
    local isUpdating = false
    local drop
    
    drop = PlaceSection:AddDropdown({
        Title = title, Content = content, Options = options, Default = {"None"}, Multi = true,
        Callback = function(values)
            if isUpdating then return end
            values = values or {}
            
            local hasNone = table.find(values, "None")
            local totalValues = #values
            
            isUpdating = true
            
            if totalValues == 0 then
                task.spawn(function() drop:Set({"None"}) end)
                AutoPlaceConfig[targetConfigKey] = {"None"}
            elseif hasNone and totalValues > 1 then
                local newVals = {}
                for _, v in ipairs(values) do
                    if v ~= "None" then table.insert(newVals, v) end
                end
                if values[totalValues] == "None" then
                    task.spawn(function() drop:Set({"None"}) end)
                    AutoPlaceConfig[targetConfigKey] = {"None"}
                else
                    task.spawn(function() drop:Set(newVals) end)
                    AutoPlaceConfig[targetConfigKey] = newVals
                end
            else
                AutoPlaceConfig[targetConfigKey] = values
            end
            
            isUpdating = false
        end
    })
    return drop
end

local placeDropRarity = CreatePlaceDropdown("Rarity To Place", "Select RARITY to place", RarityList, "Rarity")
local placeDropMut = CreatePlaceDropdown("Mutation To Place", "Select MUTATION to place", MutationList, "Mutation")

local isAutoPlacing = false

local function ExecuteAutoPlace()
    if isAutoPlacing then 
        notif("Auto Place is currently running!", 3, "Auto Place")
        return 
    end
    
    local plot = GetMyPlot()
    if not plot then
        notif("Failed to find your Plot. Make sure you have claimed a plot!", 4, "Auto Place Error")
        return
    end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not (char and root and hum) then 
        notif("Character not found!", 3, "Auto Place Error")
        return 
    end
    
    local standsFolder = plot:FindFirstChild("ModelStands")
    if not standsFolder then
        notif("Failed to find ModelStands in plot!", 3, "Auto Place Error")
        return
    end
    
    local stands = standsFolder:GetChildren()
    table.sort(stands, function(a, b)
        local numA = tonumber(a.Name:match("%d+")) or 0
        local numB = tonumber(b.Name:match("%d+")) or 0
        return numA < numB
    end)
    
    isAutoPlacing = true
    notif("Phase 1: Picking up all brainrot on the plot...", 3, "Auto Place")
    
    task.spawn(function()
        local startCFrame = root.CFrame
        
        -- 1. PICKUP SEMUA CEPAT
        local pickedUp = 0
        for _, stand in ipairs(stands) do
            local placePoint = stand:FindFirstChild("PlacePoint")
            if placePoint then
                local attPickup = placePoint:FindFirstChild("Att_Pickup")
                local pickupPrompt = attPickup and attPickup:FindFirstChild("PickupPrompt")
                
                if pickupPrompt and pickupPrompt.Enabled then
                    root.CFrame = placePoint.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.1)
                    pcall(function() fireproximityprompt(pickupPrompt) end)
                    
                    local t = 0
                    while pickupPrompt.Enabled and t < 3 do
                        task.wait(0.1)
                        t = t + 1
                    end
                    pickedUp = pickedUp + 1
                end
            end
        end
        
        if pickedUp > 0 then
            task.wait(0.8) -- Beri waktu agar item benar-benar masuk ke Backpack
        end
        
        -- 2. FILTER & SORT BACKPACK
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then isAutoPlacing = false; return end
        
        local itemsToPlace = {}
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local billboard = item:FindFirstChild("Mini_Billboard")
                if billboard then
                    local txtRarity = billboard:FindFirstChild("Txt_Rarity")
                    local txtMut = billboard:FindFirstChild("Txt_Mutation")
                    
                    local rarityVal = txtRarity and StripRichText(txtRarity.Text) or "None"
                    local mutVal = txtMut and StripRichText(txtMut.Text) or "None"
                    
                    local checkRarity = not table.find(AutoPlaceConfig.Rarity, "None")
                    local checkMut = not table.find(AutoPlaceConfig.Mutation, "None")
                    
                    local matchRarity = false
                    local matchMut = false
                    
                    if checkRarity then
                        for _, r in ipairs(AutoPlaceConfig.Rarity) do
                            if string.find(string.lower(rarityVal), string.lower(r)) then matchRarity = true; break end
                        end
                    end
                    if checkMut then
                        for _, m in ipairs(AutoPlaceConfig.Mutation) do
                            if string.find(string.lower(mutVal), string.lower(m)) then matchMut = true; break end
                        end
                    end
                    
                    local shouldPlace = false
                    if checkRarity and checkMut then
                        shouldPlace = matchRarity and matchMut
                    elseif checkRarity then
                        shouldPlace = matchRarity
                    elseif checkMut then
                        shouldPlace = matchMut
                    end
                    
                    if shouldPlace then
                        table.insert(itemsToPlace, item)
                    end
                end
            end
        end
        
        if #itemsToPlace == 0 then
            notif("No Brainrot in Inventory matches the filter!", 3, "Auto Place")
            root.CFrame = startCFrame
            isAutoPlacing = false
            return
        end
        
        -- 3. SORTING ITEMS (Tingkat Revenue Tertinggi Pertama)
        local function GetItemRevenue(item)
            local b = item:FindFirstChild("Mini_Billboard")
            if not b then return 0 end
            local txtRev = b:FindFirstChild("Txt_Revenue")
            if not txtRev then return 0 end
            
            local cleanText = StripRichText(txtRev.Text)
            
            -- Ekstrak angka dan suffix
            local numStr, suffixStr = string.match(cleanText, "([%d%.]+)%s*([a-zA-Z]*)")
            
            if numStr then
                return ParseNumber(numStr .. (suffixStr or ""))
            end
            return 0
        end
        
        table.sort(itemsToPlace, function(a, b)
            return GetItemRevenue(a) > GetItemRevenue(b)
        end)
        
        notif("Phase 2: Placing brainrot with the best REVENUE fast...", 3, "Auto Place")
        
        -- 4. PLACE FAST
        local placedCount = 0
        local standIndex = 1
        
        for _, item in ipairs(itemsToPlace) do
            local placed = false
            
            while standIndex <= #stands and not placed do
                local stand = stands[standIndex]
                local placePoint = stand:FindFirstChild("PlacePoint")
                
                if placePoint then
                    local attPlace = placePoint:FindFirstChild("Att_Place")
                    local placePrompt = attPlace and attPlace:FindFirstChild("EquipPrompt")
                    
                    local attPickup = placePoint:FindFirstChild("Att_Pickup")
                    local pickupPrompt = attPickup and attPickup:FindFirstChild("PickupPrompt")
                    
                    if placePrompt and (not pickupPrompt or not pickupPrompt.Enabled) then
                        root.CFrame = placePoint.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.15) 
                        
                        hum:EquipTool(item)
                        task.wait(0.2) 
                        
                        if placePrompt.Enabled then
                            pcall(function() fireproximityprompt(placePrompt) end)
                            placedCount = placedCount + 1
                            
                            local waitT = 0
                            while placePrompt.Enabled and waitT < 4 do
                                task.wait(0.1)
                                waitT = waitT + 1
                            end
                            
                            hum:UnequipTools()
                            placed = true
                        end
                    end
                end
                standIndex = standIndex + 1
            end
            
            if not placed then
                notif("Plot is full or failed to place!", 4, "Auto Place")
                break
            end
        end
        
        root.CFrame = startCFrame
        notif("Successfully placed " .. placedCount .. " Brainrot!", 4, "Auto Place Finished")
        isAutoPlacing = false
    end)
end

PlaceSection:AddButton({
    Title = "Start Auto Place",
    Callback = function()
        ExecuteAutoPlace()
    end
})

-- ==========================================
-- SECTION: AUTO COLLECT CASH
-- ==========================================
local CashSection = AutoTab:AddSection("Auto Collect Cash")
getgenv().AutoCollectCash = false

local function StartAutoCollect()
    task.spawn(function()
        while getgenv().AutoCollectCash do
            local plot = GetMyPlot()
            if plot then
                local standsFolder = plot:FindFirstChild("ModelStands")
                if standsFolder then
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if root then
                        local savedCFrame = root.CFrame
                        local collected = 0
                        
                        for _, stand in ipairs(standsFolder:GetChildren()) do
                            if not getgenv().AutoCollectCash then break end
                            
                            local claim1 = stand:FindFirstChild("StandClaim")
                            local claimPart = claim1 and claim1:FindFirstChild("StandClaim")
                            
                            if claimPart and claimPart:IsA("BasePart") then
                                root.CFrame = claimPart.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.1)
                                
                                local prompt = claimPart:FindFirstChildOfClass("ProximityPrompt")
                                if prompt and prompt.Enabled then
                                    pcall(function() fireproximityprompt(prompt) end)
                                end
                                
                                collected = collected + 1
                                task.wait(0.1)
                            end
                        end
                        
                        if collected > 0 and getgenv().AutoCollectCash then
                            root.CFrame = savedCFrame
                        end
                    end
                end
            end
            
            local timer = 30
            while timer > 0 and getgenv().AutoCollectCash do
                task.wait(1)
                timer = timer - 1
            end
        end
    end)
end

CashSection:AddToggle({
    Title = "Auto Collect Cash",
    Title2 = "Enable",
    Content = "Automatically visit all stands to collect cash every 30 seconds",
    Default = false,
    Callback = function(val)
        getgenv().AutoCollectCash = val
        if val then
            StartAutoCollect()
            notif("Auto Collect Cash ON", 3, "Cash")
        else
            notif("Auto Collect Cash OFF", 3, "Cash")
        end
    end
})

-- ==========================================
-- SECTION: MISC & MINI GAMES
-- ==========================================
local MiscTab = Tabs:AddTab({ Name = "Misc", Icon = "rbxassetid://10723415903" })

-- ==================
-- ANTI AFK
-- ==================
local AntiAFKSection = MiscTab:AddSection("Utilities")
getgenv().AntiAFK = true

local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFK then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

AntiAFKSection:AddToggle({
    Title = "Anti AFK",
    Title2 = "Enable",
    Content = "Prevents you from disconnecting when AFK for more than 20 minutes.",
    Default = true,
    Callback = function(val)
        getgenv().AntiAFK = val
    end
})

local MiscSection = MiscTab:AddSection("Mini Games")

-- === AUTO QTE LOGIC ===
getgenv().autoQTE = false
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().autoQTE then
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            local qteGui = playerGui and (playerGui:FindFirstChild("TreadmillQTEIcon") or playerGui:FindFirstChild("TreadmillQTE_Icon"))
            local frame = qteGui and qteGui:FindFirstChild("Frame")
            local btn = frame and frame:FindFirstChild("ImageButton")
            if btn and btn.Visible then
                pcall(function() if fireclickdetector then fireclickdetector(btn) end end)
                pcall(function()
                    if getconnections then
                        for _, conn in pairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
                        for _, conn in pairs(getconnections(btn.Activated)) do conn:Fire() end
                    end
                end)
            end
        end
    end
end)

-- === AUTO TRAIN V2 (SILENT) LOGIC ===
getgenv().autoTrainV2 = false
task.spawn(function()
    local eventsFolder = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 5)
    local TrainEvent = eventsFolder and eventsFolder:FindFirstChild("TrainTreadmillEvent") or (eventsFolder and eventsFolder:WaitForChild("TrainTreadmillEvent", 5))
    
    while task.wait(0.1) do
        if getgenv().autoTrainV2 then
            if TrainEvent then
                pcall(function() TrainEvent:FireServer(true) end)
            end
        end
    end
end)

-- === COMBINED TOGGLE ===
MiscSection:AddToggle({
    Title = "Auto Train + QTE (Combined)", 
    Title2 = "Enable", 
    Content = "Runs Auto Train V2 (Silent) & Auto Click QTE UI simultaneously", 
    Default = false,
    Callback = function(val)
        getgenv().autoQTE = val
        getgenv().autoTrainV2 = val
        if val then
            notif("Auto Train + QTE ON", 3, "Misc")
        else
            notif("Auto Train + QTE OFF", 3, "Misc")
        end
    end
})

task.wait(1)
_G.ScriptFullyLoaded = true
if Library and Library.MakeNotify then
    Library:MakeNotify({ Title = "Napoleon", Content = "Script successfully loaded! Open the Main tab.", Delay = 5, Icon = "rbxassetid://96531489912535" })
end
