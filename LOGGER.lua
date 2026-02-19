-- MONARCA LOGGER v2.1 - Corregido febrero 2026
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- WEBHOOK (solo cámbialo aquí si quieres nuevo)
local WEBHOOK_ID = "1468452703750459485"
local WEBHOOK_TOKEN = "rfBQ39YMYJee9cqYcb-QhpKnzZlQ_i09XnR5PX_9uIra5czPQifwrNFhl41u7uy6CY51"
local originalWebhook = "https://discord.com/api/webhooks/1468452703750459485/rfBQ39YMYJee9cqYcb-QhpKnzZlQ_i09XnR5PX_9uIra5czPQifwrNFhl41u7uy6CY51"

-- Proxies actualizados 2026
local PROXIES = {
    "webhook.lewisakura.moe",
    "webhook.newstargeted.com",
    "hook.proximatech.us"
}

local lastSend = 0
local COOLDOWN = 0.8  -- evita rate limit

local function getRandomProxy()
    return PROXIES[math.random(1, #PROXIES)]
end

local function getExecutorName()
    if syn then return "Synapse X" end
    if fluxus then return "Fluxus" end
    if Krnl then return "Krnl" end
    if identifyexecutor then return identifyexecutor() or "Unknown" end
    if getexecutorname then return getexecutorname() or "Unknown" end
    return "Unknown Executor"
end

local function sendLog(eventType, extraData)
    if os.clock() - lastSend < COOLDOWN then return end
    lastSend = os.clock()

    local player = Players.LocalPlayer
    if not player then return end

    local placeName = "Desconocido"
    pcall(function() placeName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)

    local proxyDomain = getRandomProxy()
    local webhook = originalWebhook:gsub("discord%.com", proxyDomain)

    local embed = {
        title = "🔔 " .. eventType .. " - MYSTERY HUB | MONARCA",
        color = 16711680,
        fields = {
            {name = "Usuario", value = player.Name .. " (ID: `" .. player.UserId .. "`)", inline = true},
            {name = "Display", value = player.DisplayName or "N/A", inline = true},
            {name = "Executor", value = getExecutorName(), inline = true},
            {name = "Juego", value = game.PlaceId .. " - " .. placeName, inline = false},
            {name = "JobId", value = "`" .. game.JobId .. "`", inline = false},
            {name = "Evento", value = eventType, inline = true},
            {name = "Tiempo (CST)", value = os.date("%Y-%m-%d %H:%M:%S", os.time() - 6*3600), inline = true},
            {name = "Membresía", value = tostring(player.MembershipType or "Unknown"), inline = true},
        },
        footer = {text = "MONARCA • Mystery Hub • " .. os.date("%H:%M CST")},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    if extraData then
        for key, value in pairs(extraData) do
            table.insert(embed.fields, {name = key, value = tostring(value), inline = true})
        end
    end

    local data = {embeds = {embed}}

    local success, result = pcall(function()
        local body = HttpService:JSONEncode(data)
        return HttpService:PostAsync(webhook, body, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("[MONARCA] ✅ Enviado '" .. eventType .. "' vía " .. proxyDomain)
    else
        warn("[MONARCA] ❌ Falló '" .. eventType .. "': " .. tostring(result))
    end
end

getgenv().MonarcaLog = sendLog
getgenv().MonarcaLoggerLoaded = true

print("[MONARCA] Logger v2.1 cargado! Prueba: MonarcaLog('Test')")
