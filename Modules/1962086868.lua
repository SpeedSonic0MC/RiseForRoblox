--[[ Tower of Hell ]] --
local GuiLibrary = shared.Rise.GuiLibrary
local playersService = game:GetService "Players"
local lplr = playersService.LocalPlayer

local tptof
tptof = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.CreateModule({
    Name = "tptofinishtoh",
    Handle = function(v)
        if v then
            if not lplr.Character then
                shared.Rise.Chat.PushRiseMessage("Failed to teleport: Character Missing")
            else
                local winloc = workspace.tower.sections.finish.FinishGlow.CFrame
                winloc = winloc + winloc.LookVector:Cross(Vector3.new(0, -1, 0)).Unit * 3
                lplr.Character:PivotTo(winloc)
                shared.Rise.Chat.PushRiseMessage("Teleported")
            end
        end
        tptof["Toggle"](false)
    end
})
