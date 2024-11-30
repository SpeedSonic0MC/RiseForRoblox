if getgenv and not getgenv().shared then
    getgenv().shared = {}
end
assert(not shared.RiseExecuted, "💢 Rise already injected!")
shared.RiseExecuted = true

shared.Rise = {
    Fonts = {}
}

local httpService = game:GetService("HttpService")

print("✨ Running rise")
print("🌟 Checking rise folders")
for _, v in pairs({"Rise", "Rise/Assets", "Rise/Configs", "Rise/Assets/Fonts", "Rise/Assets/Interface"}) do
    if not isfolder(v) then
        makefolder(v)
        print("⚠️ Created rise folder : " .. v)
    end
end

print("💬 Checking rise fonts")
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
            getcustomasset("Rise/Assets/Fonts/" .. v)
            print("🥰 Successfully downloaded font : " .. _2)
        end
    end
    if not isfile("Rise/Assets/Fonts/" .. string.sub(v, 1, -5) .. ".json") then
        writefile("Rise/Assets/Fonts/" .. string.sub(v, 1, -5) .. ".json", httpService:JSONEncode({
            name = _2,
            faces = {{
                name = "Regular",
                weight = 300,
                style = "normal",
                assetId = "rbxasset://Rise/Assets/Fonts/" .. v
            }}
        }))
    end
    shared.Rise.Fonts[_2] = Font.new(getcustomasset("Rise/Assets/Fonts/" .. string.sub(v, 1, -5) .. ".json"))
end

local geturl = function(p)
    local customurl = "https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/" .. p
    if shared.RiseDeveloper and shared.RiseUrls[p] then
        print("✅ [DEBUG] : Loaded custom file for Rise : rise/" .. p)
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
print("✨ Loaded Rise GUI")
