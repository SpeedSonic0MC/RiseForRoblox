if getgenv and not getgenv().shared then
    getgenv().shared = {}
end
if shared.RiseExecuted then return end
shared.RiseExecuted = true

shared.Rise = {
    Fonts = {}
}

local httpService = game:GetService("HttpService")

for _, v in pairs({"Rise", "Rise/Assets", "Rise/Configs", "Rise/Assets/Fonts", "Rise/Assets/Interface"}) do
    if not isfolder(v) then
        makefolder(v)
    end
end

for _, v in pairs({"Elegant-Font.ttf", "Icon-Font.ttf", "SF-Pro-Rounded-Bold.otf", "SF-Pro-Rounded-Light.otf",
                   "SF-Pro-Rounded-Medium.otf", "SF-Pro-Rounded-Regular.otf"}) do
    local _1 = string.gsub(v, "-", " ")
    local _2 = string.sub(_1, 1, -5) -- Name of font (Elegant-Font.ttf -> "Elegant Font")'
    if not isfile("Rise/Assets/Fonts/" .. v) then
        local suc, res = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/Assets/Fonts/" .. v)
        end)
        if not suc or res == "404: Not Found" then
            error("❌ Failed to download font file : " .. _2)
        else
            writefile("Rise/Assets/Fonts/" .. v, res)
            if not isfile("Rise/Assets/Fonts/" .. v) then
                repeat
                    task.wait()
                until isfile("Rise/Assets/Fonts/" .. v)
            end -- codex its just one update and you broke it already
        end
    end
    if not isfile("Rise/Assets/Fonts/" .. string.sub(v, 1, -5) .. ".json") then
        writefile("Rise/Assets/Fonts/" .. string.sub(v, 1, -5) .. ".json", httpService:JSONEncode({
            name = _2,
            faces = {{
                name = "Regular",
                weight = 300,
                style = "normal",
                assetId = getcustomasset("Rise/Assets/Fonts/" .. v) -- it was supposed to work :sob: codex wtf did you do :rofl:
            }}
        }))
        repeat
            task.wait()
        until isfile("Rise/Assets/Fonts/" .. string.sub(v, 1, -5) .. ".json")
    end
    shared.Rise.Fonts[_2] = Font.new(getcustomasset("Rise/Assets/Fonts/" .. string.sub(v, 1, -5) .. ".json"))
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

shared.Rise.GuiLibrary = loadstring(geturl("Libraries/Gui.lua"))()
pcall(function()
    request {
        Url = "https://rise-for-roblox.glitch.me/api/v1/execute",
        Method = "POST"
    } -- wow Solara HttpGet doesnt throw but this does "attempt to index nil with find" :nerd:
end)

local suc, fx = pcall(function()
    return geturl("Modules/" .. game.PlcaeId .. ".lua")
end)

if not suc or fx == "404: Not Found" then
    print("ℹ️ Rise is not supported in this game.")
else
    loadstring(fx)()
end

shared.Rise.GuiLibrary.LoadSettings()
shared.Rise.GuiLibrary.Events.UpdateShaderEvents:Fire()

shared.Rise.GuiLibrary["CreateNotification"]({
    Duration = 5,
    Title = "Rise Client",
    Text = "Rise Loaded. Press " .. shared.Rise.GuiLibrary.MainSettings.ClickGUIKeybind .. " to open Click GUI"
})
local suc, wldata = pcall(function()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    hwid = hwid:gsub("-", ""):lower()
    return game:HttpGet("https://rise-for-roblox.glitch.me/api/v1/check_whitelist/" .. hwid)
end)
pcall(function()
    if suc then
        local json = httpService:JSONDecode(wldata)
        if json.whitelist then
            shared.Rise.GuiLibrary["CreateNotification"]({
                Duration = 5;
                Title = "HWID Whitelist",
                Text = "You are whitelisted. Use .wl help for more info."
            })
        end
    end
end)
