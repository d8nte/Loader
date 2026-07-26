-- =============================================
-- INDO VOICE HUB - OFFICIAL LOADER (WITH UNIVERSAL FALLBACK)
-- =============================================

local HUB_NAME      = "Indo Voice"
local VERSION       = "1.2"
local UNIVERSAL_URL = "https://raw.githubusercontent.com/d8nte/all_games/refs/heads/main/Universal.lua"

-- Daftar Game Spesifik (Bisa diisi GameId atau PlaceId)
local games = {
    -- [ID_GAME] = "URL_RAW_GITHUB",
    [3198546127]  = "https://raw.githubusercontent.com/d8nte/all_games/refs/heads/main/IndoVoice.lua",
}

local StarterGui = game:GetService("StarterGui")

-- Fungsi Notifikasi In-Game
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 4
        })
    end)
end

-- Deteksi ID Game Player
local universeId = game.GameId
local placeId    = game.PlaceId

-- 1. Cari Script Khusus Game
local targetRawURL = games[universeId] or games[placeId]
local isUniversal  = false

-- 2. Filtering Fallback: Jika game tidak terdaftar, otomatis alihkan ke Universal.lua
if not targetRawURL then
    targetRawURL = UNIVERSAL_URL
    isUniversal = true
end

-- 3. Tambahkan Parameter Anti-Cache
local scriptURL = targetRawURL .. "?v=" .. tick()

-- 4. Pesan Status Log & Notifikasi
print(string.format("[%s v%s] PlaceId: %d | UniverseId: %d", HUB_NAME, VERSION, placeId, universeId))

if isUniversal then
    notify(HUB_NAME, "Game belum terdaftar. Memuat Script Universal...", 4)
    print(string.format("[%s] Game tidak terdaftar di database. Loading Universal Script...", HUB_NAME))
else
    notify(HUB_NAME, "Game terdeteksi! Memuat Script Khusus...", 4)
    print(string.format("[%s] Game Supported! Loading Script Khusus Game...", HUB_NAME))
end

-- 5. Fetch & Eksekusi Script
local success, errorMessage = pcall(function()
    local rawCode = game:HttpGet(scriptURL)
    local loadedFunc, parseErr = loadstring(rawCode)
    
    if not loadedFunc then
        error("Syntax Error: " .. tostring(parseErr))
    end
    
    loadedFunc()
end)

-- 6. Status Evaluasi Akhir
if success then
    print(string.format("[%s] Script berhasil dimuat!", HUB_NAME))
    notify(HUB_NAME, isUniversal and "Universal Script Dimuat!" or "Script Game Dimuat!", 4)
else
    warn(string.format("[%s] Gagal memuat script: %s", HUB_NAME, tostring(errorMessage)))
    notify(HUB_NAME .. " Error", "Gagal load script! Cek Console (F12).", 6)
end
