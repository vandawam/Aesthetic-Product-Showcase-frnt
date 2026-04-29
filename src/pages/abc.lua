-- ============================================================
-- Napoleon UI Library
-- ============================================================
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

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    AutoFarm           = false,
    FlySpeed           = 120,
    AutoClickUpgrade   = true,   -- default ON, di Misc
    AutoCollectCash    = false,
    AutoUpgradeLevel   = false,
    TargetUpgradeLevel = 50,

    EnableSnap         = false,
    SnapType           = "Mutation",
    -- Multi-select: tabel berisi pilihan yang aktif
    TargetMutations    = {"None"},  -- {"Plasma", "Diamond"} atau {"None"}
    TargetBrainrots    = {"None"},  -- {"None"} = semua nama boleh
    TargetRarities     = {"None"},  -- {"None"} = semua rarity boleh

    EquipMode          = "CPS",

    -- Auto Sell
    AutoSell             = false,
    TargetSellBrainrots  = {"None"},
    ProtectSellMutations = {"None"},
}

-- List mutasi dari game data (MutationData.ValidMutations + None)
local MUTATION_LIST = {
    "None",        -- Tidak ada mutasi (brainrot normal)
    "Golden",
    "Diamond",
    "Plasma",
    "Radioactive",
    "Molten",
    "Void",
    "Shadow",
    "Electrified",
    "Rainbow",
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
    ["Dragon Cannelloni"]="Exclusive", ["W"]="Exclusive",
    ["Spaghetti Tualetti"]="Exclusive", ["Esok Sekolah"]="Exclusive",
}

local BRAINROT_LIST = {
    "None",  -- Semua brainrot (tidak filter nama)
    "1x1x1x1", "67", "Agarrini La Palini", "Alessio", "Anpali Babel", "Ballerina Cappuccina",
    "Bambini Crostini", "Bananita Dolphinita", "Bangello", "Beluga Beluga", "Blackhole Goat",
    "Bobrito Bandito", "Bombardiro Crocodilo", "Bombini Gusini", "Boneca Ambalabu", "Brr Brr Patapim",
    "Burbaloni Luliloli", "Cacto Hipopotamo", "Cactus Pingu", "Capi Taco", "Cappuccino Assassino",
    "Cappuccino Clownino", "Capybara Eggplant", "Cavallo Virtuso", "Chef Crabracadabra",
    "Chicleteira Bicicleteira", "Chillin Chilli", "Chimpanzini Bananini", "Cocofanto Elefanto",
    "Compactoroni Diskaloni", "Corn Sahur", "Crazylone Pizaione", "Dipperi Chiperini",
    "Dragonfrutina Dolphinita", "Elefanto Frigo", "Elefantucci Bananucci", "Espresso Signora",
    "Frigo Camelo", "Fruli Frula", "Fryuro", "Gangster Footera", "Garamararam", "Gattatino Nyanino",
    "Girafa Celeste", "Glorbo Fruttodrillo", "Gorillo Watermelondrillo", "Guerriro Digitale",
    "Guest666", "John Pork", "Karkerkar Kurkur", "Ketupat Kepat", "Krupuk Pagi Pagi",
    "La Vacca Saturno Saturnita", "Lirili Larila", "Los Primos Blue", "Madung", "Mangolini Parrocini",
    "Mastodontico Telepiedone", "Matteo", "Meowl", "Noobini Pizzanini", "Nuclearo Dinossauro",
    "Octopusini Bluberini", "Orangutini Ananasini", "Orcalero", "Pandaccini Bananini", "Pannaburro",
    "Peant Jarro", "Penguino Cocosino", "Pesto Mortioni", "Pipi Kiwi", "Plan Blue", "Plan Red",
    "Pot Hotspot", "Rexosaurus", "Rhino Toasterino", "Rinooccio Verdini", "SWAG SODA",
    "Salamino Pinguino", "Sigma Boy", "Stoppo Luminino", "Strawberelli Flamingelli",
    "Strawberry Elephant", "Svinina Bombardino", "Ta Ta Ta Ta Sahur", "Talpa Di Fero", "Tictac Sahur",
    "Tim Cheese", "Torrtuginni Dragonfrutini", "Tralaledon", "Tralalero Tralala", "Tralalerita Tralala",
    "Tripi Tropi Tropa Tripa", "Trippi Troppi", "Trulimero Trulicina", "Tuff Toucan",
    "Udin Din Din Dun", "Waterdino", "Zibra Zubra Zibralini"
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
-- 1. Anti-AFK
-- ============================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================================================
-- 2. Instant Ball Travel (bypass animasi bola)
-- ============================================================
pcall(function()
    local KickServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.KickServiceClient)
    if type(KickServiceClient.Multipliers) ~= "table" then
        KickServiceClient.Multipliers = {}
    end
    KickServiceClient.Multipliers.Speed = 999999
end)

