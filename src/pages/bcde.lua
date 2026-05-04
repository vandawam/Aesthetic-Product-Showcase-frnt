-- -- -- ============================================================
-- -- -- CORE SECURITY: ANTI-HOOK, ANTI-SPY, & ANTI-TAMPER V3.2
-- -- -- ============================================================
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

-- -- -- -- ============================================================
-- -- -- -- KEY SYSTEM & TRACKING
-- -- -- -- ============================================================

-- local key = getgenv().Key or _G.Key
-- if not key then
--      game.Players.LocalPlayer:Kick("Napoleon: Key tidak ditemukan! Silahkan masukkan getgenv().Key")
--      return
-- end

-- local hwid = tostring(game:GetService("Players").LocalPlayer.UserId)
-- local checkUrl = "https://server-napoleon.vercel.app/api/check?key=" .. key .. "&hwid=" .. hwid
-- local successCheck, responseCheck = pcall(function()
--      return game:HttpGet(checkUrl)
-- end)

-- if successCheck and responseCheck then
--      local HttpService = game:GetService("HttpService")
     
--      -- KATA SANDI RAHASIA (Harus SAMA PERSIS dengan yang di Vercel)
--      local SECRET_KEY = "HOEEEE_MALING_PANGSIT"

--      -- Fungsi Dekripsi Hex -> XOR -> String
--      local function decryptXOR(hexStr, secret)
--          local result = {}
--          for i = 1, #hexStr, 2 do
--              local hexByte = string.sub(hexStr, i, i + 1)
--              local byteCode = tonumber(hexByte, 16)
             
--              if byteCode then
--                  local keyIndex = (((i + 1) / 2) - 1) % #secret + 1
--                  local keyByte = string.byte(secret, keyIndex)
--                  table.insert(result, string.char(bit32.bxor(byteCode, keyByte)))
--              end
--          end
--          return table.concat(result)
--      end

--      -- Coba decrypt Hex menjadi JSON, lalu parse JSON-nya
--      local ok, data = pcall(function() 
--          local decryptedString = decryptXOR(responseCheck, SECRET_KEY)
--          return HttpService:JSONDecode(decryptedString) 
--      end)

--      if ok and type(data) == "table" then
--          if not data.valid then
--              game.Players.LocalPlayer:Kick("Napoleon: " .. (data.message or "Key tidak valid / Belum reset HWID!"))
--              return
--          end
--          -- Jika berhasil, script akan lanjut berjalan ke bawah
--      else
--          -- Crash proteksi jika hacker mencoba nge-bypass JSON response pakai kata "valid": true
--          game.Players.LocalPlayer:Kick("Napoleon: Invalid response dari server. (Anti-Spoofing Activated)")
--          return
--      end
-- else
--      game.Players.LocalPlayer:Kick("Napoleon: Gagal terhubung ke server validasi key.")
--      return
-- end

-- ============================================================
-- Napoleon UI Library
-- ============================================================
local Library = loadstring(game:HttpGet("https://hewiijuaeqvftlzkjlzr.supabase.co/storage/v1/object/public/scripts/NewUI.lua"))()

local ICON_ID = "96531489912535" -- Icon Napoleon

local function notif(content, duration, title)
    -- Blokir notif spam saat UI di-load, kecuali notif sukses di akhir
    if not _G.ScriptFullyLoaded and content ~= "Script berhasil dimuat! Buka tab Farm." then
        return
    end

    if Library and Library.MakeNotify then
        Library:MakeNotify({ Title = title or "Napoleon", Content = content, Delay = duration or 4, Icon = "rbxassetid://" .. ICON_ID })
    end
end


-- ============================================================
-- SERVICES & CORE
-- ============================================================
local Players          = game:GetService("Players")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local VirtualUser      = game:GetService("VirtualUser")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local KickEvent = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Network")
    :WaitForChild("rev_KickEvent")

local CollectEvent = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Network")
    :WaitForChild("rev_B_Collect")

local UpgradeRemote = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Network")
    :WaitForChild("rev_B_Upgrade")

local SellRemote = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Network")
    :WaitForChild("ref_B_Sell")

local CollectZone = workspace:WaitForChild("Zones"):WaitForChild("CollectZone")

local SpeedServiceClient = nil
pcall(function()
    SpeedServiceClient = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ServicesLoader"):WaitForChild("SpeedServiceClient"))
end)

local function getRealRunSpeed()
    if SpeedServiceClient then
        local ok, spd = pcall(function()
            local mult = SpeedServiceClient.Multiplier or 1
            local curr = SpeedServiceClient.CurrentSpeed or 16
            if SpeedServiceClient.InSlowMode then
                return curr
            end
            return curr * mult
        end)
        if ok and type(spd) == "number" then
            return spd
        end
    end
    
    -- Fallback
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        return char.Humanoid.WalkSpeed
    end
    
    return 16
end

-- ============================================================
-- CLEAR DEBRIS PADA SAAT EXECUTE (ONE-TIME SWEEP)
-- ============================================================
-- task.spawn(function()
--     -- 1. Hapus tumpukan Brainrot / objek di Debris
--     for _, item in ipairs(workspace.Debris:GetChildren()) do
--         if item.Name ~= "SlotUpgradeSign" and item.Name ~= "PlotHitbox" then
--             pcall(function()
--                 item:Destroy()
--             end)
--         end
--     end

--     -- 2. Munculkan kembali badan teman/pemain lain menggunakan metode "Visual Clone" (Fake Body)
--     for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
--         local char = player.Character
--         if char and not char:FindFirstChild("FakeBodyShell") then
--             char.Archivable = true
--             local fakeChar = char:Clone()
--             if not fakeChar then continue end
            
--             fakeChar.Name = "FakeBodyShell"
            
--             -- Bersihkan script dan persendian di fake char agar tidak bentrok
--             for _, desc in ipairs(fakeChar:GetDescendants()) do
--                 if desc:IsA("Script") or desc:IsA("LocalScript") then
--                     desc:Destroy()
--                 elseif desc:IsA("JointInstance") then
--                     desc:Destroy()
--                 end
--             end
            
--             -- Matikan fungsi physics & display dari fake Humanoid
--             local fakeHumanoid = fakeChar:FindFirstChildOfClass("Humanoid")
--             if fakeHumanoid then
--                 fakeHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
--                 fakeHumanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
--                 fakeHumanoid.PlatformStand = true
--             end
            
--             -- Hapus HRP dari fake char
--             local fakeHRP = fakeChar:FindFirstChild("HumanoidRootPart")
--             if fakeHRP then fakeHRP:Destroy() end
            
--             -- Pasangkan part fake ke part asli
--             for _, part in ipairs(char:GetChildren()) do
--                 if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
--                     local fakePart = fakeChar:FindFirstChild(part.Name)
--                     if fakePart and fakePart:IsA("BasePart") then
--                         fakePart.Transparency = 0
--                         fakePart.LocalTransparencyModifier = 0
--                         fakePart.CanCollide = false
--                         fakePart.Massless = true
--                         fakePart.Anchored = false
--                         fakePart.CFrame = part.CFrame
                        
--                         local weld = Instance.new("WeldConstraint")
--                         weld.Part0 = part
--                         weld.Part1 = fakePart
--                         weld.Parent = fakePart
--                     end
--                 elseif part:IsA("Accessory") then
--                     local fakeAcc = fakeChar:FindFirstChild(part.Name)
--                     if fakeAcc then
--                         local handle = part:FindFirstChild("Handle")
--                         local fakeHandle = fakeAcc:FindFirstChild("Handle")
--                         if handle and fakeHandle then
--                             fakeHandle.Transparency = 0
--                             fakeHandle.LocalTransparencyModifier = 0
--                             fakeHandle.CanCollide = false
--                             fakeHandle.Massless = true
--                             fakeHandle.Anchored = false
--                             fakeHandle.CFrame = handle.CFrame
                            
--                             local weld = Instance.new("WeldConstraint")
--                             weld.Part0 = handle
--                             weld.Part1 = fakeHandle
--                             weld.Parent = fakeHandle
--                         end
--                     end
--                 end
--             end
            
--             fakeChar.Parent = char
--         end
--     end
-- end)

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    AutoFarm           = false,
    isRejoin         = false,
    AutoClickUpgrade   = true,   -- default ON, di Misc
    AutoCollectCash    = false,
    AutoUpgradeLevel   = false,
    TargetUpgradeLevel = 50,

    EnableSnap         = false,
    SnapMode           = "Spesifik",
    -- Multi-select: tabel berisi pilihan yang aktif
    TargetMutations    = {"None"},  -- {"Plasma", "Diamond"} atau {"None"}
    TargetBrainrots    = {"None"},  -- {"None"} = semua nama boleh
    TargetRarities     = {"None"},  -- {"None"} = semua rarity boleh

    EquipMode          = "CPS",

    -- Auto Sell
    AutoSell             = false,
    SellMode             = "Brainrot",    -- "Brainrot", "Rarity"
    TargetSellBrainrots  = {"None"},
    TargetSellRarities   = {"None"},
    ProtectSellMutations = {"None"},

    -- Auto Trade
    AutoTrade            = false,
    TradeTargetPlayer    = "None",
    TargetTradeBrainrots = {"None"},
    TargetTradeRarities  = {"None"},
    TargetTradeMutations = {"None"},

    -- Auto Accept Trade
    AutoAcceptTrade      = false,

    -- Webhook
    EnableWebhook        = false,
    WebhookURL           = "",
    WebhookRarities      = {"None"},
    WebhookMutations     = {"None"},
}

-- List mutasi dari game data (MutationData.ValidMutations + None)
local MUTATION_LIST = {
    "None",        -- Semua boleh
    "Non Mutasi",  -- Harus tanpa mutasi
    "Golden",
    "Diamond",
    "Plasma",
    "Radioactive",
    "Molten",
    "Void",
    "Shadow",
    "Electrified",
    "Rainbow",
    "Virus",
}

-- List rarity untuk mode Snap Rarity (sesuai data game terbaru)
local RARITY_LIST = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Godly", "Secret", "Divine", "Hacked", "OG", "Celestial", "Exclusive" }

