-- MONARCA LOGGER v2.0 - Modular y listo para cualquier script
-- Pégalo UNA VEZ al inicio de tu HUB principal

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- TU WEBHOOK (cámbialo solo aquí)
local WEBHOOK_ID = "1468452703750459485"
local WEBHOOK_TOKEN = "rfBQ39YMYJee9cqYcb-QhpKnzZlQ_i09XnR5PX_9uIra5czPQifwrNFhl41u7uy6CY51"

-- Proxy ACTIVO en 2026 (lewisakura sigue vivo, pero con alternas)
local PROXIES = {
    "webhook.lewisakura.moe",      -- Principal (estable)
    "hook.proximatech.us",         -- Backup 1 (Proxima's, muy bueno)
    "hooks.hyra.io"                -- Backup 2 (si los otros fallan)
}

local originalWebhook = "https://discord.com/api/webhooks/1468452703750459485/rfBQ39YMYJee9cqYcb-QhpKnzZlQ_i09XnR5PX_9uIra5czPQifwrNFhl41u7uy6CY51
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

-- FUNCIÓN PRINCIPAL: Envía el log
local function sendLog(eventType, extraData)
    local player = Players.LocalPlayer
    if not player then return end -- No player? No log
    
    local placeName = "Desconocido"
    pcall(function() placeName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    
    local proxyDomain = getRandomProxy()
    local webhook = originalWebhook:gsub("discord%.com", proxyDomain)
    
    local embed = {
        title = "🔔 " .. eventType .. " - MYSTERY HUB | MONARCA",
        color = 16711680, -- Rojo
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
    
    -- Agrega datos extra si los pasas
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
        print("[MONARCA] ✅ Enviado '" .. eventType .. "' vía " .. proxyDomain .. " → " .. result)
    else
        warn("[MONARCA] ❌ Falló '" .. eventType .. "': " .. tostring(result))
    end
end

-- LO HACE GLOBAL: Ahora úsalo desde CUALQUIER SCRIPT
getgenv().MonarcaLog = sendLog
getgenv().MonarcaLoggerLoaded = true

print("[MONARCA] Logger cargado! Usa MonarcaLog('MiEvento', {clave: 'valor'})")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MONARCA26X/LIBRER-A/refs/heads/main/GNIK-INKGG", true))()

local player = game.Players.LocalPlayer
local displayName = player.DisplayName or player.Name

local window = library:AddWindow("The Strongest Rework | SERVERUS |  Hello " .. displayName, {
    main_color = Color3.fromRGB(50, 50, 190),
    min_size = Vector2.new(650, 870),
    can_resize = true,
})
