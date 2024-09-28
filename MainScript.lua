if not game.Loaded then
    game.Loaded:Wait()
end
local function loadscript(url)
    if shared.RiseDeveloper then
        if isfile("rise/" .. url) then
            return readfile("rise/" .. url)
        end
    end
    local suc, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/" .. url, true)
    end)
    if not suc or res == "404: Not Found" then
        error("Rise >> Failed to execute loadscript()")
    end
    return res
end
assert(not shared.VapeExecuted, "Rise >> Rise is incompatible with VapeV4ForRoblox.")
assert(not shared.RiseExecuted, "Rise >> Rise 6 already injected")
shared.RiseExecuted = true
for i, v in pairs({"rise", "rise/assets", "rise/configs", "rise/scripts"}) do
    if not isfolder(v) then
        makefolder(v)
    end
end
shared.Rise = loadstring(loadscript("RiseService.lua"))()
local GuiLibrary = loadstring(loadscript("GuiLibrary.lua"))()
if not GuiLibrary.Loaded then
    repeat
        task.wait()
    until GuiLibrary.Loaded
    GuiLibrary.UpdateHudEvent:Fire()
    GuiLibrary.ShowNotification("Rise 6", "Rise loaded. Press " .. GuiLibrary.Settings.Keybind .. " to open Click GUI",
        3)
end
shared.RiseGUI = GuiLibrary