-- Map nama brainrot → raritynya (sumber: EntityData game terbaru)
local BRAINROT_RARITY_MAP = {
    -- Common
    ["Noobini Pizzanini"]="Common",  ["Lirili Larila"]="Common",
    ["Tim Cheese"]="Common",         ["Talpa Di Fero"]="Common",
    ["Svinina Bombardino"]="Common", ["Pipi Kiwi"]="Common",
    ["Fruli Frula"]="Common",        ["Trippi Troppi"]="Common",
    -- Rare
    ["Gangster Footera"]="Rare",     ["Bobrito Bandito"]="Rare",
    ["Boneca Ambalabu"]="Rare",      ["Ta Ta Ta Ta Sahur"]="Rare",
    ["Ballerina Cappuccina"]="Rare", ["Cappuccino Assassino"]="Rare",
    ["Brr Brr Patapim"]="Rare",     ["Cacto Hipopotamo"]="Rare",
    -- Epic
    ["Garamararam"]="Epic",          ["Madung"]="Epic",
    ["Waterdino"]="Epic",            ["Pesto Mortioni"]="Epic",
    ["Pannaburro"]="Epic",           ["Orcalero"]="Epic",
    ["Mangolini Parrocini"]="Epic",  ["John Pork"]="Epic",
    ["Gattatino Nyanino"]="Epic",
    -- Legendary
    ["Chimpanzini Bananini"]="Legendary", ["Plan Red"]="Legendary",
    ["Plan Blue"]="Legendary",            ["Capi Taco"]="Legendary",
    ["Trulimero Trulicina"]="Legendary",  ["Bambini Crostini"]="Legendary",
    ["Elefantucci Bananucci"]="Legendary",
    ["Bananita Dolphinita"]="Legendary",  ["Salamino Pinguino"]="Legendary",
    -- Mythic
    ["Penguino Cocosino"]="Mythic",  ["67"]="Mythic",
    ["Burbaloni Luliloli"]="Mythic", ["Chef Crabracadabra"]="Mythic",
    ["Capybara Eggplant"]="Mythic",  ["Bangello"]="Mythic",
    ["Elefanto Frigo"]="Mythic",     ["Rinooccio Verdini"]="Mythic",
    ["Glorbo Fruttodrillo"]="Mythic",
    -- Godly
    ["Udin Din Din Dun"]="Godly",         ["Pandaccini Bananini"]="Godly",
    ["Octopusini Bluberini"]="Godly",     ["Strawberelli Flamingelli"]="Godly",
    ["Sigma Boy"]="Godly",                ["Frigo Camelo"]="Godly",
    ["Orangutini Ananasini"]="Godly",     ["Rhino Toasterino"]="Godly",
    ["Bombardiro Crocodilo"]="Godly",
    -- Secret
    ["Bombini Gusini"]="Secret",          ["Tuff Toucan"]="Secret",
    ["Fryuro"]="Secret",                  ["Burguro"]="Secret",
    ["Guest666"]="Secret",                ["Zibra Zubra Zibralini"]="Secret",
    ["Cavallo Virtuso"]="Secret",         ["Gorillo Watermelondrillo"]="Secret",
    ["Cocofanto Elefanto"]="Secret",
    -- Divine
    ["Girafa Celeste"]="Divine",     ["Tralalero Tralala"]="Divine",
    ["Tralalerita Tralala"]="Divine", ["Peant Jarro"]="Divine",
    ["Dipperi Chiperini"]="Divine",  ["Rexosaurus"]="Divine",
    ["1x1x1x1"]="Divine",           ["Matteo"]="Divine",
    ["Espresso Signora"]="Divine",
    -- Hacked
    ["Alessio"]="Hacked",                 ["Tripi Tropi Tropa Tripa"]="Hacked",
    ["SWAG SODA"]="Hacked",              ["Stoppo Luminino"]="Hacked",
    ["Torrtuginni Dragonfrutini"]="Hacked",["Tictac Sahur"]="Hacked",
    ["Los Primos Blue"]="Hacked",         ["Cactus Pingu"]="Hacked",
    ["La Vacca Saturno Saturnita"]="Hacked",["Agarrini La Palini"]="Hacked",
    -- OG
    ["Karkerkar Kurkur"]="OG",      ["Blackhole Goat"]="OG",
    ["Cappuccino Clownino"]="OG",   ["Compactoroni Diskaloni"]="OG",
    ["Nuclearo Dinossauro"]="OG",   ["Chillin Chilli"]="OG",
    ["Crazylone Pizaione"]="OG",   ["Corn Sahur"]="OG",
    ["Meowl"]="OG",                ["Strawberry Elephant"]="OG",
    -- Celestial
    ["Dragonfrutina Dolphinita"]="Celestial",  ["Guerriro Digitale"]="Celestial",
    ["Chicleteira Bicicleteira"]="Celestial",   ["Pot Hotspot"]="Celestial",
    ["Krupuk Pagi Pagi"]="Celestial",           ["Beluga Beluga"]="Celestial",
    ["Tralaledon"]="Celestial",                 ["Anpali Babel"]="Celestial",
    ["Mastodontico Telepiedone"]="Celestial",   ["Ketupat Kepat"]="Celestial",
    -- Exclusive
    ["Dragon Cannelloni"]="Exclusive",        ["W"]="Exclusive",
    ["Spaghetti Tualetti"]="Exclusive",       ["Esok Sekolah"]="Exclusive",
    ["Bambu Sahur"]="Exclusive",              ["Bottellini"]="Exclusive",
    ["Castlino Fortini"]="Exclusive",         ["Ketchuru Matsuru"]="Exclusive",
    ["Los Nooo My Hotspotsitos"]="Exclusive", ["W or L"]="Exclusive",
}

local BRAINROT_LIST = {
    "None",  -- Semua brainrot (tidak filter nama)
    "1x1x1x1", "67", "Agarrini La Palini", "Alessio", "Anpali Babel", "Ballerina Cappuccina",
    "Bambini Crostini", "Bambu Sahur", "Bananita Dolphinita", "Bangello", "Beluga Beluga", "Blackhole Goat",
    "Bobrito Bandito", "Bombardiro Crocodilo", "Bombini Gusini", "Boneca Ambalabu", "Bottellini", "Brr Brr Patapim",
    "Burbaloni Luliloli", "Cacto Hipopotamo", "Cactus Pingu", "Capi Taco", "Cappuccino Assassino",
    "Cappuccino Clownino", "Capybara Eggplant", "Castlino Fortini", "Cavallo Virtuso", "Chef Crabracadabra",
    "Chicleteira Bicicleteira", "Chillin Chilli", "Chimpanzini Bananini", "Cocofanto Elefanto",
    "Compactoroni Diskaloni", "Corn Sahur", "Crazylone Pizaione", "Dipperi Chiperini",
    "Dragon Cannelloni", "Dragonfrutina Dolphinita", "Elefanto Frigo", "Elefantucci Bananucci", "Esok Sekolah", "Espresso Signora",
    "Frigo Camelo", "Fruli Frula", "Fryuro", "Gangster Footera", "Garamararam", "Gattatino Nyanino",
    "Girafa Celeste", "Glorbo Fruttodrillo", "Gorillo Watermelondrillo", "Guerriro Digitale",
    "Guest666", "John Pork", "Karkerkar Kurkur", "Ketchuru Matsuru", "Ketupat Kepat", "Krupuk Pagi Pagi",
    "La Vacca Saturno Saturnita", "Lirili Larila", "Los Nooo My Hotspotsitos", "Los Primos Blue", "Madung", "Mangolini Parrocini",
    "Mastodontico Telepiedone", "Matteo", "Meowl", "Noobini Pizzanini", "Nuclearo Dinossauro",
    "Octopusini Bluberini", "Orangutini Ananasini", "Orcalero", "Pandaccini Bananini", "Pannaburro",
    "Peant Jarro", "Penguino Cocosino", "Pesto Mortioni", "Pipi Kiwi", "Plan Blue", "Plan Red",
    "Pot Hotspot", "Rexosaurus", "Rhino Toasterino", "Rinooccio Verdini", "SWAG SODA",
    "Salamino Pinguino", "Sigma Boy", "Spaghetti Tualetti", "Stoppo Luminino", "Strawberelli Flamingelli",
    "Strawberry Elephant", "Svinina Bombardino", "Ta Ta Ta Ta Sahur", "Talpa Di Fero", "Tictac Sahur",
    "Tim Cheese", "Torrtuginni Dragonfrutini", "Tralaledon", "Tralalero Tralala", "Tralalerita Tralala",
    "Tripi Tropi Tropa Tripa", "Trippi Troppi", "Trulimero Trulicina", "Tuff Toucan",
    "Udin Din Din Dun", "W", "W or L", "Waterdino", "Zibra Zubra Zibralini"
}

-- ============================================================
-- UTILITY: Deteksi brainrot milik player sendiri
-- Brainrot di-Weld ke HRP (Part0=HRP, Part1=brainrot.Root)
-- Weld.Parent = HRP
-- ============================================================
local function getMyBrainrot()
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then return nil end
    for _, child in ipairs(char.PrimaryPart:GetChildren()) do
        if child:IsA("Weld") and child.Part1 then
            local model = child.Part1.Parent
            if model and model.Parent == workspace.Debris then
                return model
            end
        end
    end
    return nil
end

-- ============================================================
-- UTILITY: BodyVelocity helper
-- ============================================================
local function ensureBodyVelocity(hrp)
    local bv = hrp:FindFirstChild("iSylHubBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name     = "iSylHubBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent   = hrp
    end
    bv.Velocity = Vector3.new(0, 0, 0)
    return bv
end

local function removeBodyVelocity(hrp)
    if not hrp then return end
    local bv = hrp:FindFirstChild("iSylHubBV")
    if bv then bv:Destroy() end
end

-- ============================================================
-- AUTO FARM (HEARTBEAT FLY DENGAN SPEED ASLI GAME)
-- ============================================================
local SafeZone = CFrame.new(700.160706, 3.15000606, 232.393646)
local isFly = false 
local isDelaying = false

-- ============================================================
-- 1. FUNGSI KICK (DENGAN PERFECT ANIMATION TRICK)
-- ============================================================
local function Kick()
    if not Config.AutoFarm then return end
    
    local isDebounced = LocalPlayer:GetAttribute("KickDebounced")
    if not isDebounced then
        pcall(function()
            -- 🔥 TRICK ANIMASI PERFECT: Paksa module client menyentuh angka 1
            if kickModule then kickModule.Scale = 1 end 
            
            KickEvent:FireServer(1)
        end)
    end
end

local lastTransformedData = { Name = "", Mutation = "None", IsMatch = true }

-- ============================================================
-- 2. PENERIMA SINYAL GACHA & AUTO SNAP / FLY (TANPA HOOKING)
-- ============================================================

-- 1. Mengambil module KickServiceClient dari memori game
local KickServiceClient = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ServicesLoader"):WaitForChild("KickServiceClient"))

-- 2. Memastikan tabel Multipliers tersedia agar tidak error
if type(KickServiceClient.Multipliers) ~= "table" then
    KickServiceClient.Multipliers = {}
end

local targetCFrame = CFrame.new(700.160706, 3.15000606, 232.393646)

local function forceRespawnAndTeleport()
    local char = LocalPlayer.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    -- 1. Siapkan pendeteksi karakter baru SEBELUM karakter saat ini dibunuh
    local connection
    connection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        -- Langsung putuskan koneksi agar tidak terus-menerus teleport setiap kali mati
        if connection then
            connection:Disconnect()
        end

        -- Tunggu HumanoidRootPart dimuat
        local hrp = newChar:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            -- Beri jeda sangat singkat agar sistem spawn bawaan game selesai dieksekusi lebih dulu
            -- Ini mencegah teleport kita "ditimpa" oleh spawn point dari game
            task.wait(0.25) 

            -- Teleport karakter ke CFrame target menggunakan PivotTo (lebih stabil)
            newChar:PivotTo(targetCFrame)
        end
    end)

    -- 2. Eksekusi karakter (Tiru cara TsunamiController membunuh pemain)
    -- Kita tidak menggunakan BreakJoints() atau Destroy() agar kematian terlihat "Natural" di server
    humanoid:TakeDamage(1000)
