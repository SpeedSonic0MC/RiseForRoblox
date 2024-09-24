local delta = Color3.fromRGB(9999, 9999, 9999)
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
    Version = "6.0-Alpha.1.33",
    GradientItems = {},
    RainbowItems = {},
    Loaded = false
}
print("Rise >> Running rise version " .. GuiLibrary.Version)
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
shared.RiseFonts = {}
for i, v in pairs({"Minecraft", "Comfortaa", "AppleUI", "AppleUISemibold", "AppleUIBold", "Icona", "Iconb", "Iconc"}) do
    getriseasset(v .. ".ttf")
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
local Lang = shared.Rise:GetService("LanguageService")
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
ver.FontFace = shared.RiseFonts["AppleUIBold"]
ver.Text = GuiLibrary["Version"]
ver.TextColor3 = Color3.new(1, 1, 1)
ver.TextSize = 17
ver.TextXAlignment = Enum.TextXAlignment.Left
ver.TextYAlignment = Enum.TextYAlignment.Bottom
local vergra = Instance.new("UIGradient", ver)
vergra.Color = ColorSequence.new(Color3.new(1, 1, 1))
table.insert(GuiLibrary.RainbowItems, vergra)
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
        local scale = Instance.new("UIScale", notification)
        local param = Instance.new("GetTextBoundsParams")
        param.Text = description
        param.Width = 99999
        param.Font = shared.RiseFonts.AppleUI
        param.Size = 14
        local size = math.max(textService:GetTextBoundsAsync(param).X + 75, 280)
        notification.Size = UDim2.new(0, size * 1.15, 0, 60 * 1.15)
        notification.ImageTransparency = 1
        notification.Position = UDim2.new(0, math.floor((size == 280 and 155 or (155 + (size - 280) / 2))), 0, 92)
        notification.Size = UDim2.new(0, size, 0, 60)
        scale.Scale = 1.13
        notification.Image = getriseasset("Notification.png")
        notification.ImageColor3 = Color3.new(1, 1, 1)
        notification.ScaleType = Enum.ScaleType.Slice
        notification.SliceCenter = Rect.new(Vector2.new(71, 0), Vector2.new(249, 60))
        notification.SliceScale = 1
        local t = Instance.new("TextLabel", notification)
        t.BackgroundTransparency = 1
        t.Position = UDim2.new(0, 60, 0, 14)
        t.Size = UDim2.new(0, size - 75, 0, 14)
        t.FontFace = shared.RiseFonts.AppleUIBold
        t.Text = title
        t.TextColor3 = ThemeService.Themes[GuiLibrary.Settings.Theme][1]
        table.insert(GuiLibrary.RainbowItems, t)
        t.TextSize = 14
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.TextTransparency = 1
        local d = Instance.new("TextLabel", notification)
        d.TextTransparency = 1
        d.BackgroundTransparency = 1
        d.Position = UDim2.new(0, 60, 0, 34)
        d.Size = UDim2.new(0, size - 75, 0, 14)
        d.FontFace = shared.RiseFonts.AppleUI
        d.Text = description
        d.TextColor3 = Color3.new(215, 215, 215)
        d.TextSize = 14
        d.TextXAlignment = Enum.TextXAlignment.Left
        tweenService:Create(notification, TweenInfo.new(0.2), {
            ImageTransparency = 0
        }):Play()
        tweenService:Create(scale, TweenInfo.new(0.2), {
            Scale = 1
        }):Play()
        tweenService:Create(t, TweenInfo.new(0.2), {
            TextTransparency = 0
        }):Play()
        tweenService:Create(d, TweenInfo.new(0.2), {
            TextTransparency = 0
        }):Play()
        task.wait(0.2 + (time or 0.8))
        tweenService:Create(t, TweenInfo.new(0.2), {
            TextTransparency = 1
        }):Play()
        tweenService:Create(d, TweenInfo.new(0.2), {
            TextTransparency = 1
        }):Play()
        tweenService:Create(notification, TweenInfo.new(0.2), {
            ImageTransparency = 1
        }):Play()
        tweenService:Create(scale, TweenInfo.new(0.2), {
            Scale = 1.13
        }):Play()
        task.wait(0.2)
        notification:Destroy()
        notif = false
    end)
