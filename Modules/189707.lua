--[[ Game: Natural Disaster Survival ]]
local GuiLibrary = shared.Rise.GuiLibrary

local fling = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.CreateModule({
    Name = "189707fling",
    Function = function(value)
    end
})

local flingMode = fling.CreateModeValue({
    Value = 1,
    Options = {"Normal", "Fly", "Walk"}
})