end


-- Variabel sementara untuk menyimpan data brainrot yang sedang diproses
local pendingWebhookData = nil

KickEvent.OnClientEvent:Connect(function(arg1, data)
    if type(data) == "table" and data.Name then
        local gotName = data.Name
        local gotMutation = data.Mutation or "None"
        local gotRarity = BRAINROT_RARITY_MAP[gotName] or "Common"
        
        if not Config.AutoFarm then return end

        local targetMatch = true 

        -- 🔥 FILTER CHECK 🔥
        if Config.EnableSnap then
            targetMatch = false
            local mutationMatch = false
            for _, m in ipairs(Config.TargetMutations) do
                if m == "None" or m == gotMutation then mutationMatch = true; break end
            end

            local nameMatch = false
            for _, n in ipairs(Config.TargetBrainrots) do
                if n == "None" or n == gotName then nameMatch = true; break end
            end

            local rarityMatch = false
            for _, r in ipairs(Config.TargetRarities) do
                if r == "None" or r == gotRarity then rarityMatch = true; break end
            end

            if Config.SnapMode == "Spesifik" then
                if mutationMatch and nameMatch and rarityMatch then targetMatch = true end
            else
                local isAllNone = (Config.TargetMutations[1] == "None") and (Config.TargetBrainrots[1] == "None") and (Config.TargetRarities[1] == "None")
                if isAllNone then targetMatch = true else
                    if Config.TargetMutations[1] ~= "None" and mutationMatch then targetMatch = true end
                    if Config.TargetBrainrots[1] ~= "None" and nameMatch then targetMatch = true end
                    if Config.TargetRarities[1] ~= "None" and rarityMatch then targetMatch = true end
                end
            end
        end

        _G.TargetDitemukan = targetMatch
        if targetMatch then
            KickServiceClient.Multipliers.Speed = 1
        else
            KickServiceClient.Multipliers.Speed = 9e9
            if Config.isRejoin then
                local scriptSetelahRejoin = [[
                    -- Tunggu sampai loading screen Roblox benar-benar selesai
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/vandawam/Aesthetic-Product-Showcase-frnt/refs/heads/main/src/pages/bcde.lua"))()
                ]]

                local queueFunc = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)

                if queueFunc then
                    queueFunc(scriptSetelahRejoin)
                    print("Script berhasil dititipkan. Bersiap rejoin...")
                else
                    warn("Eksekutormu tidak mendukung queue_on_teleport! Teleport otomatis mungkin akan gagal.")
                end
                -- Rejoin untuk cancel gacha (lebih bersih daripada force respawn)
                game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
            end
        end

        -- 🟢 SIMPAN DATA JIKA MATCH 🟢
        -- Jika target cocok dengan filter, simpan datanya untuk dikirim webhook nanti
        -- saat server mengonfirmasi success (EventEnded = true)
        pendingWebhookData = {
            name = gotName,
            mutation = gotMutation
        }
        

        -- ⏳ TUNGGU ANIMASI GACHA SELESAI, BARU BERTINDAK ⏳
        task.spawn(function()
            isDelaying = true
            isFly = false
            
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- Tunggu game mengunci karakter (Pertanda animasi gacha berputar dimulai)
            local timeoutAnchor = 0
            while hrp and not hrp.Anchored and timeoutAnchor < 50 do
                task.wait(0.1)
                timeoutAnchor = timeoutAnchor + 1
            end
            
            -- Tunggu game melepas kunci karakter (Pertanda animasi selesai & Transformed)
            while hrp and hrp.Anchored do
                task.wait(0.1)
            end
            
            -- Kasih jeda sedikit agar efeknya rapi
            task.wait(0.1)

                
            if not targetMatch and Config.EnableSnap then
                forceRespawnAndTeleport()
                -- ❌ AMPAS: SNAP! (Teleport balik ke SafeZone untuk cancel gacha)
                isDelaying = false
            else
                -- ✅ JACKPOT: GAS TERBANG KE COLLECT ZONE!
                isDelaying = false
                isFly = true
            end
        end)
    end
end)



-- ============================================================
-- 3. AUTO FARM FLYING (REAL SPEED)
-- ============================================================
RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")

    if not Config.AutoFarm then
        if hrp then removeBodyVelocity(hrp) end
        isFly = false
        isDelaying = false
        return
    end

    if not char or not hrp then return end

    if isDelaying then
        removeBodyVelocity(hrp)
        hrp.AssemblyLinearVelocity = Vector3.zero
        return
    end

    if not isFly then
        removeBodyVelocity(hrp)
        return
    end

    local target  = CollectZone.Position
    local current = hrp.Position
    
    -- Hitung jarak secara 2D agar lebih presisi masuk kotak
    local dist = (Vector3.new(target.X, 0, target.Z) - Vector3.new(current.X, 0, current.Z)).Magnitude

    if dist < 40 then
        -- SAMPAI! Mendarat dan tembak remote collect
        removeBodyVelocity(hrp)
        hrp.AssemblyLinearVelocity = Vector3.zero
        isFly = false 

        pcall(function()
            local Network = game:GetService("ReplicatedStorage").Shared.Packages.Network
            local Event = Network:FindFirstChild("rev_KickCollect")
            if Event then Event:FireServer() end
        end)
        return
    end

    local ensureBV = ensureBodyVelocity(hrp)
    local flyTarget = Vector3.new(target.X, target.Y + 3, target.Z)
    local direction = (flyTarget - current).Unit
    local realSpeed = getRealRunSpeed()
    local step      = math.min(realSpeed * dt, dist)

    hrp.CFrame = CFrame.new(current + direction * step) * (hrp.CFrame - hrp.CFrame.Position)
end)

-- ============================================================
-- 4. MAIN LOOP AUTO FARM
-- ============================================================
local function startFarm()
    task.spawn(function()
        while Config.AutoFarm do
            task.wait(0.1) 
            
            if isDelaying or isFly then continue end 
            if getMyBrainrot() then continue end
            
            local isDebounced = LocalPlayer:GetAttribute("KickDebounced")
            if isDebounced then continue end

            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = SafeZone
                task.wait(0.05)
                Kick()
            end
        end
    end)
end

-- ============================================================
-- 1. Anti-AFK
-- ============================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)



local lastTransformedData = { Name = "", Mutation = "None", IsMatch = true }
local sendWebhook = nil

-- ============================================================
-- EVENT LISTENER UNTUK WEBHOOK & AUTO FLY (DELAY AMAN 10 DETIK)
-- ============================================================
pcall(function()
    KickEvent.OnClientEvent:Connect(function(arg1, data)
        if type(data) == "table" and data.Name then
            lastTransformedData.Name     = data.Name
            lastTransformedData.Mutation = data.Mutation or "None"
            
            -- Trigger Auto Fly setelah mendeteksi brainrot
            if Config.AutoFarm then
                task.spawn(function()
                    isDelaying = true
                    isFly = false
                    
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        -- Tunggu game mengunci (anchor) karakter saat animasi dimulai
                        local timeoutAnchor = 0
                        while not hrp.Anchored and timeoutAnchor < 50 do
                            task.wait(0.1)
                            timeoutAnchor = timeoutAnchor + 1
                        end
                        
                        -- Tunggu game melepas (un-anchor) karakter, yang menandakan animasi roll selesai 100%
                        while hrp.Anchored do
                            task.wait(0.1)
                        end
                    end
                    
                    -- Tahan 10 detik persis SETELAH animasi roll selesai sesuai permintaan
                    -- task.wait(5)
                    
                    isDelaying = false
                    isFly = true
                end)
            end
        end
    end)
end)


-- ============================================================
local kickModule = nil

local function findKickModule()
    pcall(function()
        for _, module in ipairs(getloadedmodules()) do
            pcall(function()
                local req = require(module)
                if type(req) == "table"
                    and type(req.PerformKick) == "function"
                    and req.Scale ~= nil
                    and req.InMinigame ~= nil
                then
                    kickModule = req
                    
                    if not req._originalPerformKick then
                        req._originalPerformKick = req.PerformKick
                        req.PerformKick = function(self, p48, p_u_49)
                            return req._originalPerformKick(self, p48, p_u_49)
                        end
                    end
                end
            end)
        end
    end)
end
-- ============================================================
-- 🌟 PERFECT KICK ANIMATION ENFORCER (100% SCALE)
-- ============================================================
task.spawn(function()
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local KickController = require(ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("ControllerLoader"):WaitForChild("KickController"))
        
        -- Kunci nilai Scale menjadi 1.0 terus-menerus
        game:GetService("RunService").Heartbeat:Connect(function()
            if Config.AutoFarm then
                KickController.Scale = 1
            end
        end)
        
        print("[Napoleon] Perfect Animation Enforcer Aktif!")
    end)
end)

findKickModule()


if kickModule then
    notif("Kick module ditemukan ✓", 3, "Perfect Kick")
else
    task.delay(5, function()
        findKickModule()
        if kickModule then
            notif("Kick module ditemukan ✓ (delayed)", 3, "Perfect Kick")
        end
    end)
end

-- ============================================================
-- DISABLE WAVE ANIMATION ONLY (ringan, no heavy hooks)
-- ============================================================
task.spawn(function()
    task.wait(3)
    pcall(function()
        for _, mod in ipairs(getloadedmodules()) do
            pcall(function()
                local req = require(mod)
                if type(req) == "table" and type(req.SpawnWave) == "function" then
                    req.SpawnWave = function()
                        pcall(function()
                            local cam = workspace.CurrentCamera
                            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                            cam.CameraType = Enum.CameraType.Custom
                            if hum then cam.CameraSubject = hum end
                        end)
                        return function() end
                    end
                    notif("Wave animation OFF ✓", 3, "Napoleon")
                end
            end)
        end
    end)
end)


