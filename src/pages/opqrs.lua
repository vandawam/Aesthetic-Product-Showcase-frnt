-- ============================================================
-- iSylHub v28.0 - ULTIMATE WIZARD (Auto Detect Fuse Tier)
-- ============================================================
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local msgFolder = ReplicatedStorage:WaitForChild("Msg")
local remoteEventFolder = msgFolder:WaitForChild("RemoteEvent")

-- Jalur Komunikasi Remotes
local remoteFunction = msgFolder:WaitForChild("RemoteFunction"):WaitForChild("RemoteFunction")
local talkFunc = msgFolder:WaitForChild("Function"):WaitForChild("TalkFunc")
local generalRemoteEvent = remoteEventFolder:WaitForChild("RemoteEvent")
local releaseGroupSkillEvent = remoteEventFolder:WaitForChild("ReleaseGroupSkill")

-- Load Module Database Game
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem)
local CfgFind = UtilsSystem.CfgFind
local PlayerData = UtilsSystem.PlayerData
local EnumMgr = UtilsSystem.EnumMgr
local GetData = UtilsSystem.GetData -- 🚀 NEW: Modul untuk mengambil data kalkulasi game
local LanguageCfg
pcall(function()
    LanguageCfg = require(ReplicatedFirst.AllSideCode.ToolBasic.TranslationHelper.LanguageCfg)
end)

-- Variabel Utama UI & Global State
getgenv().AutoFarm = false
getgenv().AutoCollect = false
getgenv().AutoSkill = false
getgenv().AutoSell = false
getgenv().AlchemyGod = false 
getgenv().SelectedMaterialsToSell = {} 
getgenv().SelectedMonsters = {"All"} 

getgenv().AutoBrew = false
getgenv().SelectedBrewMaterials = {} 
getgenv().AutoFusePotions = false
getgenv().DebugBrew = false 

-- 🚀 MUTEX LOCK
getgenv().IsBrewingTaskRunning = false 

local attackDelay = 0.2
local currentTarget = nil
local lastSafeCFrame = nil

-- Teks Kamus untuk Dropdown
local AllMaterialNames = {}
local IdToTranslatedMap = {} 
local TranslatedNameToIdMap = {} 
local monsterList = {"All"} 
local MonsterNameToIdMap = {} 

-- ============================================================
-- 🧪 ALCHEMY GOD METAMETHOD HOOK 
-- ============================================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if getgenv().AlchemyGod and not checkcaller() and method == "InvokeServer" then 
        local args = {...}
        if args[1] == "\xE7\x82\xBC\xE8\x8D\xAF" and type(args[2]) == "table" then 
            args[2].gameScore = 100 
        end
    end

    return oldNamecall(self, ...)
end)

-- ============================================================
-- 📦 DATABASE MANIFEST INTERCEPTOR
-- ============================================================
local function buildKatalogDropdowns()
    table.clear(AllMaterialNames)
    table.clear(IdToTranslatedMap)
    table.clear(TranslatedNameToIdMap)
    
    local dbNames = {"materialConf", "itemConf", "item", "material"}
    for _, dbName in ipairs(dbNames) do
        local tableRef = CfgFind.GetCfgByName(dbName)
        if type(tableRef) == "table" then
            for id, data in pairs(tableRef) do
                if type(data) == "table" and data.ZhName then
                    local isMaterial = false
                    if data.MaterialTp ~= nil or data.materialTp ~= nil then
                        isMaterial = true
                    else
                        pcall(function()
                            local verifyMat = CfgFind.FindCfgByID(tonumber(id), EnumMgr.ItemType.Material)
                            if verifyMat then isMaterial = true end
                        end)
                    end
                    
                    if isMaterial then
                        local translatedName = nil
                        pcall(function() if LanguageCfg then translatedName = LanguageCfg.FormatByKey(data.ZhName) end end)
                        if translatedName and translatedName ~= "" and translatedName ~= data.ZhName and not string.match(translatedName, "[\228-\233]") then
                            local stringId = tostring(id)
                            if not IdToTranslatedMap[stringId] then
                                IdToTranslatedMap[stringId] = translatedName
                                TranslatedNameToIdMap[translatedName] = tonumber(id) 
                                table.insert(AllMaterialNames, translatedName)
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(AllMaterialNames)

    local enemyDbNames = {"enemyConf", "enemy", "monsterConf"}
    for _, dbName in ipairs(enemyDbNames) do
        local enemyTable = CfgFind.GetCfgByName(dbName)
        if type(enemyTable) == "table" then
            for id, data in pairs(enemyTable) do
                if type(data) == "table" and data.ZhName then
                    local transMonsterName = nil
                    pcall(function() if LanguageCfg then transMonsterName = LanguageCfg.FormatByKey(data.ZhName) end end)
                    if not transMonsterName or transMonsterName == "" then transMonsterName = data.ZhName end
                    
                    if transMonsterName then
                        local stringId = tostring(id)
                        MonsterNameToIdMap[transMonsterName] = stringId
                        if not table.find(monsterList, transMonsterName) then
                            table.insert(monsterList, transMonsterName)
                        end
                    end
                end
            end
        end
    end
    table.sort(monsterList)
