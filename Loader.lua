-- =============================================
-- INDO VOICE HUB - FIXED LOADER WITH DEBUG
-- =============================================

local HUB_NAME      = "Indo Voice"
local VERSION       = "1.3"

-- Gunakan format URL ringkas & stabil (tanpa refs/heads/)
local UNIVERSAL_URL = "https://raw.githubusercontent.com/d8nte/all_games/main/Universal.lua"

local games = {
    -- [ID_GAME] = "URL_RAW_GITHUB",
    [3198546127]  = "https://raw.githubusercontent.com/d8nte/all_games/main/IndoVoice.lua",
    [9691752199]  = "https://raw.githubusercontent.com/d8nte/all_games/main/Sawah_Indo.lua",
    [7326934954]  = "https://raw.githubusercontent.com/d8nte/all_games/main/99_nitf.lua",
}

local StarterGui = game:GetService("StarterGui")

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 4
        })
    end)
end

-- Ambil ID Game
local universeId = game.GameId
local placeId    = game.PlaceId

print("--------------------------------------------------")
print(string.format("[%s Loader Debug] PlaceId: %d | UniverseId: %d", HUB_NAME, placeId, universeId))

-- Pengecekan Target URL
local targetRawURL = games[universeId] or games[placeId]
local isUniversal  = false

if not targetRawURL then
    targetRawURL = UNIVERSAL_URL
    isUniversal  = true
    print(string.format("[%s Loader Debug] ID tidak terdaftar -> Menggunakan UNIVERSAL_URL", HUB_NAME))
else
    print(string.format("[%s Loader Debug] ID terdaftar -> Menggunakan SCRIPT KHUSUS GAME", HUB_NAME))
end

-- Pasang Parameter Anti-Cache
local finalURL = targetRawURL .. "?v=" .. tick()
print(string.format("[%s Loader Debug] Final Fetch URL: %s", HUB_NAME, finalURL))

-- Notifikasi Layar
notify(HUB_NAME, isUniversal and "Memuat Script Universal..." or "Memuat Script Khusus...", 3)

-- Fetching Script
local fetchSuccess, rawCode = pcall(function()
    return game:HttpGet(finalURL)
end)

if not fetchSuccess then
    warn(string.format("[%s Loader Error] Gagal mengunduh file dari GitHub! Cek link URL.", HUB_NAME))
    notify(HUB_NAME .. " Error", "Gagal mengunduh dari GitHub! Cek F12.", 5)
    return
end

-- Compile Script
local loadedFunc, parseErr = loadstring(rawCode)

if not loadedFunc then
    warn(string.format("[%s Loader Error] Syntax Error di file GitHub: %s", HUB_NAME, tostring(parseErr)))
    notify(HUB_NAME .. " Error", "Syntax error di file script! Cek F12.", 5)
    return
end

-- Eksekusi Script
local execSuccess, execErr = pcall(loadedFunc)

if execSuccess then
    print(string.format("[%s Loader Success] Script (%s) Berhasil Dijalankan!", HUB_NAME, isUniversal and "Universal" or "Game Specific"))
    notify(HUB_NAME, "Berhasil Dimuat!", 4)
else
    warn(string.format("[%s Loader Error] Runtime Error saat menjalankan script: %s", HUB_NAME, tostring(execErr)))
    notify(HUB_NAME .. " Error", "Runtime Error! Cek Console F12.", 5)
end
print("--------------------------------------------------")
