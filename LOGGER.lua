-- MONARCA Logger con proxy (funciona en Delta 2026)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- TU WEBHOOK REAL (sin cambiar nada aquí, solo el dominio)
local originalWebhook = "https://discord.com/api/webhooks/1468452703750459485/rfBQ39YMYJee9cqYcb-QhpKnzZlQ_i09XnR5PX_9uIra5czPQifwrNFhl41u7uy6CY51"

-- Proxy: Reemplaza discord.com → webhook.lewisakura.moe
local proxyDomain = "webhook.lewisakura.moe"
local webhook = originalWebhook:gsub("discord%.com", proxyDomain)  -- cambia automáticamente el dominio

local function getExecutorName()
    if syn then return "Synapse X" end
    if fluxus then return "Fluxus" end
    if Krnl then return "Krnl" end
    if identifyexecutor then 
        local ex = identifyexecutor()
        return ex or "Unknown (identify)"
    end
    if getexecutorname then 
        local ex = getexecutorname()
        return ex or "Unknown (getname)"
    end
    if getgenv and getgenv().Delta then return "Delta" end
    return "Delta / Unknown Executor"
end

local player = Players.LocalPlayer or game.Players:WaitForChild("LocalPlayer", 10)  -- espera si tarda
local placeName = "Desconocido"
pcall(function()
    placeName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local data = {
    ["content"] = nil,
    ["embeds"] = {{
        ["title"] = "🔔 Nuevo uso - MYSTERY HUB | MONARCA",
        ["color"] = 16711680, -- rojo
        ["fields"] = {
            {["name"] = "Usuario",      ["value"] = player.Name .. " (ID: `" .. player.UserId .. "`)", ["inline"] = true},
            {["name"] = "Display",      ["value"] = player.DisplayName or "N/A", ["inline"] = true},
            {["name"] = "Executor",     ["value"] = getExecutorName(), ["inline"] = true},
            {["name"] = "Juego",        ["value"] = game.PlaceId .. " - " .. placeName, ["inline"] = false},
            {["name"] = "JobId",        ["value"] = "`" .. game.JobId .. "`", ["inline"] = false},
            {["name"] = "Tiempo (CST)", ["value"] = os.date("%Y-%m-%d %H:%M:%S", os.time() - 6*3600), ["inline"] = true},
            {["name"] = "Membresía",    ["value"] = player.MembershipType.Name, ["inline"] = true},
        },
        ["footer"] = {
            ["text"] = "MONARCA • Mystery Hub • " .. os.date("%H:%M CST")
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}
}

-- Intento múltiple + debug
local success, err = pcall(function()
    local methods = {request, http_request, syn and syn.request, HttpService.PostAsync}
    local body = HttpService:JSONEncode(data)
    
    for _, method in ipairs(methods) do
        if method then
            print("[MONARCA DEBUG] Intentando con método: " .. tostring(method))  -- debug en consola
            method(webhook, body, Enum.HttpContentType.ApplicationJson)
            print("[MONARCA DEBUG] Enviado vía proxy!")  -- si llega aquí, salió bien
            return
        end
    end
    error("No hay método de request disponible")
end)

if not success then
    warn("[MONARCA LOGGER] Falló el envío: " .. tostring(err))
    print("[MONARCA DEBUG ERROR] " .. tostring(err))
end

getgenv().MonarcaLoggerLoaded = true
