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

-- Fungsi Server Hop
local requestfunc = request or http_request or (http and http.request) or (syn and syn.request)

local function HopServer()
    local PlaceID = game.PlaceId
    local cursor = ""
    
    print("🔀 [Smart Hop] Mencari server (Otomatis skip server penuh)...")

    -- Fallback jika executor tidak support request
    if not requestfunc then
        requestfunc = function(options)
            return { Body = game:HttpGet(options.Url), StatusCode = 200, Success = true }
        end
    end

    while true do
        -- URL API Roblox
        local url = 'https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true'
        
        if cursor and cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        
        local response = nil
        local success, err = pcall(function()
            response = requestfunc({ Url = url, Method = "GET" })
        end)
        
        -- 1. Cek Koneksi Dasar
        if not success or not response then
            warn("⚠️ Request Gagal (Network Error). Mengulang dalam 3 detik...")
            task.wait(3)
            continue
        end

        -- 2. Cek Status Code (429 = Too Many Requests)
        if response.StatusCode == 429 then
            warn("⚠️ Rate Limit (429). Terlalu banyak request, menunggu 5 detik...")
            task.wait(5)
            continue
        end

        -- 3. Cek Body Kosong
        if not response.Body or #response.Body == 0 then
            warn("⚠️ Response Body kosong. Mengulang...")
            task.wait(3)
            continue
        end
        
        -- 4. [FIX ERROR JSON] Safe Decode JSON
        -- Kita bungkus JSONDecode dalam pcall agar script TIDAK CRASH jika Roblox kirim HTML error
        local Site = nil
        local decodeSuccess, decodeErr = pcall(function()
            Site = HttpService:JSONDecode(response.Body)
        end)

        if not decodeSuccess then
            warn("❌ Error: Can't parse JSON.")
            print("📄 Isi Response Asli (Debug):", string.sub(response.Body, 1, 100)) -- Print 100 huruf pertama buat cek
            task.wait(3)
            continue -- Skip loop ini, jangan crash
        end

        if not Site or not Site.data then
            warn("⚠️ Format JSON tidak sesuai (Missing 'data'). Mengulang...")
            cursor = "" 
            task.wait(2)
            continue
        end
        
        -- Update Cursor untuk halaman berikutnya
        cursor = Site.nextPageCursor or ""
        
        local validServers = {}
        
        for _, v in pairs(Site.data) do
            -- Filter server valid (bukan server sendiri & ada orangnya)
            if v.playing and v.id ~= game.JobId and v.playing > 0 then
                table.insert(validServers, v.id)
            end
        end
        
        if #validServers > 0 then
            print("🚀 Menemukan " .. #validServers .. " server kosong. OTW...")
            
            -- Acak urutan server biar gak numpuk di satu server
            for i = #validServers, 2, -1 do
                local j = math.random(i)
                validServers[i], validServers[j] = validServers[j], validServers[i]
            end
            
            -- Coba Teleport satu per satu
            for _, serverID in ipairs(validServers) do
                local tpSuccess = pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceID, serverID, LocalPlayer)
                end)
                if tpSuccess then 
                    print("✈️ Teleporting...")
                    task.wait(4) 
                end
            end
        else
            print("ℹ️ Halaman ini penuh/kosong, cek halaman berikutnya...")
        end
        
        if cursor == "" then
            print("🔄 Reached end of servers. Refreshing list...")
            task.wait(1)
        end
        
        task.wait(1)
    end
end

-- ===== EKSEKUSI =====

collectCrystals()
task.wait(1)
HopServer()