-- ============================================================
-- 3a. Baca Mutation & Nama langsung dari Attribute brainrot model
-- (game menyimpan via v7:SetAttribute("Mutation", p4.Mutation)
--  dan v7.Name = nama brainrot → langsung tersedia tanpa event)
-- Fallback: listener rev_Transformed jika attribute tidak ada
-- ============================================================
local lastTransformedData = { Name = "", Mutation = "None" }

pcall(function()
    local TransformedEvent = ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Packages")
        :WaitForChild("Network")
        :WaitForChild("rev_Transformed")

    TransformedEvent.OnClientEvent:Connect(function(player, data)
        if player == LocalPlayer and type(data) == "table" then
            lastTransformedData.Name     = data.Name or ""
            lastTransformedData.Mutation = data.Mutation or "None"
        end
    end)
end)

-- getloadedmodules() lebih akurat dari getgc
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
                end
            end)
        end
    end)
end

findKickModule()

-- Disable animasi karakter saat menendang (PlayAnim → no-op)
task.spawn(function()
    task.wait(2)
    pcall(function()
        for _, mod in ipairs(getloadedmodules()) do
            pcall(function()
                local req = require(mod)
                if type(req) == "table"
                    and type(req.PlayAnim) == "function"
                    and type(req.StopAnim) == "function"
                    and type(req.LoadedAnimations) == "table"
                then
                    req.PlayAnim = function() end   -- no-op: animasi kick tidak diputar
                end
            end)
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if Config.AutoFarm and kickModule then
        kickModule.Scale = 1
    end
end)

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
-- Hanya override SpawnWave via getloadedmodules setelah 3 detik
-- Tidak ada ChildAdded, tidak ada Heartbeat tambahan, tidak ada loop berat
task.spawn(function()
    task.wait(3)
    pcall(function()
        for _, mod in ipairs(getloadedmodules()) do
            pcall(function()
                local req = require(mod)
                if type(req) == "table" and type(req.SpawnWave) == "function" then
                    req.SpawnWave = function()
                        -- Restore camera langsung agar tidak stuck di Scriptable
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
-- 4. MAIN HEARTBEAT — Auto Farm Loop
--
-- Saat AutoFarm aktif:
--   a) Pasang BodyVelocity ke HRP (MaxForce=math.huge, Vel=0)
--      → mencegah physics mendorong karakter
--   b) Jika brainrot weld terdeteksi → terbang ke CollectZone
--      (brainrot ikut karena di-Weld ke HRP)
-- ============================================================
local isFlyingToCollect = false
local isCollecting    = false  -- true saat sedang loop collect cash (pause AutoFarm)

RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")

    if not Config.AutoFarm then
        -- Bersihkan BodyVelocity saat farm mati
        removeBodyVelocity(hrp)
        isFlyingToCollect = false
        return
    end

    if not char or not hrp then return end

    -- Jangan gerakin karakter saat AutoCollectCash sedang teleport per-slot
    if isCollecting then return end

    -- Cek apakah jadi brainrot
    local brainrot = getMyBrainrot()
    if not brainrot then
        -- Tidak sedang jadi brainrot → tidak perlu BV
        removeBodyVelocity(hrp)
        isFlyingToCollect = false
        _G.brainrotSpawnTime = 0
        -- JANGAN reset lastTransformedData di sini!
        -- Event rev_Transformed bisa fire SEBELUM weld muncul di client,
        -- sehingga reset di sini akan menghapus data event yang valid.
        return
    end

    if not _G.brainrotSpawnTime or _G.brainrotSpawnTime == 0 then
        _G.brainrotSpawnTime = tick()
        -- Reset data di AWAL sesi baru (bukan saat brainrot hilang)
        -- Ini memastikan data dari transform sebelumnya tidak bocor
        lastTransformedData.Name     = ""
        lastTransformedData.Mutation = "None"
    end

    -- [ AUTO SNAP SYSTEM ]
    if Config.EnableSnap then
        local targetMatch = false

        if Config.SnapType == "Mutation" then
            -- Baca LANGSUNG dari Attribute model brainrot
            local gotMutation = brainrot:GetAttribute("Mutation") or lastTransformedData.Mutation or "None"
            local gotName     = brainrot.Name

            -- Multi-select: cek apakah gotMutation ada di list pilihan
            local mutationMatch = false
            for _, m in ipairs(Config.TargetMutations) do
                if m == gotMutation then mutationMatch = true; break end
            end

            -- Multi-select: "None" di list = wildcard semua nama
            local nameMatch = false
            for _, n in ipairs(Config.TargetBrainrots) do
                if n == "None" or n == gotName then nameMatch = true; break end
            end

            if mutationMatch and nameMatch then
                targetMatch = true
            end

        elseif Config.SnapType == "Brainrot" then
            local gotName = brainrot.Name
            for _, n in ipairs(Config.TargetBrainrots) do
                if n == "None" or n == gotName then targetMatch = true; break end
            end

        elseif Config.SnapType == "Rarity" then
            local gotRarity = BRAINROT_RARITY_MAP[brainrot.Name] or "Common"
            for _, r in ipairs(Config.TargetRarities) do
                if r == "None" or r == gotRarity then targetMatch = true; break end
            end
        end

        if not targetMatch then
            removeBodyVelocity(hrp)
            -- Batalkan collect gacha (teleport menjauh)
            hrp.CFrame = CFrame.new(698.249695, 3.150006, 232.345169)
            isFlyingToCollect = false
            return
        end
    end

    -- Terbang ke CollectZone
    local target  = CollectZone.Position
    local current = hrp.Position
    local dist    = (target - current).Magnitude

    if dist < 40 then
        -- Sudah sampai di CollectZone → hapus BV, berhenti
        removeBodyVelocity(hrp)
        if isFlyingToCollect then
            isFlyingToCollect = false
            notif("Sampai di CollectZone!", 3, "Auto Farm")
        end
        return
    end

    -- Baru pasang BV saat mulai terbang ke collect
    ensureBodyVelocity(hrp)

    isFlyingToCollect = true
    local flyTarget  = Vector3.new(target.X, target.Y + 3, target.Z)
    local direction  = (flyTarget - current).Unit
    local step       = math.min(Config.FlySpeed * dt, dist)

    hrp.CFrame = CFrame.new(current + direction * step)
               * (hrp.CFrame - hrp.CFrame.Position)
end)

-- ============================================================
-- 5. Auto Kick Loop (delay 1 detik)
-- ============================================================
local function startFarm()
    task.spawn(function()
        while Config.AutoFarm do
            pcall(function()
                KickEvent:FireServer(1)
            end)
            task.wait(1) -- delay 1 detik
        end
    end)
end

-- ============================================================
-- UTILITY: Cari plot milik LocalPlayer
-- Cek Attribute "Owner" dulu (paling cepat), fallback ke TextLabel
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
            if label and label.Text == LocalPlayer.Name then
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
-- Cari plot milik player sendiri → iterasi Buttons → FireServer
-- ============================================================
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
-- RARITY RANK untuk Auto Equip Best (makin tinggi = makin prioritas)
-- ============================================================
local RARITY_RANK = {
    ["Common"]=1,  ["Rare"]=2,   ["Epic"]=3,    ["Legendary"]=4,
    ["Mythic"]=5,  ["Godly"]=6,  ["Secret"]=7,  ["Divine"]=8,
    ["Hacked"]=9,  ["OG"]=10,   ["Celestial"]=11, ["Exclusive"]=12,
}

-- ============================================================
-- DATABASE BASE CPS & MUTATION BUFFS (dari totalmodule.lua)
-- Digunakan oleh startEquipBest() mode "CPS" agar tidak perlu
-- baca UI label — kalkulasi langsung dari database.
-- ============================================================
local EntityBaseCPS = {
    ["Noobini Pizzanini"]=2, ["Lirili Larila"]=3, ["Tim Cheese"]=3, ["Talpa Di Fero"]=4, ["Svinina Bombardino"]=5,
    ["Pipi Kiwi"]=6, ["Fruli Frula"]=7, ["Trippi Troppi"]=7, ["Gangster Footera"]=15, ["Bobrito Bandito"]=17,
    ["Boneca Ambalabu"]=17, ["Ta Ta Ta Ta Sahur"]=18, ["Ballerina Cappuccina"]=19, ["Cappuccino Assassino"]=22,
    ["Brr Brr Patapim"]=22, ["Cacto Hipopotamo"]=26, ["Garamararam"]=40, ["Madung"]=44, ["Waterdino"]=50,
    ["Pesto Mortioni"]=52, ["Pannaburro"]=62, ["Orcalero"]=64, ["Mangolini Parrocini"]=64, ["John Pork"]=72,
    ["Gattatino Nyanino"]=76, ["Chimpanzini Bananini"]=100, ["Plan Red"]=130, ["Plan Blue"]=140, ["Capi Taco"]=150,
    ["Trulimero Trulicina"]=160, ["Bambini Crostini"]=160, ["Elefantucci Bananucci"]=170, ["Bananita Dolphinita"]=210,
    ["Salamino Pinguino"]=230, ["Penguino Cocosino"]=450, ["67"]=500, ["Burbaloni Luliloli"]=550,
    ["Chef Crabracadabra"]=600, ["Capybara Eggplant"]=650, ["Bangello"]=725, ["Elefanto Frigo"]=775,
    ["Rinooccio Verdini"]=880, ["Glorbo Fruttodrillo"]=920, ["Udin Din Din Dun"]=1850, ["Pandaccini Bananini"]=2000,
    ["Octopusini Bluberini"]=2150, ["Strawberelli Flamingelli"]=2300, ["Sigma Boy"]=2450, ["Frigo Camelo"]=2600,
    ["Orangutini Ananasini"]=2700, ["Rhino Toasterino"]=2950, ["Bombardiro Crocodilo"]=3100, ["Bombini Gusini"]=4750,
    ["Tuff Toucan"]=5300, ["Fryuro"]=5850, ["Burguro"]=6250, ["Guest666"]=7000, ["Zibra Zubra Zibralini"]=7750,
    ["Cavallo Virtuso"]=8500, ["Gorillo Watermelondrillo"]=9500, ["Cocofanto Elefanto"]=10000, ["Girafa Celeste"]=16500,
    ["Tralalero Tralala"]=17500, ["Tralalerita Tralala"]=18000, ["Peant Jarro"]=19500, ["Dipperi Chiperini"]=20000,
    ["Rexosaurus"]=22500, ["1x1x1x1"]=23000, ["Matteo"]=25000, ["Espresso Signora"]=27500, ["Alessio"]=27500,
    ["Tripi Tropi Tropa Tripa"]=28000, ["SWAG SODA"]=29000, ["Stoppo Luminino"]=30000, ["Torrtuginni Dragonfrutini"]=32000,
    ["Tictac Sahur"]=38000, ["Los Primos Blue"]=44500, ["Cactus Pingu"]=44500, ["La Vacca Saturno Saturnita"]=49500,
    ["Agarrini La Palini"]=53500, ["Karkerkar Kurkur"]=120000, ["Blackhole Goat"]=125000, ["Cappuccino Clownino"]=135000,
    ["Compactoroni Diskaloni"]=135000, ["Nuclearo Dinossauro"]=190000, ["Chillin Chilli"]=220000, ["Crazylone Pizaione"]=225000,
    ["Corn Sahur"]=225000, ["Meowl"]=275000, ["Strawberry Elephant"]=420000, ["Dragonfrutina Dolphinita"]=475000,
    ["Guerriro Digitale"]=490000, ["Chicleteira Bicicleteira"]=500000, ["Pot Hotspot"]=525000, ["Krupuk Pagi Pagi"]=540000,
    ["Beluga Beluga"]=575000, ["Tralaledon"]=625000, ["Anpali Babel"]=750000, ["Mastodontico Telepiedone"]=850000,
    ["Ketupat Kepat"]=1000000,
}

local MutationBuffs = {
    ["Golden"]=1.5, ["Diamond"]=2, ["Plasma"]=4, ["Molten"]=6,
    ["Radioactive"]=8, ["Void"]=10, ["Shadow"]=12, ["Electrified"]=16, ["Rainbow"]=30,
}

-- ============================================================
-- 7. Auto Equip Best
-- Scan backpack → sort by CPS/Rarity → kosongkan plot → pasang ulang
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
            notif("Character belum siap!", 4, "Equip Best"); return
        end

        notif("Mencari plot kamu...", 3, "Equip Best")
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
            notif("Plot tidak ditemukan! Pastikan kamu sudah punya plot.", 5, "Equip Best"); return
        end
        notif("Plot ditemukan: " .. myPlot.Name, 3, "Equip Best")

        local slotsFolder = myPlot:FindFirstChild("Slots")
        if not slotsFolder then
            notif("Folder Slots tidak ditemukan!", 4, "Equip Best"); return
        end

        notif("Menganalisis Plot & Tas (" .. Config.EquipMode .. ")...", 3, "Equip Best")
        
        local plotItems = {}
        local emptySlots = {}

        for _, slot in ipairs(slotsFolder:GetChildren()) do
            local att = slot:FindFirstChild("Attachment")
            local prompt = att and att:FindFirstChild("CustomPrompt")
            if not prompt then continue end
            
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
                
                table.insert(plotItems, {
                    slot = slot,
                    prompt = prompt,
                    cpsValue = cpsVal,
                    rarityRank = rarityRank,
                    name = id
                })
            else
                table.insert(emptySlots, { slot = slot, prompt = prompt })
            end
        end

        -- Sort plotItems dari yang PALING LEMAH ke PALING KUAT (ASCENDING)
        if Config.EquipMode == "Rarity" then
            table.sort(plotItems, function(a, b)
                if a.rarityRank ~= b.rarityRank then return a.rarityRank < b.rarityRank end
                return a.cpsValue < b.cpsValue
            end)
        else
            table.sort(plotItems, function(a, b) return a.cpsValue < b.cpsValue end)
        end

        local bpItems = {}
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
                
                table.insert(bpItems, {
                    instance = tool,
                    cpsValue = cpsVal,
                    rarityRank = rarityRank,
                    name = id
                })
            end
        end

        -- Sort bpItems dari yang PALING KUAT ke PALING LEMAH (DESCENDING)
        if Config.EquipMode == "Rarity" then
            table.sort(bpItems, function(a, b)
                if a.rarityRank ~= b.rarityRank then return a.rarityRank > b.rarityRank end
                return a.cpsValue > b.cpsValue
            end)
        else
            table.sort(bpItems, function(a, b) return a.cpsValue > b.cpsValue end)
        end

        local actionsToTake = {} -- { type = "Fill" | "Swap", slot = slotObj, prompt = promptObj, newTool = toolObj }

        for _, bpItem in ipairs(bpItems) do
            if #emptySlots > 0 then
                local eSlot = table.remove(emptySlots, 1)
                table.insert(actionsToTake, {
                    type = "Fill",
                    slot = eSlot.slot,
                    prompt = eSlot.prompt,
                    newTool = bpItem.instance
                })
            elseif #plotItems > 0 then
                local weakestPlot = plotItems[1]
                local isBetter = false
                
                if Config.EquipMode == "Rarity" then
                    if bpItem.rarityRank > weakestPlot.rarityRank then isBetter = true
                    elseif bpItem.rarityRank == weakestPlot.rarityRank and bpItem.cpsValue > weakestPlot.cpsValue then isBetter = true end
                else
                    if bpItem.cpsValue > weakestPlot.cpsValue then isBetter = true end
                end
                
                if isBetter then
                    table.remove(plotItems, 1)
                    table.insert(actionsToTake, {
                        type = "Swap",
                        slot = weakestPlot.slot,
                        prompt = weakestPlot.prompt,
                        newTool = bpItem.instance
                    })
                else
                    break -- Sudah mencapai batas maksimal
                end
            end
        end

        if #actionsToTake == 0 then
            notif("✅ Plot kamu sudah maksimal! Tidak ada yang perlu ditukar.", 5, "Equip Best")
            return
        end

        notif("Mengeksekusi " .. #actionsToTake .. " Brainrot (Smart Swap)...", 4, "Equip Best")
        for _, action in ipairs(actionsToTake) do
            hrp.CFrame = action.slot.CFrame + Vector3.new(0, 4, 0)
            task.wait(0.05)
            
            if action.type == "Swap" then
                fireproximityprompt(action.prompt)
                -- Tunggu PlacedPart hilang, maksimal 1 detik
                local t = 0
                while action.slot:FindFirstChild("PlacedPart") and t < 10 do
                    task.wait(0.1)
                    t = t + 1
                end
                task.wait(0.1) -- Extra delay agar server mencatat pencopotan
            end
            
            hum:EquipTool(action.newTool)
            task.wait(0.15)
            fireproximityprompt(action.prompt)
            task.wait(0.2)
            hum:UnequipTools()
            task.wait(0.05)
        end

        hum:UnequipTools()
        notif("✅ Selesai! Berhasil melakukan " .. #actionsToTake .. " aksi.", 5, "Equip Best")
    end)
end

-- ============================================================
-- Auto Upgrade Brainrot Level
-- Berdasarkan: rev_B_Upgrade remote + SurfaceGUIs slot detection
-- ============================================================
local function startAutoUpgrade()
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then notif("Character belum siap!", 4, "Upgrade Level"); return end

        local targetLevel = Config.TargetUpgradeLevel
        notif("Memulai Auto Upgrade → Level " .. targetLevel, 4, "Upgrade Level")

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
        if not myPlot then notif("Plot tidak ditemukan!", 5, "Upgrade Level"); return end

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
        notif("✅ Upgrade selesai! " .. upgraded .. " slot → Lvl " .. targetLevel, 5, "Upgrade Level")
    end)
end

-- ============================================================
-- 6. Auto Click KickUpgrade
-- Klik GetChildren()[4] dari KickUpgrades kalau muncul,
-- tapi SKIP kalau itu adalah tombol "Bonus".
-- Pakai MouseButton1Click:Fire() → tidak gerakin mouse sama sekali.
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
                        -- 1. Cek apakah nama brainrot ini ada di list TargetSellBrainrots
                        local shouldSell = false
                        for _, targetName in ipairs(Config.TargetSellBrainrots) do
                            local rawName = targetName:match("^(.-) %(x%d+%)$") or targetName
                            if rawName == tool.Name then
                                shouldSell = true
                                break
                            end
                        end
                        
                        -- Kalau namanya tidak dicentang untuk dijual, lewati
                        if not shouldSell then continue end

                        -- 2. Cek apakah mutasi brainrot ini ada di list ProtectSellMutations
                        local mutasi = tool:GetAttribute("Mutation") or "None"
                        local isProtected = false
                        for _, protMut in ipairs(Config.ProtectSellMutations) do
                            if protMut == mutasi then
                                isProtected = true
                                break
                            end
                        end

                        -- Kalau mutasinya dicentang untuk dilindungi, lewati
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

-- ─── TAB INFO ───
local InfoTab = Tabs:AddTab({ Name = "Info", Icon = "info" })

local InfoSection = InfoTab:AddSection("Napoleon — Kick Brainrot",true)
InfoSection:AddParagraph({ 
    Title = "📋 Info Script", 
    Content = "Auto Farm: kick bola otomatis + terbang ke CollectZone.\nAuto Snap: cancel gacha otomatis by mutasi / nama / rarity.\nAuto Collect: ambil cash dari tiap slot plot.\nAuto Equip Best: pasang brainrot terbaik ke plot otomatis.\nAuto Upgrade Level: upgrade brainrot ke level target." 
})

InfoSection:AddButton({
    Title = "Join Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/RKaZ9vEbpb")
            notif("Link Discord berhasil disalin ke clipboard!", 3, "Napoleon")
        else
            notif("Eksekutor tidak mendukung copy link. Join manual: discord.gg/RKaZ9vEbpb", 5, "Napoleon")
        end
    end
})

