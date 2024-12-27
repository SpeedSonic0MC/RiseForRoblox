--[[ Natural Disaster Survival ]] --
local GuiLibrary = shared.Rise.GuiLibrary
local RunService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local playersService = game:GetService("Players")
local lplr = playersService.LocalPlayer
local wait = task.wait -- autocomplete deprecation warning
local runService = game:GetService "RunService"
local isUnsupportedDevice = table.find({Enum.Platform.IOS, Enum.Platform.Android}, userInputService:GetPlatform())

local infjumpevent, ijd = nil, false
GuiLibrary.ObjectsThatCanBeSaved.MovementWindow.CreateModule({
    Name = "infinite jump",
    Handle = function(val)
        pcall(function()
            if not val then
                infjumpevent:Disconnect()
                infjumpevent = nil
            else
                ijd = false
                infjumpevent = userInputService.JumpRequest:Connect(function()
                    if not ijd then
                        ijd = true
                        lplr.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait()
                        ijd = false
                    end
                end)
            end
        end)
    end
})

local noclipe
local function noClip()
    wait(0.1)
    noclipe = RunService.Stepped:Connect(function()
        if lplr.Character ~= nil then
            for _, v in pairs(lplr.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end)
end
local function clip()
    if noclipe then
        pcall(function()
            noclipe:Disconnect()
        end)
    end
    if lplr.Character ~= nil then
        for _, v in pairs(lplr.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == false then
                v.CanCollide = true
            end
        end
    end
end

function getRoot(char)
    local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or
                         char:FindFirstChild('UpperTorso')
    return rootPart
end

function randomString()
    local length = math.random(10, 20)
    local array = {}
    for i = 1, length do
        array[i] = string.char(math.random(32, 126))
    end
    return table.concat(array)
end

local usingMode = 1
local flinging = false
local flings = {
    ["Modern"] = function(enabled)
        if enabled then
            flinging = true
            for _, v in pairs(lplr.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
                end
            end
            noClip()
            local bambam = Instance.new("BodyAngularVelocity")
            bambam.Name = randomString()
            bambam.Parent = getRoot(lplr.Character)
            bambam.AngularVelocity = Vector3.new(0, 99999, 0)
            bambam.MaxTorque = Vector3.new(0, math.huge, 0)
            bambam.P = math.huge
            local char = lplr.Character:GetChildren()
            for _, v in next, char do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                    v.Massless = true
                    v.Velocity = Vector3.new(0, 0, 0)
                end
            end
            local ys = coroutine.create(function()
                repeat
                    bambam.AngularVelocity = Vector3.new(0, 99999, 0)
                    wait(.2)
                    bambam.AngularVelocity = Vector3.new(0, 0, 0)
                    wait(.1)
                until flinging == false or usingMode ~= 1
            end)
            coroutine.resume(ys)
            table.insert(GuiLibrary.Events2, ys)
        else
            flinging = false
            clip()
            wait(0.1)
            local char = lplr.Character
            if not char or not getRoot(char) then
                return
            end
            for _, v in pairs(getRoot(char):GetChildren()) do
                if v.ClassName == "BodyAngularVelocity" then
                    v:Destroy()
                end
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                end
            end
        end
    end
}

local fling, flingMode, flingDiedF
fling = GuiLibrary.ObjectsThatCanBeSaved.PlayerWindow.CreateModule({
    Name = "fling",
    Handle = function(val)
        if val and lplr.Character then
            usingMode = flingMode.Value
            shared.Rise.Chat.PushRiseMessage("Collide with an unanchored object to fling it.")
            flingDiedF = lplr.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
                fling["Toggle"](false)
            end)
            flings["Modern"](true)
        else
            if flingDiedF then
                pcall(function()
                    flingDiedF:Disconnect()
                end)
            end
            flings["Modern"](false)
        end
    end
})

flingMode = fling.CreateModeValue({
    Options = {"Modern"}
})

local hb = runService.Heartbeat
local tpwalk, tpwalkSpeed, tpwdiedF
tpwalk = GuiLibrary.ObjectsThatCanBeSaved.MovementWindow.CreateModule({
    Name = "teleport walk",
    Handle = function(val)
        if val then
            local char = lplr.Character
            local hum = char and char:FindFirstChildWhichIsA "Humanoid"
            tpwdiedF = lplr.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
                tpwalk["Toggle"](false)
            end)
            while tpwalk["Enabled"] do
                if char and hum then
                    local delta = hb:Wait()
                    if hum.MoveDirection.Magnitude > 0 then
                        char:TranslateBy(hum.MoveDirection * tpwalkSpeed.Value * delta * 10)
                    end
                end
            end
        else
            if tpwdiedF then
                pcall(function()
                    tpwdiedF:Disconnect()
                end)
            end
        end
    end
})
tpwalkSpeed = tpwalk.CreateNumberValue({
    Name = "Speed",
    Min = 0.5,
    Max = 5,
    Increment = 0.1
})
