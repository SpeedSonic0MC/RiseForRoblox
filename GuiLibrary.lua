local GuiLibrary = {
    ["ObjectCanBeSaved"] = {},
    ["Settings"] = {
        Keybind = shared.RiseDeveloper and "M" or "RightShift",
        Profile = "latest",
        Notifications = true,
        ArrayListMode = "Fade",
        Sidebar = true,
        ArrayListBackground = true,
        CustomClientName = "",
        Suffix = true,
        Lowercase = false,
        RemoveSpaces = false,
        InformationType = "Rise",
        UILocation = {0, 0}
    },
    Assets = {
        ["logo.png"] = "rbxassetid://128089542278367",
        ["maingui.png"] = "rbxassetid://138942713766181"
    }
}
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
if getcustomasset == nil then
    error(
        "Rise >> Rise 6 requires a functional getcustomasset. If the executor supports it, try to rejoin for a few times to fix it being nil.")
end
local vapeCheckLoop = coroutine.create(function()
    repeat
        if shared.VapeExecuted then
            if not shared.GuiLibrary or not shared.GuiLibrary.SelfDestruct then
                return
            end
            task.spawn(shared.GuiLibrary.SelfDestruct)
            warn("Rise >> Rise 6 is incompatible with VapeV4ForRoblox.")
        end
        task.wait(5)
    until not shared.RiseExecuted
end)
coroutine.resume(vapeCheckLoop)
local playersService = game:GetService "Players"
local inputService = game:GetService "UserInputService"
local lplr = playersService.LocalPlayer
local runService = game:GetService "RunService"
local httpService = game:GetService "HttpService"
local tweenService = game:GetService "TweenService"
local textService = game:GetService "TextService"
local delfile = delfile or function(_1)
    writefile(_1, "")
    return true
end
local getriseasset = function(url)
    if GuiLibrary.Assets[url] then
        return GuiLibrary.Assets[url]
    end
    local asset = request {
        Url = "https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/assets/" .. url,
        Method = "GET"
    }
    writefile("rise/assets/" .. url, asset.Body) -- we dont do file check for asset updates.
    return getcustomasset("rise/assets/" .. url)
end
getriseasset("Minecraft.ttf")
getriseasset("Comfortaa.ttf")
getriseasset("AppleUI.ttf")
shared.RiseFonts = {}
for i, v in pairs({"Minecraft", "Comfortaa", "AppleUI"}) do
    if not isfile("rise/assets/" .. v .. ".json") then
        writefile("rise/assets/" .. v .. ".json", httpService:JSONEncode({
            name = v,
            faces = {{
                name = "Regular",
                weight = 300,
                style = "normal",
                assetId = getcustomasset("rise/assets/" .. v .. ".ttf")
            }}
        }))
    end
    shared.RiseFonts[v] = Font.new(getcustomasset("rise/assets/" .. v .. ".json"))
end
local gui = Instance.new("ScreenGui", lplr.PlayerGui)
gui.DisplayOrder = 999
gui.Name = "Rise 6 - Main GUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false
gui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
gui.ScreenInsets = Enum.ScreenInsets.None
GuiLibrary["MainGui"] = gui
if isfile("rise/configs/GUI.rscfg") then
    local suc, err = pcall(function()
        local json = httpService:JSONDecode(readfile("rise/configs/GUI.rscfg"))
        if typeof(json) ~= "table" then
            return delfile("rise/configs/GUI.rscfg")
        end
        for i, v in pairs(json) do
            if GuiLibrary.Settings[i] then
                GuiLibrary.Settings[i] = v
            end
        end
        print("Rise >> Rise 6 Loaded successfully (core)")
    end)
    if not suc then
        error("Rise >> Rise 6 Failed to load (core)")
    end
end
if Enum.KeyCode[GuiLibrary.Settings.Keybind] == nil then
    GuiLibrary.Settings.Keybind = "RightShift"
end
local ThemeService = shared.Rise:GetService("ColorService")
GuiLibrary["UpdateHudEvent"] = Instance.new "BindableEvent"
local maingui = Instance.new("ImageLabel", gui)
maingui.AnchorPoint = Vector2.new(0.5, 0.5)
maingui.BackgroundTransparency = 1
maingui.Position = UDim2.new(0.5, GuiLibrary.Settings.UILocation[1], 0.5, GuiLibrary.Settings.UILocation[2])
maingui.Size = UDim2.new(0, 828, 0, 628)
maingui.Image = getriseasset("maingui.png")
maingui.ImageColor3 = Color3.new(1, 1, 1)
maingui.ClipsDescendants = true
local tweening = false
local rt = "RiseTransparency"
inputService.InputBegan:Connect(function(input)
    local function wefpok230(v)
        if v:IsA("Frame") then
            return "BackgroundTransparency"
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            return "TextTransparency"
        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
            return "ImageTransparency"
        end
    end
    if Enum.KeyCode[GuiLibrary.Settings.Keybind] == input.KeyCode then
        if not tweening then
            tweening = true
            if maingui.Size == UDim2.new(0, 828, 0, 628) then
                tweenService:Create(maingui, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 0, 0, 0),
                    ImageTransparency = 1
                }):Play()
                for i, v in pairs(maingui:GetDescendants()) do
                    if v:GetAttribute(rt) then
                        tweenService:Create(v, TweenInfo.new(0.1), {
                            [wefpok230(v)] = 1
                        }):Play()
                    end
                end
                task.wait(0.1)
                for i, v in pairs(maingui:GetDescendants()) do
                    if v:GetAttribute(rt) then
                        v[wefpok230(v)] = 0
                    end
                end
                maingui.Visible = false
            else
                maingui.Visible = true
                for i, v in pairs(maingui:GetDescendants()) do
                    if v:GetAttribute(rt) then
                        v[wefpok230(v)] = 1
                    end
                end
                for i, v in pairs(maingui:GetDescendants()) do
                    if v:GetAttribute(rt) then
                        tweenService:Create(v, TweenInfo.new(0.1), {
                            [wefpok230(v)] = 0
                        }):Play()
                    end
                end
                tweenService:Create(maingui, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 828, 0, 628),
                    ImageTransparency = 0
                }):Play()
            end
            tweening = false
        end
    end
end)
GuiLibrary.UpdateHudEvent:Fire()
return GuiLibrary
