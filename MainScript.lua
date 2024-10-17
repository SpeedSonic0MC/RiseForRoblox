local function loadscript(url, e)
    if shared.RiseDeveloper then
        if isfile("rise/" .. url) then
            return readfile("rise/" .. url)
        end
    end
    local suc, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/" .. url)
    end)
    if not suc or res == "404: Not Found" then
        print("Rise >> Failed to execute loadscript()")
    end
    return res
end
assert(not shared.VapeExecuted, "Rise >> Rise is incompatible with VapeV4ForRoblox.")
assert(not shared.RiseExecuted, "Rise >> Rise 6 already injected")
shared.RiseExecuted = true
task.spawn(function()
    for i, v in pairs({"rise", "rise/assets", "rise/configs", "rise/scripts"}) do
        if not isfolder(v) then
            makefolder(v)
        end
    end
end)
local oldtick = tick()
shared.Rise = loadstring(loadscript("RiseService.lua"))()
local scr = loadscript("GuiLibrary.lua")
local newtick = tick()
local GuiLibrary = loadstring(scr)()
print("Rise >> Used " .. tostring(newtick - oldtick) .. " seconds to initiate GuiLibrary and Rise Services")
if not GuiLibrary["Loaded"] then
    repeat
        task.wait()
    until GuiLibrary["Loaded"] == true
end
local suc, res = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/game/" .. game.PlaceId ..
                            ".lua", true)
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
