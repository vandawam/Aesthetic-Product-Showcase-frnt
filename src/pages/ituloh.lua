local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local backpack = localPlayer:WaitForChild("Backpack")

local GiftEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteGUI"):WaitForChild("UGiftEvent")

-- ========================================================
-- KONFIGURASI TARGET
-- ========================================================
local TARGET_PLAYER_NAME = "vans_fish8"
local TARGET_UID = 10368399057
local TARGET_ITEM_NAME = "67"
local IMAGE_ASSET = "rbxassetid://91384689290004"

print("🚀 Memulai proses Auto-Gift '" .. TARGET_ITEM_NAME .. "' ke " .. TARGET_PLAYER_NAME .. "...")

-- 1. Pastikan semua barang masuk ke dalam Backpack (tidak ada yang dipegang)
if humanoid then
    humanoid:UnequipTools()
    task.wait(0.5) -- Jeda sebentar memastikan barang masuk ke tas
end

-- 2. Proses pencarian dan pengiriman
local itemTerkirim = 0

for _, tool in ipairs(backpack:GetChildren()) do
    if tool:IsA("Tool") and tool.Name == TARGET_ITEM_NAME then
        -- Mengambil data spesifik dari atribut tool
        local uniqueID = tool:GetAttribute("UniqueID")
        local level = tool:GetAttribute("Level") or 1 -- Default ke 1 jika entah kenapa kosong
        
        if uniqueID then
            -- Menyusun paket data sesuai format RemoteEvent
            local payload = {
                image = IMAGE_ASSET,
                uniqueID = uniqueID,
                playerName = TARGET_PLAYER_NAME,
                level = level,
                brainrotName = TARGET_ITEM_NAME,
                uid = TARGET_UID
            }
            
            -- Eksekusi pengiriman
            GiftEvent:FireServer(payload)
            itemTerkirim = itemTerkirim + 1
            print(string.format("🎁 Mengirim: %s (Lvl %d) | ID: %s", TARGET_ITEM_NAME, level, uniqueID))
            
            -- PENTING: Jeda antar pengiriman agar tidak di-kick oleh Anti-Spam server
            task.wait(0.3)
        else
            warn("⚠️ Gagal mengirim: Atribut 'UniqueID' tidak ditemukan pada salah satu item.")
        end
    end
end

if itemTerkirim > 0 then
    print("🎉 PROSES SELESAI! Berhasil mengirim " .. itemTerkirim .. " buah '" .. TARGET_ITEM_NAME .. "'.")
else
    print("❌ Tidak ada item bernama '" .. TARGET_ITEM_NAME .. "' di dalam tasmu.")
end
