--[[ Game: Natural Disaster Survival ]] local GuiLibrary = shared.Rise.GuiLibrary
local playersService = game:GetService("Players")
local lplr = playersService.LocalPlayer
local runService = game:GetService("RunService")

local dieListener, noClipping

local function noclip()
    local loop = function()
        if lplr.Character ~= nil then
            for _, v in pairs(lplr.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                    v:AddTag("Rizz6NoClip")
                end
            end
        end
    end
    noClipping = runService.Stepped:Connect(loop)
end

local function clip()
    if noClipping then
        noClipping:Disconnect()
    end
    if lplr.Character ~= nil then
        for _, v in pairs(lplr.Character:GetDescendants()) do
            if v:IsA("BasePart") and v:HasTag("Rizz6NoClip") and not v.CanCollide then
                v.CanCollide = true
                v:RemoveTag("Rizz6NoClip")
            end
        end
    end
end

local wait = task.wait -- AutoComplete deprecation warning

function getRoot(char)
    local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or
                         char:FindFirstChild('UpperTorso')
    return rootPart
end

local fling, flingMode, flingS
flingS = function()
    if not lplr.Character then
        fling["Toggle"](false, false)
        GuiLibrary.CreateNotification({
            Title = "Fling",
            Text = "Character missing"
        })
    else
        if flingMode.Value == 1 then
            for _, v in pairs(lplr.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
                end
            end
            noclip()
            local boom = Instance.new("BodyAngularVelocity")
            boom.Name = "Rizz6AngularVelocity"
            boom.Parent = getRoot(lplr.Character)
            boom.AngularVelocity = Vector3.new(0, 99999, 0)
            boom.MaxTorque = Vector3.new(0, math.huge, 0)
            boom.P = math.huge
            local cx = lplr.Character:GetChildren()
            for _, v in next, cx do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                    v.Massless = true
                    v.Velocity = Vector3.new(0, 0, 0)
                end
            end
            dieListener = lplr.Character:FindFirstChildOfClass "Humanoid".Died:Connect(function()
                fling["Toggle"](false)
                dieListener:Disconnect()
            end)
            task.spawn(function()
                repeat
                    boom.AngularVelocity = Vector3.new(0, 99999, 0)
                    wait(0.2)
                    boom.AngularVelocity = Vector3.new(0, 0, 0)
                    wait(0.1)
                until fling["Enabled"] == false or flingMode.Value ~= 1 -- disabled module or switch mode
            end)
        end
    end
end
local fling1 = function()
    clip()
    local c = lplr.Character
    if not c or not getRoot(c) then return end
    for _, v in pairs(getRoot(lplr.Character):GetChildren()) do
        if v.Name == "Rizz6AngularVelocity" then
            v:Destroy()
        end
    end
    for _, v in pairs(c:GetDescendants()) do
        if v.ClassName == "Part" or v.ClassName == "MeshPart" then
            v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
        end
    end
end
fling = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.CreateModule({
    Name = "189707fling",
    Function = function(value)
        if value then
            flingS()
        else
            if flingMode.Value == 1 then
                fling1()
            end
        end
    end
})

flingMode = fling.CreateModeValue({
    Value = 1,
    Options = {"Normal", "Fly", "Walk"}
})
