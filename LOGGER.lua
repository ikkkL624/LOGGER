local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local webhook = "https://discord.com/api/webhooks/1468452703750459485/rfBQ39YMYJee9cqYcb-QhpKnzZlQ_i09XnR5PX_9uIra5czPQifwrNFhl41u7uy6CY51"  -- ← cambia esto

local function getExecutorName()
    if syn then return "Synapse X" end
    if fluxus then return "Fluxus" end
    if getexecutorname then return getexecutorname() end
    if identifyexecutor then return identifyexecutor() end
    return "Delta / Unknown"
end

local data = {
    ["content"] = nil,
    ["embeds"] = {{
        ["title"] = "Nuevo usuario ejecutó tu script",
        ["color"] = 16711680, -- rojo
        ["fields"] = {
            {["name"] = "Usuario",      ["value"] = Players.LocalPlayer.Name .. " (ID: " .. Players.LocalPlayer.UserId .. ")", ["inline"] = true},
            {["name"] = "DisplayName",  ["value"] = Players.LocalPlayer.DisplayName, ["inline"] = true},
            {["name"] = "Executor",     ["value"] = getExecutorName(), ["inline"] = true},
            {["name"] = "Lugar",        ["value"] = game.PlaceId .. " (" .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. ")", ["inline"] = false},
            {["name"] = "JobId / Server", ["value"] = game.JobId, ["inline"] = false},
            {["name"] = "Tiempo",       ["value"] = os.date("%Y-%m-%d %H:%M:%S", os.time() + -6*3600), ["inline"] = true}, -- CST México
            {["name"] = "Membresía",    ["value"] = Players.LocalPlayer.MembershipType.Name, ["inline"] = true},
        },
        ["footer"] = {["text"] = "MONARCA script logger • " .. os.date("%H:%M CST")},
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ", os.time())
    }}
}

local success, err = pcall(function()
    local req = request or http_request or HttpService.PostAsync
    req(
        webhook,
        HttpService:JSONEncode(data),
        Enum.HttpContentType.ApplicationJson
    )
end)

if not success then
    -- opcional: intento fallback a Pastebin o algo, pero casi nunca hace falta
    warn("Logger falló: " .. tostring(err))
end
