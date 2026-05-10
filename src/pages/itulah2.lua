local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local backpack = localPlayer:WaitForChild("Backpack")

local GiftEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteGUI"):WaitForChild("UGiftEvent")

-- ========================================================
-- KONFIGURASI TARGET
-- ========================================================
local TARGET_PLAYER_NAME = "vans_fish9"
local TARGET_UID = 10368392661
local TARGET_ITEM_NAME = "67"
local IMAGE_ASSET = "rbxassetid://91384689290004"

print("🚀 Memulai proses Auto-Gift (Equip Mode) ke " .. TARGET_PLAYER_NAME .. "...")

-- 1. Kosongkan tangan terlebih dahulu untuk menormalkan status
if humanoid then
    humanoid:UnequipTools()
    task.wait(0.5) 
end

-- 2. Kumpulkan daftar barang target ke dalam memori
-- (Penting agar urutan tidak rusak saat barang dipindah ke tangan)
local toolsToGift = {}
for _, tool in ipairs(backpack:GetChildren()) do
    if tool:IsA("Tool") and tool.Name == TARGET_ITEM_NAME then
        table.insert(toolsToGift, tool)
    end
end

-- 3. Proses Pegang -> Kirim -> Ulangi
local itemTerkirim = 0

for _, targetTool in ipairs(toolsToGift) do
    -- Pastikan barangnya belum terhapus/hilang oleh sistem game
    if targetTool and targetTool.Parent then
        
        -- A. Pegang (Equip) barangnya
        humanoid:EquipTool(targetTool)
        
        -- Tunggu sampai barang benar-benar berpindah ke tangan dan di-render
        task.wait(0.1) 
        
        -- B. Ambil Atribut
        local uniqueID = targetTool:GetAttribute("UniqueID")
        local level = targetTool:GetAttribute("Level") or 1 
        
        if uniqueID then
            local payload = {
                image = IMAGE_ASSET,
                uniqueID = uniqueID,
                playerName = TARGET_PLAYER_NAME,
                level = level,
                brainrotName = TARGET_ITEM_NAME,
                uid = TARGET_UID
            }
            
            -- C. Eksekusi pengiriman via RemoteEvent
            GiftEvent:FireServer(payload)
            itemTerkirim = itemTerkirim + 1
            print(string.format("🎁 Dipegang & Dikirim: %s (Lvl %d) | ID: %s", TARGET_ITEM_NAME, level, uniqueID))
            
            -- D. Jeda ekstra agar server sempat memproses pengiriman dan menghapus barang dari tanganmu
            task.wait(0.1) 
        else
            warn("⚠️ Atribut 'UniqueID' tidak ditemukan pada salah satu item.")
            -- Jika gagal, lepaskan barang agar tangan kosong untuk iterasi berikutnya
            humanoid:UnequipTools()
            task.wait(0.2)
        end
    end
end

if itemTerkirim > 0 then
    print("🎉 PROSES SELESAI! Berhasil mengirim " .. itemTerkirim .. " buah '" .. TARGET_ITEM_NAME .. "'.")
    -- Bersihkan tangan jika masih ada barang yang tersangkut
    humanoid:UnequipTools()
else
    print("❌ Tidak ada item bernama '" .. TARGET_ITEM_NAME .. "' di dalam tasmu.")
end