-- ============================================================
-- UTILITY: Cari plot milik LocalPlayer
-- ============================================================
local function findMyPlot()
    local myPlot = nil
    pcall(function()
        local plotsFolder = workspace:WaitForChild("Plots", 5)
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            -- Method 1: cek Attribute "Owner"
            local ok1, attrOwner = pcall(function() return plot:GetAttribute("Owner") end)
            if ok1 and attrOwner == LocalPlayer.Name then
                myPlot = plot; return
            end
            -- Method 2: fallback cek TextLabel di OwnerGUI
            local deco     = plot:FindFirstChild("Decorations")
            local ownerObj = deco and deco:FindFirstChild("PlotOwner")
            local ownerGUI = ownerObj and ownerObj:FindFirstChild("OwnerGUI")
            local label    = ownerGUI and ownerGUI:FindFirstChild("TextLabel")
            if label and string.find(label.Text, LocalPlayer.Name, 1, true) then
                myPlot = plot; return
            end
        end
    end)
    return myPlot
end

local function getMaxSlot()
    local maxSlot = 0
    pcall(function()
        local myPlot = findMyPlot()
        if not myPlot then return end
        local buttons = myPlot:FindFirstChild("Buttons")
        if not buttons then return end
        for _, child in ipairs(buttons:GetChildren()) do
            local n = tonumber(child.Name:match("%d+$"))
            if n and n > maxSlot then
                maxSlot = n
            end
        end
    end)
    return maxSlot
end

-- ============================================================
-- 6. Auto Collect Cash
-- ============================================================
local isCollecting = false
local function startCollectCash()
    task.spawn(function()
        while Config.AutoCollectCash do
            pcall(function()
                local char = LocalPlayer.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                if not char or not hrp then return end

                -- Cari plot milik player
                local myPlot = findMyPlot()
                if not myPlot then
                    warn("[AutoCollect] Plot tidak ditemukan, skip siklus ini.")
                    return
                end

                local buttons = myPlot:FindFirstChild("Buttons")
                if not buttons then
                    warn("[AutoCollect] Folder Buttons tidak ada di " .. myPlot.Name)
                    return
                end

                -- Simpan CFrame asli sebelum mulai teleport
                local savedCF = hrp.CFrame
                isCollecting  = true

                -- Iterasi tiap slot
                local slots = buttons:GetChildren()
                table.sort(slots, function(a, b)
                    local na = tonumber(a.Name:match("%d+$")) or 0
                    local nb = tonumber(b.Name:match("%d+$")) or 0
                    return na < nb
                end)

                for _, slot in ipairs(slots) do
                    if not Config.AutoCollectCash then break end
                    local slotNum = tonumber(slot.Name:match("%d+$"))
                    if slotNum then
                        hrp.CFrame = slot.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.06)
                        pcall(function()
                            CollectEvent:FireServer(slotNum)
                        end)
                        task.wait(0.08)
                    end
                end

                -- Kembali ke posisi semula
                hrp.CFrame = savedCF
                isCollecting = false
            end)
            task.wait(1)
        end
        isCollecting = false
    end)
end

-- ============================================================
-- RARITY RANK untuk Auto Equip Best
-- ============================================================
local RARITY_RANK = {
    ["Common"]=1,  ["Rare"]=2,   ["Epic"]=3,    ["Legendary"]=4,
    ["Mythic"]=5,  ["Godly"]=6,  ["Secret"]=7,  ["Divine"]=8,
    ["Hacked"]=9,  ["OG"]=10,   ["Celestial"]=11, ["Exclusive"]=12,
}

-- ============================================================
-- DATABASE BASE CPS & MUTATION BUFFS
-- ============================================================
local EntityBaseCPS = {
    ["Noobini Pizzanini"]=2,                  ["Lirili Larila"]=3,
    ["Tim Cheese"]=3,                         ["Talpa Di Fero"]=4,
    ["Svinina Bombardino"]=5,                 ["Pipi Kiwi"]=6,
    ["Fruli Frula"]=7,                        ["Trippi Troppi"]=7,
    ["Gangster Footera"]=15,                  ["Bobrito Bandito"]=17,
    ["Boneca Ambalabu"]=17,                   ["Ta Ta Ta Ta Sahur"]=18,
    ["Ballerina Cappuccina"]=19,              ["Cappuccino Assassino"]=22,
    ["Brr Brr Patapim"]=22,                   ["Cacto Hipopotamo"]=26,
    ["Garamararam"]=40,                       ["Madung"]=44,
    ["Waterdino"]=50,                         ["Pesto Mortioni"]=52,
    ["Pannaburro"]=62,                        ["Orcalero"]=64,
    ["Mangolini Parrocini"]=64,               ["John Pork"]=72,
    ["Gattatino Nyanino"]=76,                 ["Chimpanzini Bananini"]=100,
    ["Plan Red"]=130,                         ["Plan Blue"]=140,
    ["Capi Taco"]=150,                        ["Trulimero Trulicina"]=160,
    ["Bambini Crostini"]=160,                 ["Elefantucci Bananucci"]=170,
    ["Bananita Dolphinita"]=210,              ["Salamino Pinguino"]=230,
    ["Penguino Cocosino"]=450,                ["67"]=500,
    ["Burbaloni Luliloli"]=550,               ["Chef Crabracadabra"]=600,
    ["Capybara Eggplant"]=650,                ["Bangello"]=725,
    ["Elefanto Frigo"]=775,                   ["Rinooccio Verdini"]=880,
    ["Glorbo Fruttodrillo"]=920,              ["Udin Din Din Dun"]=1850,
    ["Pandaccini Bananini"]=2000,             ["Octopusini Bluberini"]=2150,
    ["Strawberelli Flamingelli"]=2300,        ["Sigma Boy"]=2450,
    ["Frigo Camelo"]=2600,                    ["Orangutini Ananasini"]=2700,
    ["Rhino Toasterino"]=2950,                ["Bombardiro Crocodilo"]=3100,
    ["Bombini Gusini"]=4750,                  ["Tuff Toucan"]=5300,
    ["Fryuro"]=5850,                          ["Burguro"]=6250,
    ["Guest666"]=7000,                        ["Zibra Zubra Zibralini"]=7750,
    ["Cavallo Virtuso"]=8500,                 ["Gorillo Watermelondrillo"]=9500,
    ["Cocofanto Elefanto"]=10000,             ["Girafa Celeste"]=16500,
    ["Tralalero Tralala"]=17500,              ["Tralalerita Tralala"]=18000,
    ["Peant Jarro"]=19500,                    ["Dipperi Chiperini"]=20000,
    ["Rexosaurus"]=22500,                     ["1x1x1x1"]=23000,
    ["Matteo"]=25000,                         ["Espresso Signora"]=27500,
    ["Alessio"]=27500,                        ["Tripi Tropi Tropa Tripa"]=28000,
    ["SWAG SODA"]=29000,                      ["Stoppo Luminino"]=30000,
    ["Torrtuginni Dragonfrutini"]=32000,      ["Tictac Sahur"]=38000,
    ["Los Primos Blue"]=44500,                ["Cactus Pingu"]=44500,
    ["La Vacca Saturno Saturnita"]=49500,     ["Agarrini La Palini"]=53500,
    ["Karkerkar Kurkur"]=120000,              ["Blackhole Goat"]=125000,
    ["Cappuccino Clownino"]=135000,           ["Compactoroni Diskaloni"]=135000,
    ["Nuclearo Dinossauro"]=190000,           ["Chillin Chilli"]=220000,
    ["Crazylone Pizaione"]=225000,            ["Corn Sahur"]=225000,
    ["Meowl"]=275000,                         ["Strawberry Elephant"]=420000,
    ["Dragonfrutina Dolphinita"]=475000,      ["Guerriro Digitale"]=490000,
    ["Chicleteira Bicicleteira"]=500000,      ["Pot Hotspot"]=525000,
    ["Krupuk Pagi Pagi"]=540000,              ["Beluga Beluga"]=575000,
    ["Tralaledon"]=625000,                    ["Anpali Babel"]=750000,
    ["Mastodontico Telepiedone"]=850000,      ["Ketupat Kepat"]=1000000,
    
    -- Exclusive
    ["Dragon Cannelloni"]=0,                  ["W"]=0,
    ["Spaghetti Tualetti"]=0,                 ["Esok Sekolah"]=0,
    ["Bambu Sahur"]=12500,                    ["Bottellini"]=75000,
    ["Castlino Fortini"]=5000,                ["Ketchuru Matsuru"]=800000,
    ["Los Nooo My Hotspotsitos"]=200000,      ["W or L"]=15000
}

local MutationBuffs = {
    ["Golden"]=1.5, ["Diamond"]=2, ["Plasma"]=4, ["Molten"]=6,
    ["Radioactive"]=8, ["Void"]=10, ["Shadow"]=12, ["Electrified"]=16, ["Rainbow"]=30, ["Virus"]=10,
}

local WEBHOOK_COLORS = {
    ["Common"]=11184810, ["Rare"]=3447003, ["Epic"]=10181046, ["Legendary"]=15105570,
    ["Mythic"]=15844367, ["Godly"]=15277667, ["Secret"]=2829617, ["Divine"]=16776960,
    ["Hacked"]=0, ["OG"]=16711680, ["Celestial"]=5793266, ["Exclusive"]=16753920
}

local CachedEntitiesData = nil
local function getRbxAssetImage(name)
    if not CachedEntitiesData then
        for _, mod in ipairs(getloadedmodules()) do
            pcall(function()
                local req = require(mod)
                if type(req) == "table" then
                    -- Cek di root tabel
                    if req[name] and req[name].Image then
                        CachedEntitiesData = req
                    else
                        -- Cek 1 level lebih dalam (nested table)
                        for _, v in pairs(req) do
                            if type(v) == "table" and v[name] and v[name].Image then
                                CachedEntitiesData = v
                                break
                            end
                        end
                    end
                end
            end)
            if CachedEntitiesData then break end
        end
    end
    if CachedEntitiesData and CachedEntitiesData[name] then
        return CachedEntitiesData[name].Image
    end
    return nil
end

local function getDiscordImageUrl(rbx_id)
    local id = string.match(rbx_id or "", "%d+")
    if not id then return nil end
    local apiUrl = "https://thumbnails.roblox.com/v1/assets?assetIds="..id.."&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false"
    
    local reqFunc = request or http_request or (syn and syn.request)
    if not reqFunc then return nil end

    local success, response = pcall(function()
        return reqFunc({ Url = apiUrl, Method = "GET" })
    end)
    if success and response and response.Body then
        local decoded = HttpService:JSONDecode(response.Body)
        if decoded.data and decoded.data[1] and decoded.data[1].imageUrl then
            return decoded.data[1].imageUrl
        end
    end
    return nil
end

local function formatNumber(n)
    if n >= 1e9 then
        return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then
        return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then
        return string.format("%.2fK", n / 1e3)
    else
        return tostring(n)
    end
end

