task.wait(10)
-- ===== SERVICES & VARIABLES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Definisi Variabel Settings yang sebelumnya tidak ada/kurang lengkap di luar blok
local Settings = {
    Enabled = true,
    
    AutoEquipItem = true,
    ItemIDToEquip = 20220,  -- Crystal Detector item
    
    TPDelay = 0.3,          -- Delay setelah TP
    InteractDelay = 0.2,    -- Delay setelah interact
}

local isRunning = false

-- Simulasi Tab UI jika UtilTab belum didefinisikan (Untuk menghindari error nil)
-- Jika Anda menggunakan UI Library tertentu (seperti Fluent, Orion, dll), pastikan UtilTab sudah didefinisikan sebelumnya.
local UtilTab = UtilTab or { 
    AddSection = function(self, name) return {} end 
} 

-- ===== FUNCTIONS =====

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
    local char = LocalPlayer.Character
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
    local oldLocation = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame or nil

    if isRunning then return end -- Prevent double run
    isRunning = true
    
    -- Step 1: Equip item
    print("🔍 Checking and equipping required item...")
    if not equipItem(Settings.ItemIDToEquip) then
        warn("❌ not equipped pickaxe, aborting...")
        isRunning = false
        return
    end

    -- Safe Teleport to Crystal Depths Entrance Area (mencegah fall damage atau bug collision)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5808.42529, -899.366394, 15353.1709)
    end
    
    task.wait(5) -- Waktu untuk load area
    
    local crystals = getCrystalsWithPrompt()
    
    if #crystals == 0 then
        warn("❌ No crystals found!")
        if oldLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
             LocalPlayer.Character.HumanoidRootPart.CFrame = oldLocation
        end
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
        end
        
        task.wait(Settings.InteractDelay)
    end
    
    if oldLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = oldLocation
    end
    
    isRunning = false -- Release lock
end

collectCrystals()-- realbunni.com

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- [[ KONFIGURASI ]]
local DATA_URL = "https://raw.githubusercontent.com/vandawam2/vans-ui/refs/heads/main/data.txt"
local PLACE_ID = 121864768012064 
local FILE_NAME = "vans_visited_servers.json" -- File history blacklist

-- [[ FUNGSI HISTORY ]]
local function getVisitedServers()
    if isfile(FILE_NAME) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(FILE_NAME))
        end)
        if success and type(result) == "table" then return result end
    end
    return {}
end

local function saveCurrentServer()
    local visited = getVisitedServers()
    local currentId = game.JobId
    local isRecorded = false
    for _, id in pairs(visited) do
        if id == currentId then isRecorded = true break end
    end
    if not isRecorded then
        table.insert(visited, currentId)
        if #visited > 20 then table.remove(visited, 1) end
        writefile(FILE_NAME, HttpService:JSONEncode(visited))
    end
end

-- [[ FUNGSI UTAMA HOP ]]
local function SmartServerHop()
    saveCurrentServer() -- Simpan server ini biar gak balik lagi
    
    print("🌐 Mengambil data server...")
    local success, response = pcall(function() return game:HttpGet(DATA_URL) end)
    if not success then warn("❌ Gagal ambil data GitHub.") return end

    local decodeSuccess, parsed = pcall(function() return HttpService:JSONDecode(response) end)
    if not decodeSuccess or not parsed.data then warn("❌ JSON Rusak.") return end

    local visitedServers = getVisitedServers()
    
    -- Acak urutan server
    local servers = parsed.data
    for i = #servers, 2, -1 do
        local j = math.random(i)
        servers[i], servers[j] = servers[j], servers[i]
    end

    print("🔍 Mencari server kosong dari " .. #servers .. " list...")

    -- LOOPING MENCOBA SETIAP SERVER
    for _, server in ipairs(servers) do
        
        -- Cek Blacklist History
        local isBlacklisted = false
        for _, visitedId in pairs(visitedServers) do
            if server.id == visitedId then isBlacklisted = true break end
        end

        -- Syarat: Ada Slot, Bukan Server Ini, Tidak Blacklist
        if not isBlacklisted and server.playing < server.maxPlayers and server.id ~= game.JobId then
            
            print("------------------------------------------------")
            print("🚀 Mencoba masuk ke ID: " .. server.id)
            print("👥 Pemain: " .. server.playing .. "/" .. server.maxPlayers)
            
            -- Notifikasi Kecil
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Mencoba Server...";
                    Text = "Menunggu 5 detik...";
                    Duration = 3;
                })
            end)

            -- EKSEKUSI TELEPORT
            TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, Players.LocalPlayer)

            -- [[ FITUR UTAMA: TUNGGU 5 DETIK ]]
            -- Jika teleport berhasil, script akan mati sendiri karena kamu pindah game.
            -- Jika teleport GAGAL (penuh), script akan lanjut jalan ke baris di bawah ini.
            task.wait(5) 

            -- Jika script sampai ke sini, berarti GAGAL pindah (Server Penuh/Error)
            warn("⚠️ Gagal/Penuh. Lanjut ke server berikutnya...")
            
            -- Lanjut loop ke server berikutnya...
        end
    end

    -- Jika semua server dicoba dan gagal semua
    warn("⚠️ Semua server di list sudah dicoba/penuh!")
    print("🔄 Reset history dan coba ulang dari awal...")
    
    if isfile(FILE_NAME) then delfile(FILE_NAME) end
    task.wait(2)
    SmartServerHop() -- Ulangi fungsi
end

-- Jalankan
SmartServerHop()