end
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
    repeat
        t()
        task.wait()
    until not GuiLibrary
end)
local clip = Instance.new("Frame", maingui)
clip.AnchorPoint = Vector2.new(0.5, 0.5)
clip.BackgroundTransparency = 1
clip.Position = UDim2.new(0.5, 0, 0.5, 0)
clip.Size = UDim2.new(0, 800, 0, 600)
clip.ClipsDescendants = true
local windowshit = Instance.new("Frame", clip)
windowshit.BackgroundTransparency = 1
windowshit.Position = UDim2.new(0, 200, 0, 0)
windowshit.Size = UDim2.new(0, 600, 0, 600)
windowshit.ClipsDescendants = true
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
local icon = {
    Search = {3, "U"},
    Combat = {1, "a"},
    Movement = {1, "b"},
    Player = {1, "c"},
    Render = {1, "g"},
    Exploit = {1, "a"},
    Ghost = {1, "f"},
    CaS = {3, "m"},
    Themes = {3, "U"},
    Language = {3, "U"}
}
local shader = Instance.new("Frame", clip)
shader.BackgroundTransparency = 0.99
shader.AnchorPoint = Vector2.new(0.5, 0.5)
shader.Size = UDim2.new(0, 1000, 0, 1000)
shader.ZIndex = 999
table.insert(GuiLibrary.RainbowItems, shader)
local cr = Instance.new("UICorner", shader)
cr.CornerRadius = UDim.new(1, 0)
for i, v in pairs({"Search", "Combat", "Movement", "Player", "Render", "Exploit", "Ghost", "CaS", "Themes", "Language"}) do
    local textbtn = Instance.new("TextButton", winlist)
    textbtn.BackgroundTransparency = 1
    textbtn.Text = ""
    textbtn.Name = v
    textbtn.Position = UDim2.new(0, 0, 0, winpos[i])
    textbtn.Size = UDim2.new(0, 200, 0, 29)
    local cart = Instance.new("TextLabel", textbtn)
    cart.TextScaled = true
    cart.AnchorPoint = Vector2.new(0, 0.5)
    cart.BackgroundTransparency = 1
    cart.Name = "TNTMinecart"
    cart.Position = UDim2.new(0, (v == "Search" and 32 or 24), 0.5, 0)
    cart.Size = UDim2.new(0, 17, 0, 17)
    cart.FontFace = shared.RiseFonts["Icon" .. tostring(({"a", "b", "c"})[icon[v][1]])]
    cart.TextSize = 17
    cart.Text = icon[v][2]
    cart.TextColor3 = (v == "Search" and Color3.new(1, 1, 1) or Color3.fromRGB(170, 170, 170))
    cart.TextXAlignment = Enum.TextXAlignment.Left
    cart.TextYAlignment = Enum.TextYAlignment.Center
    local lab = Instance.new("TextLabel", cart)
    lab.AnchorPoint = Vector2.new(0, 0.5)
    lab.FontFace = shared.RiseFonts.AppleUI
    lab.BackgroundTransparency = 1
    lab.Position = UDim2.new(1, 7, 0.5, 0)
    lab.Size = UDim2.new(0, 2000, 0, 15)
    lab.Text = v
    lab.TextColor3 = (v == "Search" and Color3.new(1, 1, 1) or Color3.fromRGB(170, 170, 170))
    lab.TextSize = 16
    lab.TextXAlignment = Enum.TextXAlignment.Left
    textbtn.MouseButton1Click:Connect(function()
        if sw == v then
            return
        end
        task.spawn(function()
            local cs = selectedwindow:Clone()
            cs.Parent = winlist
            tweenService:Create(cs, TweenInfo.new(0.3), {
                ImageTransparency = 1
            }):Play()
            tweenService:Create(winlist:FindFirstChild(sw).TNTMinecart, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 24, 0.5, 0),
                TextColor3 = Color3.fromRGB(170, 170, 170)
            }):Play()
            tweenService:Create(winlist:FindFirstChild(sw).TNTMinecart:FindFirstChildWhichIsA "TextLabel",
                TweenInfo.new(0.3), {
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
            tweenService:Create(cart, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 32, 0.5, 0),
                TextColor3 = Color3.new(1, 1, 1)
            }):Play()
            tweenService:Create(lab, TweenInfo.new(0.3), {
                TextColor3 = Color3.new(1, 1, 1)
            }):Play()
        end)
        task.spawn(function() -- sw example: Combat, old: sw, new: v
            local newobj = GuiLibrary.ObjectCanBeSaved[v .. "Window"]["Object"]["ScrollingFrame"]
            local oldobj = GuiLibrary.ObjectCanBeSaved[sw .. "Window"]["Object"]["ScrollingFrame"]
            for i2, v2 in pairs(oldobj:GetDescendants()) do
                local property = nil
                local value = 1
                if v2:IsA("TextLabel") then
                    property = "TextTransparency"
                elseif (v2:IsA("TextButton") or v2:IsA("Frame")) and not v2:HasTag("NoTween") then
                    property = "BackgroundTransparency"
                end
                if property ~= nil then
                    tweenService:Create(v2, TweenInfo.new(0.15), {
                        [property] = value
                    }):Play()
                    task.delay(0.15, function()
                        v2[property] = 0
                    end)
                end
            end
            newobj.Visible = true
            for i2, v2 in pairs(newobj:GetDescendants()) do
                local property = nil
                local value = 0
                if v2:IsA("TextLabel") then
                    property = "TextTransparency"
                elseif (v2:IsA("TextButton") or v2:IsA("Frame")) and not v2:HasTag("NoTween") then
                    property = "BackgroundTransparency"
                end
                if property ~= nil then
                    v2[property] = value
                    tweenService:Create(v2, TweenInfo.new(0.151), {
                        [property] = value
                    }):Play()
                end
            end
            task.delay(0.15, function()
                oldobj.Visible = false
            end)
        end)
        sw = v
    end)
    local frame = Instance.new("Frame", windowshit)
    frame.ClipsDescendants = true -- pretty useless ngl
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Visible = v == "Search"
    local windowapi = {
        ["Type"] = "Window",
        ["Object"] = frame
    }
    local padding = Instance.new("UIPadding", frame)
    padding.PaddingTop = UDim.new(0, 14)
    padding.PaddingBottom = UDim.new(0, 14)
    local scrframe = Instance.new("ScrollingFrame", frame)
    scrframe.AnchorPoint = Vector2.new(0.5, 0.5)
    scrframe.Position = UDim2.new(0.5, 0, 0.5, 0)
    scrframe.Size = UDim2.new(1, -12, 1, 0)
    scrframe.BackgroundTransparency = 1
    scrframe.ClipsDescendants = false
    scrframe.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrframe.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrframe.ElasticBehavior = Enum.ElasticBehavior.Always
    scrframe.ScrollBarImageColor3 = Color3.fromRGB(69, 72, 77)
    scrframe.ScrollBarThickness = 2
    local uilistlayout = Instance.new("UIListLayout", scrframe)
    uilistlayout.Padding = UDim.new(0, 14)
    uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    if initWindowFunction[v] then
        initWindowFunction[v](scrframe)
    end
    windowapi["CreateOptionsButton"] = function(argsmaintable)
        local buttonapi = {
            ["Name"] = argsmaintable["Name"] or "Example Settings",
            ["Description"] = argsmaintable["Description"] or "An example script to teach how to use rise's settings.",
            ["Suffix"] = nil,
            ["Enabled"] = argsmaintable["Enabled"] or false,
            ["Keybind"] = nil,
            ["Function"] = argsmaintable["Function"] or function() end
        }
        local buttonobj = Instance.new("TextButton", scrframe)
        buttonobj.Text = ""
        buttonobj.BackgroundColor3 = Color3.fromRGB(18, 21, 27)
        buttonobj.Size = UDim2.new(0, 566, 0, 75)
        buttonobj.AutoButtonColor = false
        local corner = Instance.new("UICorner", buttonobj)
        corner.CornerRadius = UDim.new(0, 12)
        buttonobj.MouseEnter:Connect(function()
            tweenService:Create(buttonobj, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(17, 19, 25)
            }):Play()
        end)
        buttonobj.MouseLeave:Connect(function()
            tweenService:Create(buttonobj, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(18, 21, 27)
            }):Play()
        end)
        local name = Instance.new("TextLabel", buttonobj)
        name.BackgroundTransparency = 1
        name.Position = UDim2.new(0, 12, 0, 15)
        name.Size = UDim2.new(0, 2000, 0, 16)
        name.FontFace = shared.RiseFonts.AppleUISemibold
        name.Text = buttonapi.Name .. "   <font size=\"15\" color=\"rgb(70, 66, 77)\">(" .. v .. ")</font>"
        name.RichText = true
        name.TextColor3 = Color3.new(1, 1, 1)
        if buttonapi.Enabled then
            table.insert(GuiLibrary.GradientItems, name)
        end
        name.TextSize = 18
        name.TextXAlignment = Enum.TextXAlignment.Left
        local desc = Instance.new("TextLabel", buttonobj)
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextSize = 14
        desc.TextColor3 = Color3.fromRGB(88, 88, 88)
        desc.Text = buttonapi.Description
        desc.FontFace = shared.RiseFonts.AppleUI
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, 13, 0, 48)
        desc.Size = UDim2.new(0, 2000, 0, 14)
        local expandsize = 0
        buttonapi["SetKeybind"] = function(key)
            buttonapi.Keybind = key
        end
        buttonapi["ToggleButton"] = function(toggle, silent)
            if buttonapi.Enabled == toggle then return end
            buttonapi.Enabled = (toggle or not buttonapi["Enabled"])
            if buttonapi.Enabled then
                table.insert(GuiLibrary.GradientItems, name)
            else
                for i2, v2 in pairs(GuiLibrary.GradientItems) do
                    if v2 == buttonobj then
                        table.remove(GuiLibrary.GradientItems, i2)
                    end
                end
                buttonobj.TextColor3 = Color3.new(1, 1, 1)
            end
            buttonapi["Function"](buttonapi.Enabled)
            if not silent then
                GuiLibrary["ShowNotification"]("Toggled", "Toggled " .. buttonapi["Name"] .. " " .. (buttonapi["Enabled"] and "on" or "off"))
            end
        end
        if buttonapi["Enabled"] then
            buttonapi["ToggleButton"](true, true)
        end
        buttonobj.MouseButton1Click:Connect(function()
            task.spawn(function()
                buttonobj.BackgroundColor3 = Color3.fromRGB(16, 18, 23)
                task.wait(.1)
                buttonobj.BackgroundColor3 = Color3.fromRGB(18, 21, 27)
            end)
            buttonapi["ToggleButton"]()
        end)
        GuiLibrary.ObjectCanBeSaved[buttonapi.Name .. "OptionsButton"] = buttonapi
        return buttonapi
    end
    GuiLibrary.ObjectCanBeSaved[v .. "Window"] = windowapi
