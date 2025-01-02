if getgenv and not getgenv().shared then
    getgenv().shared = {}
end
if shared.RiseExecuted then
    return
end
shared.RiseExecuted = true

shared.Rise = {
    Fonts = {}
}

for _, v in pairs({"Rise", "Rise/Assets", "Rise/Configs", "Rise/Assets/Fonts", "Rise/Assets/Interface"}) do
    if not isfolder(v) then
        makefolder(v)
    end
end

local geturl = function(p)
    local customurl = "https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/" .. p
    if shared.RiseDeveloper and shared.RiseUrls[p] then
        customurl = shared.RiseUrls[p]
    end
    local suc, res = pcall(function()
        return game:HttpGet(customurl)
    end)
    if not suc or res == "404: Not Found" then
        error("❌ Failed to load rise file : rise/" .. p)
    end
    return res
end

local gui = "Modern"
shared.Rise.GuiLibrary = loadstring(geturl("Libraries/Gui.lua"))()
--[[pcall(function()
    request {
        Url = "https://rise-for-roblox.glitch.me/api/v1/execute",
        Method = "POST"
    } -- wow Solara HttpGet doesnt throw but this does "attempt to index nil with find" :nerd:
end)]]

local sx, fx = pcall(function()
    return geturl("Modules/" .. game.PlaceId .. ".lua")
end)

local function wt()
    shared.Rise.GuiLibrary["CreateNotification"]({
        Duration = 5,
        Title = "Rise Client",
        Text = "Rise is not supported in this game."
    })
end

if sx and fx ~= "404: Not Found" then
    loadstring(fx)()
end
shared.Rise.GuiLibrary.Loaded = false
shared.Rise.GuiLibrary.LoadSettings()
shared.Rise.GuiLibrary.Events.UpdateShaderEvents:Fire()
shared.Rise.GuiLibrary.Events.UpdateLanguageEvent:Fire()
shared.Rise.GuiLibrary.Loaded = true
shared.RiseUAL()

shared.Rise.Chat.PushRiseMessage("Press " .. (shared.Rise.GuiLibrary.MainSettings.ClickGUIKeybind or "NONE") .. " to open Click GUI")

if shared.Rise.Chat["GameNoChat"] then
    shared.Rise.Chat.PushRiseMessage("This game has chat (temporarily / permanently) disabled. Send messages at your own risk.")
end
if not sx or fx == "404: Not Found" then
    wt()
end