-- ─── TAB MAIN ───
local MainTab = Tabs:AddTab({ Name = "Main", Icon = "rod" })

local KickSection = MainTab:AddSection("Auto Farm")
KickSection:AddToggle({
    Title = "Auto Farm",
    Title2 = "Aktifkan",
    Content = "Kick bola + terbang ke CollectZone setiap siklus",
    Default = false,
    Callback = function(val)
        Config.AutoFarm = val
        if val then
            startFarm()
            notif("Auto Farm aktif!", 4, "Farm")
        else
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            removeBodyVelocity(hrp)
            notif("Auto Farm dimatikan.", 3, "Farm")
        end
    end
})

KickSection:AddSlider({
    Title = "Fly Speed",
    Content = "Kecepatan terbang ke CollectZone (studs/s)",
    Min = 30,
    Max = 300,
    Increment = 10,
    Default = 120,
    Callback = function(val)
        Config.FlySpeed = val
    end
})

KickSection:AddButton({
    Title = "✖ Cancel Brainrot",
    Content = "Snap teleport menjauh → batalkan gacha yang sedang aktif",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then notif("Character belum siap!", 3, "Cancel"); return end
        removeBodyVelocity(hrp)
        hrp.CFrame = CFrame.new(698.249695, 3.150006, 232.345169)
        isFlyingToCollect = false
        notif("Brainrot dibatalkan (snap)!", 3, "Cancel")
    end
})

