getgenv().Key = "IRPANDM-KEYS"
loadstring(game:HttpGet("http://napoleon-script.my.id/api/script"))()

task.wait(30)
-- ============================================================
--  REJOIN NEW SERVER (Monster Fresh)
--  Cari server lain yang berbeda, biar monster spawn ulang
-- ============================================================

local LocalPlayer = game:GetService("Players").LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local placeId = game.PlaceId
local currentJobId = game.JobId

local queueFunc = queue_on_teleport
    or queueonteleport
    or (syn and syn.queue_on_teleport)

-- (Opsional) Script yang dijalankan setelah rejoin
local scriptSetelahRejoin = [[
    -- Isi script auto-run setelah rejoin di sini
]]

-- ─── CARI SERVER YANG BERBEDA ───
local function getNewServer()
    local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"

    local ok, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if not ok or not result or not result.data then
        warn("[Rejoin] Gagal ambil list server. Fallback ke Teleport biasa.")
        return nil
    end

    -- Cari server lain yang bukan server kita sekarang
    for _, server in ipairs(result.data) do
        if server.id ~= currentJobId and server.playing < server.maxPlayers then
            return server.id
        end
    end

    warn("[Rejoin] Tidak ada server lain yang tersedia.")
    return nil
end

-- ─── EKSEKUSI ───
print("[Rejoin] Mencari server baru (bukan server saat ini)...")

local targetJobId = getNewServer()

if queueFunc and scriptSetelahRejoin:match("%S") then
    queueFunc(scriptSetelahRejoin)
    print("[Rejoin] Script dititipkan ke teleport queue.")
end

if targetJobId then
    print("[Rejoin] Ditemukan server lain! Teleport ke JobId: " .. targetJobId)
    TeleportService:TeleportToPlaceInstance(placeId, targetJobId, LocalPlayer)
else
    -- Fallback: paksa masuk public server baru
    print("[Rejoin] Masuk ke public server baru...")
    local ok2, err = pcall(function()
        local options = Instance.new("TeleportOptions")
        options.ShouldReserveServer = false
        TeleportService:TeleportAsync(placeId, {LocalPlayer}, options)
    end)

    if not ok2 then
        warn("[Rejoin] Fallback terakhir: Teleport biasa. Error: " .. tostring(err))
        TeleportService:Teleport(placeId, LocalPlayer)
    end
end
