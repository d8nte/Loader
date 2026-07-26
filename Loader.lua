-- =============================================
-- INDO VOICE HUB - OFFICIAL MULTI-GAME LOADER
-- =============================================

local HUB_NAME = "Indo Voice"
local VERSION  = "1.0"

-- Daftar Game yang didukung (Bisa diisi GameId atau PlaceId)
local games = {
    -- [ID_GAME] = "URL_RAW_GITHUB",
    [3198546127]  = "https://raw.githubusercontent.com/d8nte/all_games/refs/heads/main/IndoVoice.lua",
    -- Tambahkan Game ID / Place ID lainnya di sini
}

local StarterGui = game:GetService("StarterGui")

-- Fungsi Notifikasi
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 4
        })
    end)
end

-- Deteksi ID Game Player Saat Ini
local universeId = game.GameId
local placeId    = game.PlaceId

-- Cari match berdasarkan GameId terlebih dahulu, jika tidak ada coba PlaceId
local targetRawURL = games[universeId] or games[placeId]

print(string.format("[%s v%s] PlaceId: %d | UniverseId: %d", HUB_NAME, VERSION, placeId, universeId))

if targetRawURL then
    -- Pasang parameter anti-cache agar selalu mengunduh versi commit terbaru dari GitHub
    local scriptURL = targetRawURL .. "?v=" .. tick()

    notify(HUB_NAME, "Game terdeteksi! Memuat script...", 3)
    print(string.format("[%s] Game supported! Loading script dari GitHub...", HUB_NAME))

    -- Fetch & Eksekusi Script dengan pcall
    local success, errorMessage = pcall(function()
        local rawCode = game:HttpGet(scriptURL)
        local loadedFunc, parseErr = loadstring(rawCode)
        
        if not loadedFunc then
            error("Syntax Error dalam file Lua: " .. tostring(parseErr))
        end
        
        loadedFunc()
    end)

    -- Status Hasil Load
    if success then
        print(string.format("[%s] Script berhasil dimuat sepenuhnya!", HUB_NAME))
        notify(HUB_NAME, "Script Berhasil Dimuat!", 4)
    else
        warn(string.format("[%s] Gagal memuat script: %s", HUB_NAME, tostring(errorMessage)))
        notify(HUB_NAME .. " Error", "Gagal load script! Cek Console (F12).", 6)
    end
else
    -- Jika Game Belum Didukung
    local msg = string.format("Game belum didukung!\nPlaceId: %d | UniverseId: %d", placeId, universeId)
    warn(string.format("[%s] %s", HUB_NAME, msg))
    notify(HUB_NAME, "Game belum didukung!", 5)
end