local SnapSection = MainTab:AddSection("Auto Snap")
SnapSection:AddToggle({
    Title = "Enable Auto Snap",
    Title2 = "Aktifkan",
    Content = "Batalkan gacha yang tidak sesuai filter",
    Default = false,
    Callback = function(val)
        Config.EnableSnap = val
        notif(val and "Auto Snap aktif!" or "Auto Snap dimatikan.", 3, "Snap")
    end
})

SnapSection:AddDropdown({
    Title = "Snap Type",
    Content = "Mode filter gacha",
    Options = {"Mutation", "Brainrot", "Rarity"},
    Default = Config.SnapType,
    Callback = function(val)
        Config.SnapType = val
        notif("Snap Mode: " .. val, 2, "Snap")
    end
})

SnapSection:AddDropdown({
    Title = "Target Mutation",
    Content = "Multi-pilih mutasi. 'None' = brainrot tanpa mutasi",
    Options = MUTATION_LIST,
    Default = Config.TargetMutations,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.TargetMutations = val
        else
            Config.TargetMutations = {val}
        end
    end
})

SnapSection:AddDropdown({
    Title = "Target Brainrot",
    Content = "Multi-pilih nama. 'None' = semua boleh",
    Options = BRAINROT_LIST,
    Default = Config.TargetBrainrots,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.TargetBrainrots = val
        else
            Config.TargetBrainrots = {val}
        end
    end
})