local function sendWebhook(name, mutation, isTest)
    if not Config.EnableWebhook and not isTest then return end
    if Config.WebhookURL == "" then return end
    
    local rarity = BRAINROT_RARITY_MAP[name] or "Common"
    
    if not isTest then
        local isMutValid = false
        for _, m in ipairs(Config.WebhookMutations) do
            if m == "None" then
                isMutValid = true; break
            else
                local checkM = (m == "Non Mutasi") and "None" or m
                if checkM == mutation then isMutValid = true; break end
            end
        end

        local isRarityValid = false
        for _, r in ipairs(Config.WebhookRarities) do
            if r == "None" or r == rarity then
                isRarityValid = true; break
            end
        end

        -- NOT SPESIFIK LOGIC (OR)
        local isAllNone = (Config.WebhookMutations[1] == "None") and (Config.WebhookRarities[1] == "None")
        
        if not isAllNone then
            local matchedAny = false
            if Config.WebhookMutations[1] ~= "None" and isMutValid then matchedAny = true end
            if Config.WebhookRarities[1] ~= "None" and isRarityValid then matchedAny = true end
            
            -- Jika tidak ada satupun syarat aktif yang cocok, batalkan pengiriman
            if not matchedAny then return end
        end
    end

    local baseCps = EntityBaseCPS and EntityBaseCPS[name] or 0
    local mutBuff = (MutationBuffs and MutationBuffs[mutation]) or 1
    local totalCps = baseCps * mutBuff
    local rbxImg = getRbxAssetImage(name)
    local discordImg = getDiscordImageUrl(rbxImg) or ""

    local accName = "Hidden"
    pcall(function() accName = game:GetService("Players").LocalPlayer.Name end)
    local timeStr = os.date("%d/%m/%Y %I.%M %p")
    
    local desc = "• **Name**: " .. name .. "\n" ..
                 "• **Rarity**: " .. rarity .. "\n" ..
                 "• **Total CPS**: " .. formatNumber(totalCps) .. "/s\n" ..
                 "• **Mutation**: " .. mutation .. "\n" ..
                 "------------------------\n" ..
                 "• **Account Name**: ||" .. accName .. "||\n" ..
                 "• **Time**: " .. timeStr

    local data = {
        ["username"] = "Napoleon Premium",
        ["content"] = "@everyone",
        ["embeds"] = {{
            ["title"] = "[ " .. rarity .. " ] - " .. name,
            ["description"] = desc,
            ["type"] = "rich",
            ["color"] = WEBHOOK_COLORS[rarity] or 16777215,
            ["thumbnail"] = {["url"] = discordImg},
            ["footer"] = {["text"] = "Napoleon Premium • Personal"}
        }}
    }
    
    local body = HttpService:JSONEncode(data)
    task.spawn(function()
        local reqFunc = request or http_request or (syn and syn.request)
        if not reqFunc then return end
        pcall(function()
            reqFunc({
                Url = Config.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = body
            })
        end)
    end)
end

-- ============================================================
-- PENERIMA SINYAL GACHA SELESAI (KICK EVENT ENDED)
-- ============================================================
local NetworkFolder = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")
local EventEndedRemote = NetworkFolder:WaitForChild("rev_KickEventEnded")

EventEndedRemote.OnClientEvent:Connect(function(isSuccess)
    -- Jika isSuccess == true (berhasil collect) DAN ada data pending webhook
    
    if isSuccess == true and pendingWebhookData and Config.EnableWebhook then
        sendWebhook(pendingWebhookData.name, pendingWebhookData.mutation)
        pendingWebhookData = nil -- Kosongkan memori setelah dikirim
    elseif isSuccess == false then
        -- Jika server membatalkan/gagal, jangan kirim webhook
        pendingWebhookData = nil 
    end
end)

-- ============================================================
-- 7. Auto Equip Best
-- ============================================================
local function parseCPS(text)
    local clean = (text or ""):gsub("[%$,%s]", "")
    local num = tonumber(clean)
    if num then return num end
    local suffixes = { K=1e3, M=1e6, B=1e9, T=1e12 }
    local n, s = clean:match("^([%d%.]+)(%a+)$")
    if n and s then return (tonumber(n) or 0) * (suffixes[s:upper()] or 1) end
    return 0
end

local function startEquipBest()
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChild("Humanoid")
        local bp   = LocalPlayer:FindFirstChild("Backpack")
        if not char or not hum or not hrp or not bp then
            notif("Character not ready!", 4, "Equip Best"); return
        end

        notif("Searching for your plot...", 3, "Equip Best")
        local myPlot = nil
        pcall(function()
            local plotsFolder = workspace:WaitForChild("Plots", 5)
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local deco     = plot:FindFirstChild("Decorations")
                local ownerObj = deco and deco:FindFirstChild("PlotOwner")
                local ownerGUI = ownerObj and ownerObj:FindFirstChild("OwnerGUI")
                local label    = ownerGUI and ownerGUI:FindFirstChild("TextLabel")
                if label and label.Text == LocalPlayer.Name then
                    myPlot = plot; break
                end
            end
        end)
        
        -- Fallback: Gunakan atribut Owner (Dari update game terbaru)
        if not myPlot then
            pcall(function()
                local plotsFolder = workspace:FindFirstChild("Plots")
                if plotsFolder then
                    for _, plot in ipairs(plotsFolder:GetChildren()) do
                        if plot:GetAttribute("Owner") == LocalPlayer.Name then
                            myPlot = plot; break
                        end
                    end
                end
            end)
        end
        
        if not myPlot then
            notif("Plot not found! Make sure you own a plot.", 5, "Equip Best"); return
        end
        notif("Plot found: " .. myPlot.Name, 3, "Equip Best")

        local slotsFolder = myPlot:FindFirstChild("Slots")
        if not slotsFolder then
            notif("Slots folder not found!", 4, "Equip Best"); return
        end

        notif("Analyzing Plot & Backpack (" .. Config.EquipMode .. ")...", 3, "Equip Best")
        
        -- 1. Kumpulkan SEMUA item (dari plot & backpack)
        local allItems = {}
        
        -- Dari Plot
        local slotData = {}
        local orderedSlots = {}
        
        for _, slot in ipairs(slotsFolder:GetChildren()) do
            local att = slot:FindFirstChild("Attachment")
            local prompt = att and att:FindFirstChild("CustomPrompt")
            if not prompt then continue end
            
            table.insert(orderedSlots, slot)
            
            local placedPart = slot:FindFirstChild("PlacedPart")
            if placedPart then
                local id = placedPart:GetAttribute("ID") or "Unknown"
                local level = placedPart:GetAttribute("Level") or 1
                local mutation = placedPart:GetAttribute("Mutation") or "None"
                
                local rarity = BRAINROT_RARITY_MAP[id] or "Common"
                local rarityRank = RARITY_RANK[rarity] or 1
                local baseCPS = EntityBaseCPS[id] or 0
                local mutBuff = MutationBuffs[mutation] or 1
                local cpsVal = 0
                
                if Config.EquipMode == "CPS" then
                    cpsVal = baseCPS * mutBuff * (1.25 ^ (level - 1))
                elseif Config.EquipMode == "Base CPS" then
                    cpsVal = baseCPS * mutBuff
                end
                
                local sig = id .. "_" .. mutation .. "_" .. level
                
                table.insert(allItems, {
                    id = id, level = level, mutation = mutation,
                    cpsValue = cpsVal, rarityRank = rarityRank, sig = sig
                })
                
                slotData[slot.Name] = { hasItem = true, sig = sig, prompt = prompt }
            else
                slotData[slot.Name] = { hasItem = false, prompt = prompt }
            end
        end
        
        -- Urutkan slot berdasarkan nomor di namanya (misal Slot1, Slot2, dst)
        table.sort(orderedSlots, function(a, b)
            local numA = tonumber(a.Name:match("%d+")) or 0
            local numB = tonumber(b.Name:match("%d+")) or 0
            return numA < numB
        end)
        
        -- Dari Backpack
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local id = tool.Name
                local level = tool:GetAttribute("Level") or 1
                local mutation = tool:GetAttribute("Mutation") or "None"
                
                local rarity = BRAINROT_RARITY_MAP[id] or "Common"
                local rarityRank = RARITY_RANK[rarity] or 1
                local baseCPS = EntityBaseCPS[id] or 0
                local mutBuff = MutationBuffs[mutation] or 1
                local cpsVal = 0
                
                if Config.EquipMode == "CPS" then
                    cpsVal = baseCPS * mutBuff * (1.25 ^ (level - 1))
                elseif Config.EquipMode == "Base CPS" then
                    cpsVal = baseCPS * mutBuff
                end
                
                local sig = id .. "_" .. mutation .. "_" .. level
                
                table.insert(allItems, {
                    id = id, level = level, mutation = mutation,
                    cpsValue = cpsVal, rarityRank = rarityRank, sig = sig, instance = tool
                })
            end
        end
        
        -- 2. Urutkan SEMUA item dari yang TERKUAT ke TERLEMAH
        if Config.EquipMode == "Rarity" then
            table.sort(allItems, function(a, b)
                if a.rarityRank ~= b.rarityRank then return a.rarityRank > b.rarityRank end
                return a.cpsValue > b.cpsValue
            end)
        else
            table.sort(allItems, function(a, b) return a.cpsValue > b.cpsValue end)
        end
        
        -- 3. Tentukan IDEAL LAYOUT
        local idealLayout = {}
        local itemUsageCount = {}
        
        for i = 1, #orderedSlots do
            if i <= #allItems then
                local item = allItems[i]
                idealLayout[orderedSlots[i].Name] = item.sig
                itemUsageCount[item.sig] = (itemUsageCount[item.sig] or 0) + 1
            end
        end
        
        -- 4. Pass 1: Copot item yang salah tempat
        local actionCount = 0
        local currentUsageCount = {}
        
        for _, slot in ipairs(orderedSlots) do
            local sData = slotData[slot.Name]
            local idealSig = idealLayout[slot.Name]
            
            if sData.hasItem then
                if sData.sig ~= idealSig then
                    -- Copot karena salah tempat atau sudah tidak layak masuk plot
                    hrp.CFrame = slot.CFrame + Vector3.new(0, 4, 0)
                    task.wait(0.05)
                    fireproximityprompt(sData.prompt)
                    
                    local t = 0
                    while slot:FindFirstChild("PlacedPart") and t < 10 do task.wait(0.1); t = t + 1 end
                    task.wait(0.1)
                    
                    sData.hasItem = false
                    actionCount = actionCount + 1
                else
                    currentUsageCount[sData.sig] = (currentUsageCount[sData.sig] or 0) + 1
                    if currentUsageCount[sData.sig] > (itemUsageCount[sData.sig] or 0) then
                        -- Copot karena kelebihan duplikat di plot
                        hrp.CFrame = slot.CFrame + Vector3.new(0, 4, 0)
                        task.wait(0.05)
                        fireproximityprompt(sData.prompt)
                        
                        local t = 0
                        while slot:FindFirstChild("PlacedPart") and t < 10 do task.wait(0.1); t = t + 1 end
                        task.wait(0.1)
                        
                        sData.hasItem = false
                        actionCount = actionCount + 1
                    end
                end
            end
        end
        
        -- 5. Pass 2: Pasang item ke slot yang kosong sesuai urutan
        for _, slot in ipairs(orderedSlots) do
            local sData = slotData[slot.Name]
            local idealSig = idealLayout[slot.Name]
            
            if not sData.hasItem and idealSig then
                local targetTool = nil
                for _, tool in ipairs(bp:GetChildren()) do
                    if tool:IsA("Tool") then
                        local tSig = tool.Name .. "_" .. (tool:GetAttribute("Mutation") or "None") .. "_" .. (tool:GetAttribute("Level") or 1)
                        if tSig == idealSig then
                            targetTool = tool
                            break
                        end
                    end
                end
                
                if targetTool then
                    hrp.CFrame = slot.CFrame + Vector3.new(0, 4, 0)
                    task.wait(0.05)
                    hum:EquipTool(targetTool)
                    task.wait(0.15)
                    fireproximityprompt(sData.prompt)
                    task.wait(0.2)
                    hum:UnequipTools()
                    task.wait(0.05)
                    
                    sData.hasItem = true
                    actionCount = actionCount + 1
                end
            end
        end

        hum:UnequipTools()
        if actionCount > 0 then
            notif("✅ Done! Sorted with " .. actionCount .. " actions.", 5, "Equip Best")
        else
            notif("✅ Plot is already perfectly sorted!", 5, "Equip Best")
        end
    end)
