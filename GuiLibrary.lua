local GuiLibrary = {
    ObjectCanBeSaved = {},
    Settings = {
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
        UILocation = {0, 0},
        Theme = "Water"
    },
    Assets = {
        ["logo.png"] = "rbxassetid://128089542278367",
        ["maingui.png"] = "rbxassetid://138942713766181",
        ["Notification.png"] = "rbxassetid://104510745030330"
    },
    Version = "6.0",
    GradientItems = {},
    RainbowItems = {}
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
getriseasset("AppleUIBold.ttf")
shared.RiseFonts = {}
for i, v in pairs({"Minecraft", "Comfortaa", "AppleUI", "AppleUIBold"}) do
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
local rise2 = Instance.new("ScreenGui", lplr.PlayerGui)
rise2.DisplayOrder = 999
rise2.Name = "Rise 6 - HUD"
rise2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
rise2.ResetOnSpawn = false
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
maingui.Visible = false
maingui.ImageTransparency = 0
maingui.ClipsDescendants = true
local uiscale = Instance.new("UIScale", maingui)
uiscale.Scale = 0.2
local tweening = false
local rt = "RiseTransparency"
local function tgle()
    local function wefpok230(v)
        if v:IsA("Frame") then
            return "BackgroundTransparency"
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            return "TextTransparency"
        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
            return "ImageTransparency"
        end
    end
    if not tweening then
        tweening = true
        if uiscale.Scale == 1 then
            GuiLibrary["ShowNotification"]("Toggled", "Toggled ClickGUI off")
            tweenService:Create(maingui, TweenInfo.new(0.15), {
                ImageTransparency = 1
            }):Play()
            tweenService:Create(uiscale, TweenInfo.new(0.15), {
                Scale = 0.2
            }):Play()
            for i, v in pairs(maingui:GetDescendants()) do
                if v:GetAttribute(rt) then
                    tweenService:Create(v, TweenInfo.new(0.15), {
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
            GuiLibrary["ShowNotification"]("Toggled", "Toggled ClickGUI on")
            maingui.Visible = true
            for i, v in pairs(maingui:GetDescendants()) do
                if v:GetAttribute(rt) then
                    v[wefpok230(v)] = 1
                end
            end
            for i, v in pairs(maingui:GetDescendants()) do
                if v:GetAttribute(rt) then
                    tweenService:Create(v, TweenInfo.new(0.15), {
                        [wefpok230(v)] = 0
                    }):Play()
                end
            end
            tweenService:Create(maingui, TweenInfo.new(0.15), {
                ImageTransparency = 0
            }):Play()
            tweenService:Create(uiscale, TweenInfo.new(0.15), {
                Scale = 1
            }):Play()
        end
        tweening = false
    end
end
inputService.InputBegan:Connect(function(input)
    if Enum.KeyCode[GuiLibrary.Settings.Keybind] == input.KeyCode then
        tgle()
    end
end)
local ver = Instance.new("TextLabel", maingui)
ver.Position = UDim2.new(0, 97, 0, 37) --  we use UIScale now so finally yay no more scales
ver.Size = UDim2.new(0, 50, 0, 13)
ver.BackgroundTransparency = 1
ver.FontFace = shared.RiseFonts["AppleUI"]
ver.Text = GuiLibrary["Version"]
ver.TextColor3 = Color3.new(1, 1, 1)
ver.TextSize = 17
ver.TextXAlignment = Enum.TextXAlignment.Left
ver.TextYAlignment = Enum.TextYAlignment.Bottom
table.insert(GuiLibrary.GradientItems, ver)
GuiLibrary.UpdateHudEvent.Event:Connect(function()
    local theme = ThemeService.Themes[GuiLibrary.Settings.Theme]
    if not theme then
        theme = ThemeService.Themes["Water"]
    end
end)
local notif = false
GuiLibrary["ShowNotification"] = function(title, description, time)
    title = description ~= nil and title or "Rise 6"
    description = description or title
    if not GuiLibrary.Settings.Notifications then
        return
    end
    if notif then
        repeat
            task.wait()
        until not notif
    end
    notif = true
    local notification = Instance.new("ImageLabel", rise2)
    notification.AnchorPoint = Vector2.new(0.5, 0.5)
    notification.BackgroundTransparency = 1
    local param = Instance.new("GetTextBoundsParams")
    param.Text = description
    param.Width = 99999
    param.Font = shared.RiseFonts.AppleUI
    param.Size = 14
    local size = math.max(textService:GetTextBoundsAsync(param).X + 75, 280)
    notification.Size = UDim2.new(0, size * 1.3, 0, 60 * 1.3)
    notification.ImageTransparency = 1
    notification.Position = UDim2.new(0, math.floor((size == 280 and 155 or (155 + (size - 280) / 2))), 0, 92)
    notification.Size = UDim2.new(0, size * 1.3, 0, 60 * 1.3)
    notification.Image = getriseasset("Notification.png")
    notification.ImageColor3 = Color3.new(1, 1, 1)
    notif = false
end
GuiLibrary.UpdateHudEvent:Fire()

local lastprogress = nil
local reverse = true
GuiLibrary.ColorStepped = runService.RenderStepped:Connect(function()
    local progress = (tick() * 0.25 * 0.6) % 1
    if progress <= 0.01 and lastprogress >= 0.99 then
        reverse = not reverse
    end
    local rlpg = progress
    if reverse then
        rlpg = 1 - rlpg
    end
    local color = ThemeService:GetColorValue("Rainbow", rlpg)
    for i, v in pairs(GuiLibrary.GradientItems) do
        if v == nil then
            return
        end
        if v:IsA("Frame") then
            v.BackgroundColor3 = color
        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v.ImageColor3 = color
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            v.TextColor3 = color
        end
    end
    for i, v in pairs(GuiLibrary.RainbowItems) do
        if v == nil or GuiLibrary.Settings.Theme ~= "Rainbow" then
            return
        end
        if v:IsA("Frame") then
            v.BackgroundColor3 = color
        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v.ImageColor3 = color
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            v.TextColor3 = color
        end
    end
end)
GuiLibrary["SelfDestruct"] = function()
    if GuiLibrary["ColorStepped"] then
        GuiLibrary["ColorStepped"]:Disconnect()
    end
end
GuiLibrary.ShowNotification("Rise 6", "Rise loaded. Press " .. GuiLibrary.Settings.Keybind .. " to open Click GUI")
return GuiLibrary