SnapSection:AddDropdown({
    Title = "Target Rarity",
    Content = "Multi-pilih rarity. 'None' = semua boleh",
    Options = {"None", table.unpack(RARITY_LIST)},
    Default = Config.TargetRarities,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.TargetRarities = val
        else
            Config.TargetRarities = {val}
        end
        notif("Rarity dipilih: " .. #Config.TargetRarities .. " item", 2, "Snap")
    end
})

-- ─── TAB AUTOMATICALLY ───
local AutoTab = Tabs:AddTab({ Name = "Automatically", Icon = "next" })

local SellSection = AutoTab:AddSection("Auto Sell Backpack")
SellSection:AddToggle({
    Title = "Enable Auto Sell",
    Title2 = "Aktifkan",
    Content = "Jual otomatis isi tas yang sesuai dengan filter (Butuh pegang brainrot)",
    Default = false,
    Callback = function(val)
        Config.AutoSell = val
        if val then
            startAutoSell()
            notif("Auto Sell aktif!", 3, "Auto Sell")
        else
            notif("Auto Sell dimatikan.", 3, "Auto Sell")
        end
    end
})

local function getBackpackList()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return {"None"} end
    local counts = {}
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") then
            counts[tool.Name] = (counts[tool.Name] or 0) + 1
        end
    end
    local list = {"None"}
    for name, count in pairs(counts) do
        table.insert(list, string.format("%s (x%d)", name, count))
    end
    if #list == 1 then table.insert(list, "Tas Kosong") end
    return list
end

SellSection:AddDropdown({
    Title = "Target Sell Brainrots",
    Content = "Pilih nama brainrot yang MAU DIJUAL (Execute ulang script untuk update list tas)",
    Options = getBackpackList(),
    Default = Config.TargetSellBrainrots,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.TargetSellBrainrots = val
        else
            Config.TargetSellBrainrots = {val}
        end
    end
})

SellSection:AddDropdown({
    Title = "Protect Mutations",
    Content = "Pilih mutasi yang mau DILINDUNGI (Aman dari jual otomatis)",
    Options = MUTATION_LIST,
    Default = Config.ProtectSellMutations,
    Multi = true,
    Callback = function(val)
        if type(val) == "table" then
            Config.ProtectSellMutations = val
        else
            Config.ProtectSellMutations = {val}
        end
    end
})

local CashSection = AutoTab:AddSection("Auto Collect Cash")
CashSection:AddToggle({
    Title = "Auto Collect Cash",
    Title2 = "Aktifkan",
    Content = "Teleport ke tiap slot & kumpulkan cash otomatis",
    Default = false,
    Callback = function(val)
        Config.AutoCollectCash = val
        if val then
            startCollectCash()
            notif("Auto Collect Cash aktif! " .. getMaxSlot() .. " slot.", 4, "Cash")
        else
            notif("Auto Collect Cash dimatikan.", 3, "Cash")
        end
    end
})

local EquipSection = AutoTab:AddSection("Auto Equip Best")
EquipSection:AddDropdown({
    Title = "Equip Mode",
    Content = "CPS = dari UI game. Base CPS = dari database x mutasi. Rarity = paling langka.",
    Options = {"CPS", "Base CPS", "Rarity"},
    Default = "CPS",
    Callback = function(val)
        Config.EquipMode = val
        notif("Equip Mode: " .. val, 2, "Equip Best")
    end
})

EquipSection:AddButton({
    Title = "▶  Jalankan Auto Equip Best",
    Content = "Kosongkan plot → scan backpack → pasang brainrot terbaik",
    Callback = function()
        notif("Memulai Auto Equip Best...", 3, "Equip Best")
        startEquipBest()
    end
})

local UpgradeLvlSection = AutoTab:AddSection("Auto Upgrade Level")
UpgradeLvlSection:AddInput({
    Title = "Target Level",
    Content = "Level tujuan upgrade semua brainrot di plot",
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
    Title = "▶  Jalankan Auto Upgrade Level",
    Content = "Teleport ke tiap slot, upgrade ke Target Level",
    Callback = function()
        notif("Memulai upgrade ke Level " .. Config.TargetUpgradeLevel .. "...", 3, "Upgrade Level")
        startAutoUpgrade()
    end
})

-- ─── TAB MISCELLANEOUS ───
local MiscTab = Tabs:AddTab({ Name = "Miscellaneous", Icon = "rod" })

local ClickSection = MiscTab:AddSection("Auto Click")
ClickSection:AddToggle({
    Title = "Auto Click x2",
    Title2 = "Aktifkan",
    Content = "Klik popup upgrade x2 otomatis saat muncul",
    Default = true,
    Callback = function(val)
        Config.AutoClickUpgrade = val
        notif(val and "Auto Click x2 aktif!" or "Auto Click x2 mati.", 3, "Click")
    end
})

local ModuleSection = MiscTab:AddSection("Kick Module")
ModuleSection:AddButton({
    Title = "Retry Find Kick Module",
    Content = "Cari ulang kick module via getloadedmodules()",
    Callback = function()
        findKickModule()
        notif(kickModule and "Module ditemukan!" or "Belum ditemukan.", 3, "Module")
    end
})

local SystemSection = MiscTab:AddSection("System")
SystemSection:AddToggle({
    Title = "Anti-AFK",
    Title2 = "Aktifkan",
    Content = "Mencegah kick karena idle terlalu lama",
    Default = true,
    Callback = function(val)
        notif(val and "Anti-AFK ON" or "Anti-AFK OFF", 3, "System")
    end
})

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

task.wait(1)
_G.ScriptFullyLoaded = true
notif("Script berhasil dimuat! Buka tab Farm.", 5, "Napoleon")
