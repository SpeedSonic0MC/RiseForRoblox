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
        ["Notification.png"] = "rbxassetid://104510745030330",
        ["Window.png"] = "rbxassetid://78059882197728"
    },
    Version = "6.0-Alpha.1",
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
    writefile("rise/assets/" .. url, asset.Body)
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
rise2.DisplayOrder = 998
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
ver.Size = UDim2.new(0, 2000, 0, 13)
ver.BackgroundTransparency = 1
ver.FontFace = shared.RiseFonts["AppleUI"]
ver.Text = GuiLibrary["Version"]
ver.TextColor3 = Color3.new(1, 1, 1)
ver.TextSize = 17
ver.TextXAlignment = Enum.TextXAlignment.Left
ver.TextYAlignment = Enum.TextYAlignment.Bottom
local vergra = Instance.new("UIGradient", ver)
vergra.Color = ColorSequence.new(Color3.new(1, 1, 1))
table.insert(GuiLibrary.RainbowItems, vergra)
GuiLibrary.UpdateHudEvent.Event:Connect(function()
    local theme = ThemeService.Themes[GuiLibrary.Settings.Theme]
    if not theme then
        theme = ThemeService.Themes["Water"]
    end
    if GuiLibrary.Settings.Theme == "Rainbow" then
        vergra.Color = ColorSequence.new(Color3.new(1, 1, 1))
    else
        vergra.Color = ColorSequence.new(ThemeService.Themes[GuiLibrary.Settings.Theme][1])
    end
end)
local notif = false
GuiLibrary["ShowNotification"] = function(title, description, time)
    task.spawn(function()
        title = description ~= nil and title or "Toggled"
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
        notification.Size = UDim2.new(0, size * 1.15, 0, 60 * 1.15)
        notification.ImageTransparency = 1
        notification.Position = UDim2.new(0, math.floor((size == 280 and 155 or (155 + (size - 280) / 2))), 0, 92)
        notification.Size = UDim2.new(0, size * 1.3, 0, 60 * 1.3)
        notification.Image = getriseasset("Notification.png")
        notification.ImageColor3 = Color3.new(1, 1, 1)
        notification.ScaleType = Enum.ScaleType.Slice
        notification.SliceCenter = Rect.new(Vector2.new(71, 0), Vector2.new(249, 60))
        notification.SliceScale = 1
        local t = Instance.new("TextLabel", notification)
        t.BackgroundTransparency = 1
        t.Position = UDim2.new(0.214, 0, 0.217, 0)
        t.Size = UDim2.new(0, size - 75, 0.233, 0)
        t.FontFace = shared.RiseFonts.AppleUIBold
        t.Text = title
        t.TextColor3 = Color3.new(1, 1, 1)
        table.insert(GuiLibrary.RainbowItems, t)
        t.TextSize = 14
        t.TextScaled = true
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.TextTransparency = 1
        local d = Instance.new("TextLabel", notification)
        d.TextTransparency = 1
        d.BackgroundTransparency = 1
        d.Position = UDim2.new(0.214, 0, 0.567, 0)
        d.Size = UDim2.new(0, size - 75, 0.233, 0)
        d.TextScaled = true
        d.FontFace = shared.RiseFonts.AppleUI
        d.Text = description
        d.TextColor3 = Color3.new(215, 215, 215)
        d.TextSize = 14
        d.TextXAlignment = Enum.TextXAlignment.Left
        tweenService:Create(notification, TweenInfo.new(0.2), {
            ImageTransparency = 0,
            Size = UDim2.new(0, size, 0, 60)
        }):Play()
        tweenService:Create(t, TweenInfo.new(0.2), {
            TextTransparency = 0
        }):Play()
        tweenService:Create(d, TweenInfo.new(0.2), {
            TextTransparency = 0
        }):Play()
        task.wait(1)
        tweenService:Create(t, TweenInfo.new(0.2), {
            TextTransparency = 1
        }):Play()
        tweenService:Create(d, TweenInfo.new(0.2), {
            TextTransparency = 1
        }):Play()
        tweenService:Create(notification, TweenInfo.new(0.2), {
            ImageTransparency = 1,
            Size = UDim2.new(0, size * 1.15, 0, 60 * 1.15)
        }):Play()
        task.wait(0.2)
        notification:Destroy()
        notif = false
    end)
end
GuiLibrary.UpdateHudEvent:Fire()
local reverse = true
local step = 0
local function t()
    if step >= 1 then
        reverse = not reverse
        step = 0
    end
    local rlpg = reverse and 1 - step or step
    local color = ThemeService:GetColorValue(GuiLibrary.Settings.Theme, rlpg):Lerp(Color3.new(0, 0, 0), 0.1)
    step = step + 0.005
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
        elseif v:IsA("UIGradient") then
            v.Color = ColorSequence.new(color)
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
        elseif v:IsA("UIGradient") then
            v.Color = ColorSequence.new(color)
        end
    end
