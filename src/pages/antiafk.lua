-- ============================================================
-- ANTI-AFK UNIVERSAL (NON-INTRUSIVE)
-- ============================================================

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Menyambungkan fungsi ke event 'Idled' bawaan Roblox
LocalPlayer.Idled:Connect(function()
    -- Mengambil alih kontrol virtual sejenak
    VirtualUser:CaptureController()
    
    -- Mengirimkan sinyal klik kanan (ClickButton2) di titik (0,0)
    -- Ini cukup untuk mereset timer AFK tanpa membuat karakter bergerak
    VirtualUser:ClickButton2(Vector2.new())
    
    print("[Napoleon] Anti-AFK bekerja: Mencegah disconnect.")
end)

-- Memunculkan notifikasi agar kamu tahu scriptnya sudah aktif
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Napoleon",
        Text = "Anti-AFK Universal telah aktif! Kamu tidak akan di-kick.",
        Duration = 5,
    })
end)

print("[Napoleon] Anti-AFK Universal Berhasil Diaktifkan!")
