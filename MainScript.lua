if not game.Loaded then
    game.Loaded:Wait()
end
local function loadscript(url, e)
    if shared.RiseDeveloper then
        if isfile("rise/" .. url) then
            return readfile("rise/" .. url)
        end
    end
    local suc, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/" .. url, true)
    end)
    if not suc or res == "404: Not Found" then
        print("Rise >> Failed to execute loadscript()")
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
if GuiLibrary.Loaded == false then
    repeat
        task.wait()
    until GuiLibrary.Loaded == true
end
local suc, res = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/game/" .. game.PlaceId .. ".lua", true)
end)
if not suc or res == "404: Not Found" then
    print("Rise >> Rise is incompatible with this game currently. Be back soon!")
else
    loadstring(res)()
end
GuiLibrary.LoadSettings(shared.CustomRiseSave)
local savesettingsloop = coroutine.create(function()
    repeat
        GuiLibrary.SaveSettings()
        task.wait(10)
    until GuiLibrary == nil
end)
GuiLibrary.UpdateHudEvent:Fire()
GuiLibrary.ShowNotification("Rise 6", "Rise loaded. Press " .. GuiLibrary.Settings.Keybind .. " to open Click GUI", 3)
coroutine.resume(savesettingsloop)
shared.RiseGUI = GuiLibrary