end
buildKatalogDropdowns()

-- ============================================================
-- 1. EXTRACT NAMA MONSTER
-- ============================================================
local monsterNameCache = setmetatable({}, {__mode = "k"})
local function getRealMonsterName(monsterObj)
    if monsterNameCache[monsterObj] then return monsterNameCache[monsterObj] end
    local finalName = nil
    local dbID = monsterObj:GetAttribute("ID")
    local zhNameAttr = monsterObj:GetAttribute("ZhName")
    if dbID then
        pcall(function()
            local enemyData = CfgFind.FindCfgByID(dbID, EnumMgr.ItemType.Enemy)
            if enemyData and enemyData.ZhName and LanguageCfg then
                local translated = LanguageCfg.FormatByKey(enemyData.ZhName)
                if translated and translated ~= "" then finalName = translated
                else finalName = enemyData.ZhName end
            end
        end)
    end
    if not finalName and zhNameAttr and LanguageCfg then
        pcall(function() finalName = LanguageCfg.FormatByKey(zhNameAttr) or zhNameAttr end)
    end
    if not finalName then
        for _, desc in ipairs(monsterObj:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Text ~= "" then
                local txt = desc.Text
                if not tonumber(txt) and not string.match(string.lower(txt), "lv%.?%s*%d+") then
                    finalName = txt; break
                end
            end
        end
    end
    if not finalName then finalName = "Monster ID: " .. tostring(dbID or monsterObj.Name) end
    monsterNameCache[monsterObj] = finalName
    return finalName
end

-- ============================================================
-- 2. NAPOLEON UI SETUP 
-- ============================================================
_G.ScriptFullyLoaded = false 
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fdhlnn23/NapoleonUI/refs/heads/main/NPLN-UIv2.lua"))()
local ICON_ID = "96531489912535" 

local function notif(content, duration, title)
    if not _G.ScriptFullyLoaded then return end
    if Library and Library.MakeNotify then
        Library:MakeNotify({ Title = title or "iSylHub", Content = content, Delay = duration or 4, Icon = "rbxassetid://" .. ICON_ID })
    end
end

local Window = Library:Window({
    Title = "iSylHub", Footer = "Ultimate Wizard v28.0",
    Color = Color3.fromRGB(255, 255, 255), Color2 = Color3.fromRGB(192, 192, 192),
    ["Tab Width"] = 130, Image = "136289055140268", WindowIMG = "93732999692312", LogoHUB = "136289055140268"
})

local FarmTab = Window:AddTab({ Name = "Auto Farm", Icon = "rod" })
local FarmSection = FarmTab:AddSection("Target & Control")

local MonsterDropdown = FarmSection:AddDropdown({
    Title = "Pilih Target Monster", Content = "Centang semua monster target buruanmu",
    Default = {"All"}, Options = monsterList, Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedMonsters = ValueTable
        currentTarget = nil 
    end    
})

FarmSection:AddToggle({
    Title = "Aktifkan Helicopter Farm", Content = "Terbang & No-Clip otomatis",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not Value then
            if hrp and hrp:FindFirstChild("FarmBV") then hrp.FarmBV:Destroy() end
            currentTarget = nil
            if char then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("BasePart") then child.CanCollide = true end
                end
            end
        end
    end    
})

local FeatureSection = FarmTab:AddSection("Extra Features")
FeatureSection:AddToggle({
    Title = "Auto Use Skill (1 & 2)", Content = "Otomatis menggunakan Skill",
    Default = false,
    Callback = function(Value) getgenv().AutoSkill = Value end    
})
FeatureSection:AddToggle({
    Title = "Auto Collect Drops (Magnet)", Content = "Otomatis ambil loot dari monster yang mati",
    Default = false,
    Callback = function(Value) getgenv().AutoCollect = Value end    
})

local EcoTab = Window:AddTab({ Name = "Economy", Icon = "coin" })
local SellSection = EcoTab:AddSection("Sistem Penjualan Otomatis")

SellSection:AddToggle({
    Title = "Aktifkan Auto Sell", Content = "Otomatis memindai tas dan menjual material terpilih secara instan",
    Default = false,
    Callback = function(Value)
        getgenv().AutoSell = Value
        if Value then notif("Auto Sell Instan Aktif!", 3, "Success") end
    end    
})
SellSection:AddDropdown({
    Title = "Pilih Material Jual", Content = "Centang material yang ingin dibuang secara otomatis",
    Default = {}, Options = AllMaterialNames, Multi = true,
    Callback = function(ValueTable)
        getgenv().SelectedMaterialsToSell = ValueTable
    end    
})

local AlchTab = Window:AddTab({ Name = "Alchemy", Icon = "flask" })
local AlchSection = AlchTab:AddSection("Auto Brew & God Mode")

AlchSection:AddToggle({
    Title = "Aktifkan Auto Brew (AFK)", Content = "Otomatis scan tas & meracik jika bahan mencapai 5",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBrew = Value
        if Value then notif("Auto Brew Menyala!", 4, "Success") end
    end    
})

AlchSection:AddDropdown({
    Title = "Pilih Bahan Racikan", 
    Content = "Centang bahan. Script meracik otomatis di background.",
    Default = {}, 
    Options = AllMaterialNames, 
    Multi = true, 
    Callback = function(ValueTable)
        getgenv().SelectedBrewMaterials = ValueTable
    end    
})

-- 🚀 NEW: Auto Potion Fuse (Tanpa Input Amount)
AlchSection:AddToggle({
    Title = "Aktifkan Auto Potion Fuse", Content = "Script cerdas mendeteksi syarat 100% dari game per tier potion.",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFusePotions = Value
        if Value then notif("Auto Potion Fuse Menyala!", 4, "Success") end
    end    
})

AlchSection:AddToggle({
    Title = "Aktifkan Alchemy God (Manual)", Content = "Developer Auto-Skip menyala!",
    Default = false,
    Callback = function(Value)
        getgenv().AlchemyGod = Value
        if Value then
            local success, GameCfg = pcall(function() return require(ReplicatedStorage.GuiScripts.ModuleScript.PotionBrewingGame.GameCfg) end)
            if success and GameCfg and GameCfg.TEST_MODE then
                GameCfg.TEST_MODE.Game1 = true
                GameCfg.TEST_MODE.Game2 = true
                GameCfg.TEST_MODE.Game3 = true
                GameCfg.TEST_MODE.WatchPotionShowAnimation = true
                notif("Alchemy God Modifikasi Sukses Terpasang!", 4, "Success")
            end
        end
    end    
})

local DebugSection = AlchTab:AddSection("Developer Debug Tools")
DebugSection:AddToggle({
    Title = "Aktifkan Debug Mode (F9)", Content = "Melihat data log racikan di konsol untuk melacak BUG.",
    Default = false,
    Callback = function(Value)
        getgenv().DebugBrew = Value
    end    
})

_G.ScriptFullyLoaded = true
notif("iSylHub Ultimate v28.0 Siap!", 4, "Success")

-- ============================================================
-- 🚀 AGGRESSIVE UI UNLOCKER & MODULE INTERCEPTOR
-- ============================================================
task.spawn(function()
    pcall(function()
        local MatChoose = require(ReplicatedStorage.GuiScripts.ModuleScript.MaterialChoose)
        if type(MatChoose.openUi) == "function" and not MatChoose.iSylHooked then
            local oldMatOpen = MatChoose.openUi
            MatChoose.openUi = function(self, ...)
                if getgenv().AutoBrew or getgenv().AutoFusePotions then return end 
                return oldMatOpen(self, ...)
            end
            MatChoose.iSylHooked = true
        end
    end)
    
    pcall(function()
        local PotionGame = require(ReplicatedStorage.GuiScripts.ModuleScript.PotionBrewingGame)
        if type(PotionGame.openUi) == "function" and not PotionGame.iSylHooked then
            local oldPotOpen = PotionGame.openUi
            PotionGame.openUi = function(self, ...)
                if getgenv().AutoBrew or getgenv().AutoFusePotions then return end 
                return oldPotOpen(self, ...)
            end
            PotionGame.iSylHooked = true
        end
    end)
    
    pcall(function()
        local PotionFuse = require(ReplicatedStorage.GuiScripts.ModuleScript.PotionFuse)
        if type(PotionFuse.openUi) == "function" and not PotionFuse.iSylHooked then
            local oldFuseOpen = PotionFuse.openUi
            PotionFuse.openUi = function(self, ...)
                if getgenv().AutoBrew or getgenv().AutoFusePotions then return end 
                return oldFuseOpen(self, ...)
            end
            PotionFuse.iSylHooked = true
        end
    end)

    while task.wait(0.5) do 
        if getgenv().AutoBrew or getgenv().AutoFusePotions then
            pcall(function()
                if UtilsSystem and UtilsSystem.UIMgr then
                    UtilsSystem.UIMgr.SetMainUIVisible(true)
                    UtilsSystem.UIMgr.SetMainToolsVisible(true)
                    UtilsSystem.UIMgr.ShowMovieBlack(false)
                    UtilsSystem.UIMgr.ShowChooseBlackGui(false)
                end
                
                player:SetAttribute("RUN_STATE", true)
                
                local selectingVal = player:FindFirstChild("\230\157\144\230\150\153\233\128\137\230\139\169\228\184\173") 
                if selectingVal and selectingVal.Value == true then 
                    selectingVal.Value = false 
                end
                
                local hidePlayersVal = player:FindFirstChild("\230\152\175\229\144\166\233\154\144\232\151\143\229\133\182\228\187\150\231\142\169\229\174\182") 
                if hidePlayersVal and hidePlayersVal.Value == true then 
                    hidePlayersVal.Value = false 
                end
            end)
        end
    end
end)

-- ============================================================
-- 🚀 LOGIKA SMART AUTO BREW 
-- ============================================================
task.spawn(function()
    local BREW_CAULDRON_ID = 8000001
    local BREW_AMOUNT = 5
    
    while task.wait(2) do 
        if getgenv().AutoBrew then
            pcall(function()
                if type(getgenv().SelectedBrewMaterials) ~= "table" then return end
                
                local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
                if type(bagData) ~= "table" then return end

                local bagCounts = {}
                for uniqueID, item in pairs(bagData) do
                    if type(item) == "table" and item.id then
                        local amt = tonumber(item.count) or 1
                        local idNum = tonumber(item.id)
                        
                        if idNum then
                            local itemType = tonumber(item.tp)
                            if itemType == EnumMgr.ItemType.Material then
                                bagCounts[idNum] = (bagCounts[idNum] or 0) + amt
                            end
                        end
                    end
                end

                for k, v in pairs(getgenv().SelectedBrewMaterials) do
                    local matName = type(v) == "string" and v or k
                    local staticID = TranslatedNameToIdMap[matName]
                    
                    if staticID then
                        local currentCount = bagCounts[staticID] or 0
                        if currentCount >= BREW_AMOUNT then
                            local payloadMaterials = { [staticID] = BREW_AMOUNT }
                            
                            getgenv().IsBrewingTaskRunning = true
                            
                            task.spawn(function()
                                pcall(function()
                                    remoteFunction:InvokeServer(
                                        "\xE7\x82\xBC\xE8\x8D\xAF\xE6\xB8\xB8\xE6\x88\x8F\xE5\xBC\x80\xE5\xA7\x8B",
                                        { cauldronID = BREW_CAULDRON_ID, materials = payloadMaterials }
                                    )
                                end)
                                
                                task.wait(0.2)
                                
                                pcall(function()
                                    remoteFunction:InvokeServer("\xE7\x82\xBC\xE8\x8D\xAF", { gameScore = 100 })
                                end)
                                
                                task.wait(0.3)
                                getgenv().IsBrewingTaskRunning = false
                            end)
                            
                            task.wait(1.5) 
                            break 
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- 🚀 LOGIKA AUTO POTION FUSE DENGAN DYNAMIC TIER DETECTION
-- ============================================================
task.spawn(function()
    while task.wait(3.5) do 
        if getgenv().AutoFusePotions then
            pcall(function()
                local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
                if type(bagData) ~= "table" then return end

                local potionGroups = {}
                
                -- Kelompokkan ramuan
                for uniqueID, item in pairs(bagData) do
                    if type(item) == "table" and item.id then
                        local itemType = tonumber(item.tp)
                        
                        if itemType == EnumMgr.ItemType.Potion then
                            local mpTp = item.mpTp
                            
                            -- SAFETY FILTER: Abaikan ramuan MAX TIER (SSS)
                            if type(mpTp) == "string" and string.upper(mpTp) == "SSS" then
                                continue 
                            end
                            
                            local idNum = tostring(item.id) .. "_" .. tostring(mpTp)
                            local dynamicID = item.onlyID or tonumber(uniqueID) or uniqueID
                            
                            if idNum and dynamicID then
                                if not potionGroups[idNum] then
                                    potionGroups[idNum] = {
                                        sampleItem = item, -- Ambil sampel item untuk dicek ke server
                                        ids = {}
                                    }
                                end
                                table.insert(potionGroups[idNum].ids, dynamicID)
                            end
                        end
                    end
                end

                for staticID, group in pairs(potionGroups) do
                    -- 🚀 AUTO-DETECT 100% SUCCESS RATE DARI ENGINE GAME
                    local TARGET_AMOUNT = 3 -- Fallback bawaan
                    
                    pcall(function()
                        if GetData and GetData.GetPotionUpgradeNeedCount then
                            -- Ambil kebutuhan jumlah dari fungsi internal game
                            local required = GetData.GetPotionUpgradeNeedCount(group.sampleItem)
                            if required and type(required) == "number" and required > 0 then
                                TARGET_AMOUNT = required
                            end
                        end
                    end)
                    
                    if #group.ids >= TARGET_AMOUNT then
                        getgenv().IsBrewingTaskRunning = true
                        
                        local fusePayload = {}
                        for i = 1, TARGET_AMOUNT do
                            table.insert(fusePayload, group.ids[i])
                        end
                        
                        if getgenv().DebugBrew then 
                            print("[Fuse] Menggabungkan Potion: " .. tostring(staticID) .. " (Membutuhkan: " .. tostring(TARGET_AMOUNT) .. ")") 
                        end
                        
                        task.spawn(function()
                            pcall(function()
                                remoteFunction:InvokeServer(
                                    "\xE8\x8D\xAF\xE6\xB0\xB4\xE5\x90\x88\xE6\x88\x90",
                                    { onlyIDs = fusePayload }
                                )
                            end)
                            
                            task.wait(0.5)
                            getgenv().IsBrewingTaskRunning = false
                        end)
                        
                        task.wait(1.5) 
                        break 
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- 3. LOGIKA KITING MUTLAK + AUTO NO-CLIP + HOVER ANCHOR
-- ============================================================
local function getValidTarget()
    local folder = workspace:FindFirstChild("Monster")
    if not folder then return nil end
    for _, monster in ipairs(folder:GetChildren()) do
        local hum = monster:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local realName = getRealMonsterName(monster)
            local isMatched = false
            
            if table.find(getgenv().SelectedMonsters, "All") then
                isMatched = true
            else
                for _, targetName in ipairs(getgenv().SelectedMonsters) do
                    if string.find(string.lower(realName), string.lower(targetName)) then
                        isMatched = true
                        break
                    end
                end
            end
            
            if isMatched then return monster end
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not getgenv().AutoFarm then 
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("FarmBV") then hrp.FarmBV:Destroy() end
        lastSafeCFrame = nil
        return 
    end
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("BasePart") and child.CanCollide then child.CanCollide = false end
    end
    
    local hum = currentTarget and currentTarget:FindFirstChildOfClass("Humanoid")
    if not currentTarget or not currentTarget.Parent or (hum and hum.Health <= 0) then
        currentTarget = getValidTarget()
    end
    
    local bv = hrp:FindFirstChild("FarmBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "FarmBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp
    end
    
    if currentTarget then
        local monsterCF = currentTarget:GetPivot()
        local stats = { attackRange = 0, maxChase = 45 } 
        pcall(function()
            local dbID = currentTarget:GetAttribute("ID")
            local enemyData = CfgFind.FindCfgByID(dbID, EnumMgr.ItemType.Enemy)
            if enemyData then
                stats.attackRange = tonumber(enemyData.attackRange) or 0
                stats.maxChase = tonumber(enemyData.patientRange) or 45
            end
        end)
        
        local safeZ, safeY
        if stats.attackRange <= 0 then
            safeZ = 0
            safeY = 4 
        else
            safeZ = math.clamp(stats.attackRange + 5, 10, stats.maxChase - 5)
            safeY = 15
        end
        
        lastSafeCFrame = CFrame.lookAt(monsterCF * CFrame.new(0, safeY, safeZ).Position, monsterCF.Position)
        hrp.CFrame = lastSafeCFrame
    elseif lastSafeCFrame then
        hrp.CFrame = lastSafeCFrame
    end
end)

-- 🚀 SEQUENTIAL PATROL CHUNK LOADER
task.spawn(function()
    local entitiesPosFolder = workspace:WaitForChild("EntitiesPos")
    pcall(function() settings().Physics.AllowSleep = false end)
    
    local globalSpawnIndex = 1 

    while task.wait(2) do
        if getgenv().AutoFarm and not currentTarget then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp and entitiesPosFolder then
                local validSpawnPoints = {}
                
                if table.find(getgenv().SelectedMonsters, "All") then
                    validSpawnPoints = entitiesPosFolder:GetChildren()
                else
                    for _, monsterName in ipairs(getgenv().SelectedMonsters) do
                        local targetId = MonsterNameToIdMap[monsterName]
                        if targetId then
                            for _, child in ipairs(entitiesPosFolder:GetChildren()) do
                                if child.Name == targetId then
                                    table.insert(validSpawnPoints, child)
                                end
                            end
                        end
                    end
                end
                
                if #validSpawnPoints > 0 then
                    if globalSpawnIndex > #validSpawnPoints then
                        globalSpawnIndex = 1
                    end
                    
                    local currentPatrolSpawn = validSpawnPoints[globalSpawnIndex]
                    if currentPatrolSpawn and (currentPatrolSpawn:IsA("BasePart") or currentPatrolSpawn:IsA("Model")) then
                        local spawnPos = currentPatrolSpawn:GetPivot().Position
                        lastSafeCFrame = CFrame.new(spawnPos + Vector3.new(0, 15, 0))
                        hrp.CFrame = lastSafeCFrame
                        
                        globalSpawnIndex = globalSpawnIndex + 1
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    local skillCounter = 0
    while task.wait(attackDelay) do
        if getgenv().IsBrewingTaskRunning then continue end
        
        if not getgenv().AutoFarm or not currentTarget then continue end
        
        local monsterPos = currentTarget:GetPivot().Position
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local myPos = hrp.Position
        local releaseCF = CFrame.lookAt(myPos, monsterPos)
        local targetCF = CFrame.new(monsterPos) * releaseCF.Rotation
        
        local args = {
            [1] = 4,
            [2] = {
                ["targetCF"] = targetCF,
                ["moveDirectionStr"] = "Forward",
                ["clientPredictCastId"] = HttpService:GenerateGUID(false),
                ["characterType"] = "Player",
                ["releaseCF"] = releaseCF, 
                ["characterId"] = player.UserId,
                ["trackTargetId"] = currentTarget.Name 
            }
        }
        
        pcall(function() releaseGroupSkillEvent:FireServer(unpack(args)) end)
        
        if getgenv().AutoSkill then
            skillCounter = skillCounter + 1
            if skillCounter % 3 == 0 then 
                args[1] = 1
                pcall(function() releaseGroupSkillEvent:FireServer(unpack(args)) end)
            elseif skillCounter % 5 == 0 then 
                args[1] = 2
                pcall(function() releaseGroupSkillEvent:FireServer(unpack(args)) end)
            end
            if skillCounter > 30 then skillCounter = 0 end
        end
    end
end)

-- ============================================================
-- 4. LOGIKA AUTO COLLECT DROPS (MAGNET)
-- ============================================================
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().IsBrewingTaskRunning then continue end
        
        if not getgenv().AutoCollect then continue end
        local dropsFolder = workspace:FindFirstChild("Drops")
        if dropsFolder then
            local myDrops = dropsFolder:FindFirstChild(tostring(player.UserId))
            if myDrops then
                for _, dropValue in ipairs(myDrops:GetChildren()) do
                    if dropValue:IsA("Vector3Value") then
                        pcall(function() generalRemoteEvent:FireServer("pick", dropValue.Name) end)
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- 5. LOGIKA DYNAMIC MATCH INSTANT AUTO SELL
-- ============================================================
local function autoSellProcess()
    if getgenv().IsBrewingTaskRunning then return end
    
    local bagData = PlayerData.GetPlrDataByKey(player, "Bag")
    if not bagData or type(bagData) ~= "table" then return end
    
    local idsToSell = {}
    
    for uniqueID, item in pairs(bagData) do
        if type(item) == "table" and item.id then
            local itemCfg = CfgFind.FindCfgByID(item.id, item.tp)
            if itemCfg and itemCfg.ZhName then
                local translatedName = nil
                pcall(function()
                    if LanguageCfg then
                        translatedName = LanguageCfg.FormatByKey(itemCfg.ZhName)
                    end
                end)
                
                if translatedName and table.find(getgenv().SelectedMaterialsToSell, translatedName) then
                    local dynamicID = item.onlyID or tonumber(uniqueID) or uniqueID
                    table.insert(idsToSell, dynamicID)
                end
            end
        end
    end
    
    if #idsToSell > 0 then
        task.spawn(function()
            pcall(function()
                
                remoteFunction:InvokeServer("\xE5\x87\xBA\xE5\x94\xAE\xE8\x83\x8C\xE5\x8C\x85\xE7\x89\xA9\xE5\x93\x81", {
                    onlyIDList = idsToSell
                })
                
                pcall(function() generalRemoteEvent:FireServer("\xE5\x88\xB7\xE6\x96\xB0\xE5\xBC\x95\xE5\xAF\xBC") end)
            end)
        end)
    end
end

task.spawn(function()
    while task.wait(3) do
        if getgenv().AutoSell then
            autoSellProcess()
        end
    end
end)