end

-- ============================================================
-- Auto Upgrade Brainrot Level
-- ============================================================
local function startAutoUpgrade()
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then notif("Character not ready!", 4, "Upgrade Level"); return end

        local targetLevel = Config.TargetUpgradeLevel
        notif("Starting Auto Upgrade → Level " .. targetLevel, 4, "Upgrade Level")

        -- Cari plot milik player
        local myPlot = nil
        pcall(function()
            local plotsFolder = workspace:WaitForChild("Plots", 5)
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local deco     = plot:FindFirstChild("Decorations")
                local ownerGUI = deco and deco:FindFirstChild("PlotOwner") and deco.PlotOwner:FindFirstChild("OwnerGUI")
                local label    = ownerGUI and ownerGUI:FindFirstChild("TextLabel")
                if label and label.Text == LocalPlayer.Name then
                    myPlot = plot; break
                end
            end
        end)
        if not myPlot then notif("Plot not found!", 5, "Upgrade Level"); return end

        local surfaceGuis = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SurfaceGUIs")
        local upgraded = 0

        for _, slotUI in ipairs(surfaceGuis:GetChildren()) do
            local slotNumberStr = slotUI.Name:match("%d+")
            if slotNumberStr then
                local slotNumber = tonumber(slotNumberStr)
                local levelLabel = slotUI:FindFirstChild("Button") and slotUI.Button:FindFirstChild("LevelLabel")
                if levelLabel and levelLabel.Text ~= "" then
                    local curStr = levelLabel.Text:match("Lvl (%d+)") or levelLabel.Text:match("%d+")
                    local currentLevel = tonumber(curStr)
                    if currentLevel and currentLevel < targetLevel then
                        local physSlot = myPlot.Slots:FindFirstChild(slotUI.Name)
                        if physSlot then
                            -- Teleport ke atas slot
                            hrp.CFrame = physSlot.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.5)
                            local selisih = targetLevel - currentLevel
                            for i = 1, selisih do
                                pcall(function() UpgradeRemote:FireServer(slotNumber) end)
                                task.wait(0.1)
                            end
                            upgraded = upgraded + 1
                        end
                    end
                end
            end
        end
        notif("✅ Upgrade complete! " .. upgraded .. " slots → Lvl " .. targetLevel, 5, "Upgrade Level")
    end)
end