end
GuiLibrary["SelfDestruct"] = function()
    GuiLibrary = nil
end
GuiLibrary.UpdateHudEvent.Event:Connect(function()
    local theme = ThemeService.Themes[GuiLibrary.Settings.Theme]
    if not theme then
        theme = ThemeService.Themes["Water"]
    end
    if ThemeService:GetColor(ThemeService:GetKeyColor(GuiLibrary.Settings.Theme)) ~= nil then -- rainbow
        shader.BackgroundColor3 = ThemeService:GetColor(ThemeService:GetKeyColor(GuiLibrary.Settings.Theme))
    end
    if GuiLibrary.Settings.Theme == "Rainbow" then
        vergra.Color = ColorSequence.new(Color3.new(1, 1, 1))
    else
        vergra.Color = ColorSequence.new(ThemeService.Themes[GuiLibrary.Settings.Theme][1])
    end
end)
local InterfaceOptionsButton = GuiLibrary.ObjectCanBeSaved["RenderWindow"]["CreateOptionsButton"]({
    ["Name"] = "Interface",
    ["Description"] = "The clients interface with all information"
})
GuiLibrary.UpdateHudEvent:Fire()
GuiLibrary.ShowNotification("Rise 6", "Rise loaded. Press " .. GuiLibrary.Settings.Keybind .. " to open Click GUI", 3)
GuiLibrary.Loaded = true
return GuiLibrary