end
task.spawn(function()
    repeat t() task.wait() until not GuiLibrary
end)
local clip = Instance.new("Frame", maingui)
clip.AnchorPoint = Vector2.new(0.5, 0.5)
clip.BackgroundTransparency = 1
clip.Position = UDim2.new(0.5, 0, 0.5, 0)
clip.Size = UDim2.new(0, 800, 0, 600)
clip.ClipsDescendants = true
local winlist = Instance.new("Frame", clip)
winlist.BackgroundTransparency = 1
winlist.Size = UDim2.new(1, 0, 1, 0)
local selectedsize = {96, 102, 120, 88, 96, 94, 88, 76, 102, 114}
local selectedpos = {80, 120, 162, 203, 243, 285, 325, 367, 408, 449}
local winpos = {80, 121, 162, 203, 244, 285, 326, 367, 408, 449}
local winize = {70, 81, 103, 65, 74, 68, 66, 52, 81, 95}
local initWindowFunction = {}
local selectedwindow = Instance.new("ImageLabel", winlist)
selectedwindow.Image = getriseasset("Window.png")
selectedwindow.BackgroundTransparency = 1
selectedwindow.Position = UDim2.new(0, 20, 0, selectedpos[1])
selectedwindow.Size = UDim2.new(0, selectedsize[1], 0, 30)
selectedwindow.ZIndex = 0
selectedwindow.ScaleType = Enum.ScaleType.Slice
selectedwindow.SliceScale = 1
selectedwindow.SliceCenter = Rect.new(Vector2.new(9, 0), Vector2.new(21, 30))
table.insert(GuiLibrary.GradientItems, selectedwindow)
local sw = "Search"
for i, v in pairs({"Search", "Combat", "Movement", "Player", "Render", "Exploit", "Ghost", "CaS", "Themes", "Language"}) do
    local textbtn = Instance.new("TextButton", winlist)
    textbtn.BackgroundTransparency = 1
    textbtn.Text = ""
    textbtn.Name = v
    textbtn.Position = UDim2.new(0, 0, 0, winpos[i])
    textbtn.Size = UDim2.new(0, 200, 0, 29)
    local cart = Instance.new("ImageLabel", textbtn)
    cart.AnchorPoint = Vector2.new(0, 0.5)
    cart.BackgroundTransparency = 1
    cart.Position = UDim2.new(0, (v == "Search" and 32 or 24), 0.5, 0)
    cart.Size = UDim2.new(0, 19, 0, 19)
    cart.Image = getriseasset(v .. ".png")
    cart.ImageColor3 = (v == "Search" and Color3.new(1, 1, 1) or Color3.fromRGB(170, 170, 170))
    cart.ScaleType = Enum.ScaleType.Slice
    cart.ImageRectSize = Vector2.new(19, 19)
    cart.ImageRectOffset = Vector2.zero
    cart.SliceCenter = Rect.new(Vector2.zero, Vector2.new(19, 19))
    local lab = Instance.new("TextLabel", cart)
    lab.AnchorPoint = Vector2.new(0, 0.5)
    lab.FontFace = shared.RiseFonts.AppleUI
    lab.BackgroundTransparency = 1
    lab.Position = UDim2.new(1, 5, 0.5, 0)
    lab.Size = UDim2.new(0, 2000, 0, 15)
    lab.Text = v
    lab.TextColor3 = (v == "Search" and Color3.new(1, 1, 1) or Color3.fromRGB(170, 170, 170))
    lab.TextScaled = true
    lab.TextXAlignment = Enum.TextXAlignment.Left
    textbtn.MouseButton1Click:Connect(function()
        if sw == v then
            return
        end
        local cs = selectedwindow:Clone()
        cs.Parent = winlist
        tweenService:Create(cs, TweenInfo.new(0.3), {
            ImageTransparency = 1
        }):Play()
        tweenService:Create(winlist:FindFirstChild(sw):FindFirstChildWhichIsA "ImageLabel", TweenInfo.new(0.3), {
            Position = UDim2.new(0, 24, 0.5, 0),
            ImageColor3 = Color3.fromRGB(170, 170, 170)
        }):Play()
        tweenService:Create(winlist:FindFirstChild(sw):FindFirstChildWhichIsA "ImageLabel"
            :FindFirstChildWhichIsA "TextLabel", TweenInfo.new(0.3), {
            TextColor3 = Color3.fromRGB(170, 170, 170)
        }):Play()
        task.delay(0.3, function()
            cs:Destroy()
        end)
        selectedwindow.Position = UDim2.new(0, 20, 0, selectedpos[i])
        selectedwindow.ImageTransparency = 1
        selectedwindow.Size = UDim2.new(0, selectedsize[i], 0, 30)
        tweenService:Create(selectedwindow, TweenInfo.new(0.3), {
            ImageTransparency = 0
        }):Play()
        sw = v
        tweenService:Create(cart, TweenInfo.new(0.3), {
            Position = UDim2.new(0, 32, 0.5, 0),
            ImageColor3 = Color3.new(1, 1, 1)
        }):Play()
        tweenService:Create(lab, TweenInfo.new(0.3), {
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)
end
GuiLibrary["SelfDestruct"] = function()
    GuiLibrary = nil
end
GuiLibrary.ShowNotification("Rise 6", "Rise loaded. Press " .. GuiLibrary.Settings.Keybind .. " to open Click GUI")
return GuiLibrary