-- ============================================================
-- 6. Auto Click KickUpgrade
-- ============================================================
task.spawn(function()
    while true do
        task.wait(0.15)
        if not Config.AutoClickUpgrade then continue end
        pcall(function()
            local gui  = LocalPlayer.PlayerGui
            local ku   = gui:FindFirstChild("KickUpgrades")
            if not ku then return end

            -- Cek semua child, karena urutan popup bisa berubah-ubah (index [4] tidak selalu aman)
            for _, btn in ipairs(ku:GetChildren()) do
                -- Cari setiap button yang namanya "Bonus"
                if btn.Name == "Bonus" and btn:IsA("GuiButton") then

                    -- Pastikan tombolnya visible (mengabaikan tombol bonus asli bawaan game yang invisible)
                    if btn.Visible then

                        -- Game mungkin menggunakan UI Event yang berbeda (Activated / MouseButton1Down)
                        local eventsToFire = {"MouseButton1Click", "Activated", "MouseButton1Down"}

                        for _, eventName in ipairs(eventsToFire) do
                            -- Method 1: firesignal
                            local fired = false
                            pcall(function()
                                firesignal(btn[eventName])
                                fired = true
                            end)

                            -- Method 2: getconnections fallback
                            if not fired then
                                pcall(function()
                                    for _, conn in ipairs(getconnections(btn[eventName])) do
                                        pcall(function() conn.Function() end)
                                    end
                                end)
                            end
                        end

                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- Auto Sell Backpack
-- ============================================================
local autoSellLoopActive = false
local function startAutoSell()
    if autoSellLoopActive then return end
    autoSellLoopActive = true
    task.spawn(function()
        while Config.AutoSell do
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local bp   = LocalPlayer:FindFirstChild("Backpack")
            
            if hum and bp then
                for _, tool in ipairs(bp:GetChildren()) do
                    if not Config.AutoSell then break end
                    if tool:IsA("Tool") then
                        local toolName   = tool.Name
                        local toolMut    = tool:GetAttribute("Mutation") or "None"
                        local toolRarity = BRAINROT_RARITY_MAP[toolName] or "Common"

                        -- Cek apakah semua filter masih "None" (tidak ada target yang dipilih)
                        local nameIsNone   = (#Config.TargetSellBrainrots == 0) or (#Config.TargetSellBrainrots == 1 and Config.TargetSellBrainrots[1] == "None")
                        local rarityIsNone = (#Config.TargetSellRarities == 0) or (#Config.TargetSellRarities == 1 and Config.TargetSellRarities[1] == "None")

                        -- Jika KEDUA filter None → tidak jual apa-apa (harus pilih dulu)
                        if nameIsNone and rarityIsNone then continue end

                        -- 1. Cek filter nama brainrot
                        -- None = filter nama tidak aktif (lolos semua nama)
                        local nameMatch = nameIsNone
                        if not nameIsNone then
                            for _, n in ipairs(Config.TargetSellBrainrots) do
                                if n == toolName then nameMatch = true; break end
                            end
                        end

                        -- 2. Cek filter rarity
                        -- None = filter rarity tidak aktif (lolos semua rarity)
                        local rarityMatch = rarityIsNone
                        if not rarityIsNone then
                            for _, r in ipairs(Config.TargetSellRarities) do
                                if r == toolRarity then rarityMatch = true; break end
                            end
                        end

                        -- Item harus cocok dengan SEMUA filter yang aktif
                        if not (nameMatch and rarityMatch) then continue end

                        -- 3. Cek proteksi mutasi (ProtectSellMutations)
                        local isProtected = false
                        if #Config.ProtectSellMutations > 0
                            and not (#Config.ProtectSellMutations == 1 and Config.ProtectSellMutations[1] == "None")
                        then
                            for _, protMut in ipairs(Config.ProtectSellMutations) do
                                if protMut == toolMut then
                                    isProtected = true; break
                                end
                            end
                        end

                        -- Kalau mutasinya dilindungi, lewati
                        if isProtected then continue end

                        -- Eksekusi Jual (Equip -> Invoke Remote -> Wait)
                        pcall(function()
                            hum:EquipTool(tool)
                            task.wait(0.15)
                            SellRemote:InvokeServer()
                            task.wait(0.1)
                        end)
                    end
                end
            end
            task.wait(1)
        end
        autoSellLoopActive = false
    end)
end

-- ============================================================
-- Auto Trade
-- ============================================================
local autoTradeLoopActive = false
local function startAutoTrade()
    if autoTradeLoopActive then return end
    autoTradeLoopActive = true
    task.spawn(function()
        while Config.AutoTrade do
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local bp   = LocalPlayer:FindFirstChild("Backpack")
            
            if Config.TradeTargetPlayer ~= "None" and Config.TradeTargetPlayer ~= "" and hum and bp then
                local targetPlayer = game:GetService("Players"):FindFirstChild(Config.TradeTargetPlayer)
                if targetPlayer then
                    local targetUserId = targetPlayer.UserId
                    for _, tool in ipairs(bp:GetChildren()) do
                        if not Config.AutoTrade then break end
                        if tool:IsA("Tool") then
                            local toolName   = tool.Name
                            local toolMut    = tool:GetAttribute("Mutation") or "None"
                            local toolRarity = BRAINROT_RARITY_MAP[toolName] or "Common"

                            local nameIsNone   = (#Config.TargetTradeBrainrots == 0) or (#Config.TargetTradeBrainrots == 1 and Config.TargetTradeBrainrots[1] == "None")
                            local mutIsNone    = (#Config.TargetTradeMutations == 0) or (#Config.TargetTradeMutations == 1 and Config.TargetTradeMutations[1] == "None")
                            local rarityIsNone = (#Config.TargetTradeRarities == 0) or (#Config.TargetTradeRarities == 1 and Config.TargetTradeRarities[1] == "None")

                            if nameIsNone and mutIsNone and rarityIsNone then continue end

                            local nameMatch = nameIsNone
                            if not nameIsNone then
                                for _, n in ipairs(Config.TargetTradeBrainrots) do
                                    if n == toolName then nameMatch = true; break end
                                end
                            end

                            local mutMatch = mutIsNone
                            if not mutIsNone then
                                for _, m in ipairs(Config.TargetTradeMutations) do
                                    if m == toolMut then mutMatch = true; break end
                                end
                            end

                            local rarityMatch = rarityIsNone
                            if not rarityIsNone then
                                for _, r in ipairs(Config.TargetTradeRarities) do
                                    if r == toolRarity then rarityMatch = true; break end
                                end
                            end

                            if nameMatch and mutMatch and rarityMatch then
                                pcall(function()
                                    hum:EquipTool(tool)
                                    task.wait(0.15)
                                    local Event = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_GiftRequest
                                    Event:FireServer(targetUserId)
                                    task.wait(0.2)
                                end)
                            end
                        end
                    end
                end
            end
            task.wait(1)
        end
        autoTradeLoopActive = false
    end)
end

-- ============================================================
-- Auto Accept Trade
-- ============================================================
local autoAcceptTradeLoopActive = false
local function startAutoAcceptTrade()
    if autoAcceptTradeLoopActive then return end
    autoAcceptTradeLoopActive = true
    task.spawn(function()
        while Config.AutoAcceptTrade do
            pcall(function()
                local confirmFrame = LocalPlayer.PlayerGui:FindFirstChild("Frames") and LocalPlayer.PlayerGui.Frames:FindFirstChild("ConfirmFrame")
                if confirmFrame and confirmFrame.Visible then
                    local yesBtn = confirmFrame:FindFirstChild("Buttons") and confirmFrame.Buttons:FindFirstChild("Yes")
                    if yesBtn and yesBtn:IsA("GuiButton") then
                        local eventsToFire = {"MouseButton1Click", "Activated", "MouseButton1Down"}
                        for _, eventName in ipairs(eventsToFire) do
                            local fired = false
                            pcall(function()
                                firesignal(yesBtn[eventName])
                                fired = true
                            end)
                            if not fired then
                                pcall(function()
                                    for _, conn in ipairs(getconnections(yesBtn[eventName])) do
                                        pcall(function() conn.Function() end)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
        autoAcceptTradeLoopActive = false
    end)
end

-- ============================================================
-- WINDOW UI
-- ============================================================
local Window = Library:Window({
    Title = "Napoleon",
    Footer = "Kick A Lucky",
    Color = Color3.fromRGB(255, 255, 255),
    Color2 = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130,
    Image = "136289055140268",
    WindowIMG = "93732999692312",
    LogoHUB = "136289055140268"
})
local Tabs = Window

local function LoadInfoTab()
-- ─── TAB INFO ───
local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })

local InfoSection = InfoTab:AddSection("Napoleon — Kick Brainrot",true)
InfoSection:AddParagraph({ 
    Title = "📋 Script Info", 
    Content = "Auto Farm: Auto kick + fly to CollectZone.\nAuto Snap: Auto cancel gacha by mutation / name / rarity.\nAuto Collect: Auto grab cash from plot.\nAuto Equip Best: Auto equip best brainrot to plot.\nAuto Upgrade Level: Upgrade brainrot to target level." 
})

InfoSection:AddButton({
    Title = "Join Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/RKaZ9vEbpb")
            notif("Discord link copied to clipboard!", 3, "Napoleon")
        else
            notif("Your executor does not support copy. Join manually: discord.gg/RKaZ9vEbpb", 5, "Napoleon")
        end
    end
})
end

-- ============================================================
-- UTILITY: Multi-dropdown handler
-- ============================================================
local function handleMultiDropdown(val, targetConfigKey, dropObj)
    if type(val) ~= "table" then val = {val} end
    
    local oldVal = Config[targetConfigKey] or {"None"}
    local hasNoneNow = false
    for _, v in ipairs(val) do
        if v == "None" then hasNoneNow = true; break end
    end
    
    local hadNoneBefore = false
    for _, v in ipairs(oldVal) do
        if v == "None" then hadNoneBefore = true; break end
    end
    
    local finalVal = {}
    if #val == 0 then
        finalVal = {"None"}
    elseif hasNoneNow and #val > 1 then
        if hadNoneBefore then
            for _, v in ipairs(val) do
                if v ~= "None" then table.insert(finalVal, v) end
            end
        else
            finalVal = {"None"}
        end
    else
        finalVal = val
    end
    
    Config[targetConfigKey] = finalVal
    
    if dropObj then
        local isDiff = (#val ~= #finalVal)
        if not isDiff then
            local lookup = {}
            for _, v in ipairs(val) do lookup[v] = true end
            for _, v in ipairs(finalVal) do
                if not lookup[v] then isDiff = true; break end
            end
        end
        if isDiff then
            task.spawn(function()
                dropObj:Set(finalVal)
            end)
        end
    end
end

local function LoadMainTab()
-- ─── TAB MAIN ───
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })

local KickSection = MainTab:AddSection("Auto Farm")
KickSection:AddToggle({
    Title = "Auto Farm",
    Title2 = "Enable",
    Content = "Auto kick + tahan saat dapat gacha",
    Default = false,
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            startFarm()
            notif("Auto Farm Toggled ON", 4, "Farm")
        else
            notif("Auto Farm Toggled OFF", 4, "Farm")
        end
    end
})

KickSection:AddDropdown({
    Title = "Reroll Mode",
    Content = "Select farming mode",
    Options = {"Normal Reroll", "Rejoin Reroll"},
    Default = "Normal Reroll",
    Multi = false,
    Callback = function(val)
        local isFast = (val == "Rejoin Reroll")
        Config.isRejoin = isFast
        notif("Auto Farm Mode: " .. val, 3, "Farm")
    end
})

KickSection:AddButton({
    Title = "Fix Stuck",
    Content = "Teleport away to cancel current gacha safely",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then notif("Character not ready!", 3, "Cancel"); return end
        removeBodyVelocity(hrp)
        hrp.CFrame = CFrame.new(698.249695, 3.150006, 232.345169)
        notif("Teleported to Safe Zone!", 3, "Cancel")
    end
})

local SnapSection = MainTab:AddSection("Auto Snap")
SnapSection:AddToggle({
    Title = "Enable Auto Snap",
    Title2 = "Enable",
    Content = "Cancel gacha that does not match filters",
    Default = false,
    Callback = function(val)
        Config.EnableSnap = val
        notif(val and "Auto Snap enabled!" or "Auto Snap disabled.", 3, "Snap")
    end
})

SnapSection:AddDropdown({
    Title = "Snap Mode",
    Content = "Spesifik: Harus cocok semua. Not Spesifik: Cocok salah satu saja.",
    Options = {"Spesifik", "Not Spesifik"},
    Default = "Spesifik",
    Multi = false,
    Callback = function(val)
        Config.SnapMode = val
    end
})

local MutDrop
MutDrop = SnapSection:AddDropdown({
    Title = "Target Mutation",
    Content = "Multi-select mutation. 'None' = Any, 'Non Mutasi' = No Mutation",
    Options = MUTATION_LIST,
    Default = Config.TargetMutations,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetMutations", MutDrop)
    end
})

local BrainDrop
BrainDrop = SnapSection:AddDropdown({
    Title = "Target Brainrot",
    Content = "Multi-select name. 'None' = Any",
    Options = BRAINROT_LIST,
    Default = Config.TargetBrainrots,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetBrainrots", BrainDrop)
    end
})

local RarityDrop
RarityDrop = SnapSection:AddDropdown({
    Title = "Target Rarity",
    Content = "Multi-select rarity. 'None' = Any",
    Options = {"None", table.unpack(RARITY_LIST)},
    Default = Config.TargetRarities,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetRarities", RarityDrop)
    end
})
end

local function LoadAutoTab()
-- ─── TAB AUTOMATICALLY ───
local AutoTab = Tabs:AddTab({ Name = "Automatically", Icon = "next" })

local SellSection = AutoTab:AddSection("Auto Sell Backpack")
SellSection:AddToggle({
    Title = "Enable Auto Sell",
    Title2 = "Enable",
    Content = "Auto sell backpack items matching filters below",
    Default = false,
    Callback = function(val)
        Config.AutoSell = val
        if val then
            startAutoSell()
            notif("Auto Sell enabled!", 3, "Auto Sell")
        else
            notif("Auto Sell disabled.", 3, "Auto Sell")
        end
    end
})

local _sellBrainRef = {}
_sellBrainRef.drop = SellSection:AddDropdown({
    Title = "Target Sell Brainrots",
    Content = "Pilih nama brainrot yang DIJUAL. 'None' = tidak jual (harus pilih spesifik)",
    Options = BRAINROT_LIST,
    Default = Config.TargetSellBrainrots,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetSellBrainrots", _sellBrainRef.drop)
    end
})

local _sellRarityRef = {}
_sellRarityRef.drop = SellSection:AddDropdown({
    Title = "Target Sell Rarities",
    Content = "Pilih rarity yang DIJUAL. 'None' = tidak jual (harus pilih spesifik)",
    Options = {"None", table.unpack(RARITY_LIST)},
    Default = Config.TargetSellRarities,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetSellRarities", _sellRarityRef.drop)
    end
})

local _sellProtectRef = {}
_sellProtectRef.drop = SellSection:AddDropdown({
    Title = "Protect Mutations",
    Content = "Pilih mutasi yang DILINDUNGI (tidak dijual). 'None' = tidak ada yang dilindungi",
    Options = MUTATION_LIST,
    Default = Config.ProtectSellMutations,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "ProtectSellMutations", _sellProtectRef.drop)
    end
})

local TradeSection = AutoTab:AddSection("Auto Trade")

local function getPlayersList()
    local list = {"None"}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    return list
end

local _tradePlayerRef = {}
_tradePlayerRef.drop = TradeSection:AddDropdown({
    Title = "Target Player",
    Content = "Pilih player yang ingin di-trade",
    Options = getPlayersList(),
    Default = "None",
    Multi = false,
    Callback = function(val)
        Config.TradeTargetPlayer = val
    end
})

TradeSection:AddButton({
    Title = "Refresh Player List",
    Content = "Perbarui daftar player (pastikan dropdown terbuka lagi)",
    Callback = function()
        if _tradePlayerRef.drop then
            if _tradePlayerRef.drop.Refresh then
                _tradePlayerRef.drop:Refresh(getPlayersList(), true)
            elseif _tradePlayerRef.drop.SetOptions then
                _tradePlayerRef.drop:SetOptions(getPlayersList())
            end
        end
        notif("Daftar player diperbarui!", 2, "Auto Trade")
    end
})

local _tradeBrainRef = {}
_tradeBrainRef.drop = TradeSection:AddDropdown({
    Title = "Target Trade Brainrots",
    Content = "Pilih nama brainrot yang di-trade. 'None' = tidak trade (harus pilih spesifik)",
    Options = BRAINROT_LIST,
    Default = Config.TargetTradeBrainrots,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetTradeBrainrots", _tradeBrainRef.drop)
    end
})

local _tradeMutRef = {}
_tradeMutRef.drop = TradeSection:AddDropdown({
    Title = "Target Trade Mutations",
    Content = "Pilih mutasi yang di-trade. 'None' = tidak trade (harus pilih spesifik)",
    Options = MUTATION_LIST,
    Default = Config.TargetTradeMutations,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetTradeMutations", _tradeMutRef.drop)
    end
})

local _tradeRarityRef = {}
_tradeRarityRef.drop = TradeSection:AddDropdown({
    Title = "Target Trade Rarities",
    Content = "Pilih rarity yang di-trade. 'None' = tidak trade (harus pilih spesifik)",
    Options = {"None", table.unpack(RARITY_LIST)},
    Default = Config.TargetTradeRarities,
    Multi = true,
    Callback = function(val)
        handleMultiDropdown(val, "TargetTradeRarities", _tradeRarityRef.drop)
    end
})

TradeSection:AddToggle({
    Title = "Enable Auto Trade",
    Title2 = "Enable",
    Content = "Auto equip brainrot sesuai filter & kirim trade",
    Default = false,
    Callback = function(val)
        Config.AutoTrade = val
        if val then
            startAutoTrade()
            notif("Auto Trade enabled!", 3, "Auto Trade")
        else
            notif("Auto Trade disabled.", 3, "Auto Trade")
        end
    end
})

TradeSection:AddToggle({
    Title = "Enable Auto Accept Trade",
    Title2 = "Enable",
    Content = "Otomatis menerima gift yang masuk & hide frame",
    Default = false,
    Callback = function(val)
        Config.AutoAcceptTrade = val
        if val then
            startAutoAcceptTrade()
            notif("Auto Accept Trade enabled!", 3, "Auto Trade")
        else
            notif("Auto Accept Trade disabled.", 3, "Auto Trade")
        end
    end
})

local CashSection = AutoTab:AddSection("Auto Collect Cash")
CashSection:AddToggle({
    Title = "Auto Collect Cash",
    Title2 = "Enable",
    Content = "Teleport to each slot & collect cash automatically",
    Default = false,
    Callback = function(val)
        Config.AutoCollectCash = val
        if val then
            startCollectCash()
            notif("Auto Collect Cash enabled! " .. getMaxSlot() .. " slots.", 4, "Cash")
        else
            notif("Auto Collect Cash disabled.", 3, "Cash")
        end
    end
})

local EquipSection = AutoTab:AddSection("Auto Equip Best")
EquipSection:AddDropdown({
    Title = "Equip Mode",
    Content = "CPS = UI CPS. Base CPS = Base * Mutation. Rarity = Rarest.",
    Options = {"CPS", "Base CPS", "Rarity"},
    Default = "CPS",
    Callback = function(val)
        Config.EquipMode = val
        notif("Equip Mode: " .. val, 2, "Equip Best")
    end
})

EquipSection:AddButton({
    Title = "▶  Run Auto Equip Best",
    Content = "Clear plot → scan backpack → equip best brainrots in order",
    Callback = function()
        notif("Starting Auto Equip Best...", 3, "Equip Best")
        startEquipBest()
    end
})

local UpgradeLvlSection = AutoTab:AddSection("Auto Upgrade Level")
UpgradeLvlSection:AddInput({
    Title = "Target Level",
    Content = "Target level for plot brainrots",
    Default = tostring(Config.TargetUpgradeLevel),
    Callback = function(val)
        local num = tonumber(val)
        if num and num > 0 then
            Config.TargetUpgradeLevel = math.floor(num)
            notif("Target Level: " .. Config.TargetUpgradeLevel, 2, "Upgrade Level")
        end
    end
})

UpgradeLvlSection:AddButton({
    Title = "▶  Run Auto Upgrade Level",
    Content = "Teleport to plot slots and upgrade to Target Level",
    Callback = function()
        notif("Starting upgrade to Level " .. Config.TargetUpgradeLevel .. "...", 3, "Upgrade Level")
        startAutoUpgrade()
    end
})
end

local function LoadMiscTab()
-- ─── TAB MISCELLANEOUS ───
local MiscTab = Tabs:AddTab({ Name = "Miscellaneous", Icon = "rod" })

local ClickSection = MiscTab:AddSection("Auto Click")
ClickSection:AddToggle({
    Title = "Auto Click x2",
    Title2 = "Enable",
    Content = "Auto click the x2 upgrade popup",
    Default = true,
    Callback = function(val)
        Config.AutoClickUpgrade = val
        notif(val and "Auto Click x2 enabled!" or "Auto Click x2 disabled.", 3, "Click")
    end
})

local ModuleSection = MiscTab:AddSection("Kick Module")
ModuleSection:AddButton({
    Title = "Retry Find Kick Module",
    Content = "Retry searching for kick module via getloadedmodules()",
    Callback = function()
        findKickModule()
        notif(kickModule and "Module found!" or "Module not found.", 3, "Module")
    end
})

local SystemSection = MiscTab:AddSection("System")
SystemSection:AddToggle({
    Title = "Anti-AFK",
    Title2 = "Enable",
    Content = "Prevent kick due to inactivity",
    Default = true,
    Callback = function(val)
        notif(val and "Anti-AFK ON" or "Anti-AFK OFF", 3, "System")
    end
})
end

local function LoadWebhookTab()
-- ─── TAB WEBHOOK ───
local WebhookTab = Tabs:AddTab({ Name = "Webhook", Icon = "message" })
local WebhookSection = WebhookTab:AddSection("Discord Webhook Settings")

WebhookSection:AddToggle({
    Title = "Enable Webhook",
    Title2 = "Enable",
    Content = "Send a webhook log when target brainrot is farmed",
    Default = Config.EnableWebhook,
    Callback = function(val)
        Config.EnableWebhook = val
        notif("Webhook " .. (val and "ON" or "OFF"), 3, "Webhook")
    end
})

WebhookSection:AddInput({
    Title = "Webhook URL",
    Content = "Enter your Discord webhook URL",
    Default = Config.WebhookURL,
    Callback = function(val)
        Config.WebhookURL = val
        notif("Webhook URL saved!", 3, "Webhook")
    end
})

local WEBHOOK_MUTATION_OPTS = {"None", "Golden", "Diamond", "Plasma", "Radioactive", "Molten", "Void", "Shadow", "Electrified", "Rainbow", "Virus"}
local WEBHOOK_RARITY_OPTS = {"None", "Common", "Rare", "Epic", "Legendary", "Mythic", "Godly", "Secret", "Divine", "Hacked", "OG", "Celestial", "Exclusive"}

WebhookSection:AddDropdown({
    Title = "Target Rarities",
    Content = "Select rarities to trigger webhook",
    Options = WEBHOOK_RARITY_OPTS,
    Default = Config.WebhookRarities,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.WebhookRarities = val
        else
            Config.WebhookRarities = {val}
        end
    end
})

WebhookSection:AddDropdown({
    Title = "Target Mutations",
    Content = "Select mutations to trigger webhook",
    Options = WEBHOOK_MUTATION_OPTS,
    Default = Config.WebhookMutations,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.WebhookMutations = val
        else
            Config.WebhookMutations = {val}
        end
    end
})


WebhookSection:AddButton({
    Title = "Test Webhook",
    Content = "Send a test message to Discord",
    Callback = function()
        if Config.WebhookURL == "" then
            notif("Please enter a Webhook URL first!", 3, "Webhook")
            return
        end
        notif("Sending test webhook...", 3, "Webhook")
        if sendWebhook then
            sendWebhook("Noobini Pizzanini", "Rainbow", true)
        end
    end
})
end

LoadInfoTab()
task.wait(0.05)
LoadMainTab()
task.wait(0.05)
LoadAutoTab()
task.wait(0.05)
LoadMiscTab()
task.wait(0.05)
LoadWebhookTab()

-- ============================================================
-- RESPAWN HANDLER
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    if Config.AutoFarm then
        task.wait(1)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then ensureBodyVelocity(hrp) end
    end
end)

-- ============================================================
-- THE GHOSTING NEUTRALIZER (ANTI-LEAK & ANTI-ERROR BACAAN GAME)
-- ============================================================
-- local function ghostItem(item)
--     task.defer(function()
--     end)
-- end

-- ============================================================
-- TERAPKAN GHOSTING KE COMMON & DEBRIS
-- ============================================================
-- task.spawn(function()
--     local Players = game:GetService("Players")
--     local LocalPlayer = Players.LocalPlayer
    
--     -- 1. Pantau folder Common
--     local playersFolder = workspace:WaitForChild("Players", 10)
--     if playersFolder then
--         local myFolder = playersFolder:WaitForChild(LocalPlayer.Name, 10)
--         if myFolder then
--             myFolder.ChildAdded:Connect(function(item)
--                 if Config.AutoFarm and item.Name == "Common" then
--                     ghostItem(item) 
--                 end
--             end)
--         end
--     end
    
--     -- 2. Pantau folder Debris
--     local debrisFolder = workspace:WaitForChild("Debris", 10)
--     if debrisFolder then
--         debrisFolder.ChildAdded:Connect(function(item)
--             if not Config.AutoFarm then return end
            
--             task.defer(function()
--                 if not item or not item.Parent then return end
                
--                 if item:IsA("BasePart") then
--                     pcall(function() item:Destroy() end)
--                     return
--                 end
                
--                 local name = item.Name
--                 if name == "SlotUpgradeSign" or name == "PlotHitbox" then return end
--                 if BRAINROT_RARITY_MAP[name] then return end
                
--                 ghostItem(item)
--             end)
--         end)
--     end
    
--     -- 3. AGGRESSIVE CLEANER LOOP (GUI Effects & Workspace Spam)
--     task.spawn(function()
--         while task.wait(1) do
--             if Config.AutoFarm then
--                 pcall(function()
--                     local guiFx = LocalPlayer.PlayerGui:FindFirstChild("GUI_Effects")
--                     if guiFx and guiFx.Enabled then
--                         guiFx.Enabled = false
--                     end
--                 end)
                
--                 pcall(function()
--                     for _, item in ipairs(workspace:GetChildren()) do
--                         if item:IsA("BasePart") and item.Name ~= "Terrain" then
--                             item:Destroy()
--                         elseif item:IsA("Model") and BRAINROT_RARITY_MAP[item.Name] then
--                             item:Destroy()
--                         end
--                     end
--                 end)
--             end
--         end
--     end)
-- end)

task.wait(1)
_G.ScriptFullyLoaded = true
notif("Script successfully loaded! Open the Farm tab.", 5, "Napoleon")

-- ============================================================
-- ANTI-LAG: UNIVERSAL REMOTE BLOCKER (PLAYER LAIN)
-- ============================================================
-- task.spawn(function()
--     task.wait(3) 

--     local NetworkFolder = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")

--     local function blockOtherPlayersRemote(remoteName)
--         local remoteEvent = NetworkFolder:FindFirstChild(remoteName)
--         if not remoteEvent then return end

--         local originalConnections = {}

--         for _, conn in ipairs(getconnections(remoteEvent.OnClientEvent)) do
--             table.insert(originalConnections, conn.Function)
--             conn:Disable() 
--         end

--         remoteEvent.OnClientEvent:Connect(function(playerOrChar, ...)
--             local isMine = false
            
--             if typeof(playerOrChar) == "Instance" and playerOrChar.Name == LocalPlayer.Name then
--                 isMine = true
--             elseif type(playerOrChar) == "string" and playerOrChar == LocalPlayer.Name then
--                 isMine = true
--             end
            
--             if isMine then
--                 for _, func in ipairs(originalConnections) do
--                     task.spawn(func, playerOrChar, ...)
--                 end
--             end
--         end)
--     end

--     blockOtherPlayersRemote("rev_Transformed")
--     blockOtherPlayersRemote("rev_Reverted")
-- end)
