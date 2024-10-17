local delta = Color3.fromRGB(9999, 9999, 9999)
local GuiLibrary = {
    ObjectCanBeSaved = {},
    Settings = {
        Keybind = shared.RiseDeveloper and "M" or "RightShift",
        Theme = "Blend",
        Language = "en"
    },
    Version = "6.1.30",
    GradientItems = {},
    RainbowItems = {},
    ThemesItems = {},
    DarkerThemesItems = {},
    DarkerRainbowItems = {},
    Loaded = false,
    TranslateItems = {},
    LanguageFunctions = {},
    AwaitingTextInput = false,
    Connections = {}
}
local guitweening = false
local vis = false
print("Rise >> Running rise version " .. GuiLibrary.Version)
local function RelativeXY(GuiObject, location)
    local x, y = location.X - GuiObject.AbsolutePosition.X, location.Y - GuiObject.AbsolutePosition.Y
    local x2 = 0
    local xm, ym = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    x2 = math.clamp(x, 4, xm - 6)
    x = math.clamp(x, 0, xm)
    y = math.clamp(y, 0, ym)
    return x, y, x / xm, y / ym, x2 / xm
end
if getcustomasset == nil then
    error(
        "Rise >> Rise 6 requires a functional getcustomasset. If the executor supports it, try to rejoin for a few times to fix it being nil.")
end
local vapeCheckLoop = coroutine.wrap(function()
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
task.spawn(vapeCheckLoop)
local httpService = game:GetService "HttpService"
local mainsettingssaveloop = coroutine.create(function()
    repeat
        writefile("rise/configs/GUI.rscfg", httpService:JSONEncode(GuiLibrary.Settings))
        task.wait(1)
    until GuiLibrary == nil
end)
local playersService = game:GetService "Players"
local inputService = game:GetService "UserInputService"
local lplr = playersService.LocalPlayer
local runService = game:GetService "RunService"
local tweenService = game:GetService "TweenService"
local textService = game:GetService "TextService"
local delfile = delfile or function(_1)
    writefile(_1, "")
    return true
end
local getriseasset = function(url)
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
gui.OnTopOfCoreBlur = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false
gui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
gui.ScreenInsets = Enum.ScreenInsets.None
local rise2 = Instance.new("ScreenGui", lplr.PlayerGui)
rise2.DisplayOrder = 998
rise2.OnTopOfCoreBlur = true
rise2.Name = "Rise 6 - HUD"
rise2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
rise2.ResetOnSpawn = false
local coordinates = Instance.new("TextLabel", rise2)
coordinates.Text = "XYZ: ???, ???, ???"
coordinates.TextColor3 = Color3.fromRGB(200, 200, 200)
coordinates.FontFace = shared.RiseFonts.AppleUI
coordinates.TextSize = 20
coordinates.Position = UDim2.new(0, 10, 1, -10)
coordinates.AnchorPoint = Vector2.new(0, 1)
coordinates.TextXAlignment = Enum.TextXAlignment.Left
coordinates.BackgroundTransparency = 1
coordinates.Size = UDim2.new(0, 0, 0, 20)
task.spawn(function()
    repeat
        local character = lplr.Character
        if not character then
            return
        end
        local position = character:FindFirstChild("HumanoidRootPart")
        if not position then
            coordinates.Text = "XYZ: ???, ???, ???"
            return
        end
        local crd = position.CFrame.Position
        coordinates.Text = "XYZ: " .. math.round(crd.X) .. ", " .. math.round(crd.Y) .. ", " .. math.round(crd.Z)
        task.wait()
    until coordinates == nil
end)
local cd = Instance.new("TextLabel", rise2)
cd.Text = "RiseClient.com"
cd.TextColor3 = Color3.fromRGB(200, 200, 200)
cd.FontFace = shared.RiseFonts.AppleUI
cd.TextSize = 25
cd.Position = UDim2.new(1, -10, 1, -10)
cd.AnchorPoint = Vector2.new(1, 1)
cd.TextXAlignment = Enum.TextXAlignment.Right
cd.BackgroundTransparency = 1
cd.Size = UDim2.new(0, 0, 0, 25)
local logoimage = Instance.new("TextLabel", rise2)
logoimage.BackgroundTransparency = 1
logoimage.Position = UDim2.new(0, 15, 0, 15)
logoimage.Size = UDim2.new(0, 69, 0, 28)
logoimage.TextSize = 45
logoimage.TextXAlignment = Enum.TextXAlignment.Left
logoimage.FontFace = shared.RiseFonts.AppleUI
logoimage.Text = "Rise"
logoimage.TextColor3 = Color3.new(1, 1, 1)
logoimage.Visible = false
local uigra = Instance.new("UIGradient", logoimage)
uigra.Color = ColorSequence.new(Color3.new(1, 1, 1))
table.insert(GuiLibrary.RainbowItems, uigra)
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
local requestinput = function(argstable)
    local api = {
        ["Value"] = argstable["Default"] or "",
        Width = 0
    }
    if GuiLibrary.AwaitingTextInput then
        return
    end
    local htl = Instance.new("TextBox", gui) -- we don't use inputbegan because rise feature :D
    htl.Position = UDim2.new(999, 0, 999, 0)
    htl.Text = api.Value
    htl.ClearTextOnFocus = false
    htl:CaptureFocus()
    htl.FocusLost:Connect(function()
        GuiLibrary.AwaitingTextInput = false
        htl:Destroy()
    end)
    htl:GetPropertyChangedSignal("Text"):Connect(function()
        local param = Instance.new("GetTextBoundsParams")
        param.Font = shared.RiseFonts.AppleUI
        param.Text = htl.Text
        param.Size = argstable["TextSize"] or 21
        param.Width = 99999
        api.Width = textService:GetTextBoundsAsync(param).X
        if type(argstable["MaxTextWidth"]) == "number" then
            if api.Width > argstable["MaxTextWidth"] then
                htl.Text = api["Value"]
                return
            end
        end
        api["Value"] = htl.Text
    end)
    return api
end
local ThemeService = shared.Rise:GetService("ColorService")
local Lang = shared.Rise:GetService("LanguageService")
local languages = Lang["Available"]
local keys = Lang:GetLanguage(GuiLibrary.Settings.Language)
GuiLibrary["UpdateHudEvent"] = Instance.new "BindableEvent"
local maingui = Instance.new("ImageLabel", gui)
maingui.AnchorPoint = Vector2.new(0.5, 0.5)
maingui.BackgroundTransparency = 1
maingui.Position = UDim2.new(0.5, 0, 0.5, 0)
maingui.Size = UDim2.new(0, 828, 0, 628)
maingui.Image = getriseasset("maingui.png")
maingui.Name = "Main GUI Image"
maingui.ImageColor3 = Color3.new(1, 1, 1)
maingui.Visible = false
maingui.ImageTransparency = 0
maingui.ClipsDescendants = true
local uiscale = Instance.new("UIScale", maingui)
uiscale.Scale = 0.2
local tweening = false
local rt = "RiseTransparency"
local function tgle()
    guitweening = true
    vis = not vis
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
    guitweening = false
end
local selectedwindowoption
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
        if not GuiLibrary["ObjectCanBeSaved"]["InterfaceOptionsButton"]["Enabled"] or
            not GuiLibrary.ObjectCanBeSaved["InterfaceToggle NotificationsToggle"]["Enabled"] then
            return
        end
        title = description ~= nil and title or "Toggled"
        description = description or title
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
        t.TextColor3 = ThemeService.Themes[GuiLibrary.Settings.Theme][1] or Color3.new(1, 1, 1)
        table.insert(GuiLibrary.RainbowItems, t)
        t.TextSize = 15
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
        d.TextSize = 15
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
local function colortick()
    for i, v in pairs(GuiLibrary.GradientItems) do
        if v == nil then
            table.remove(GuiLibrary.GradientItems, i)
            return
        end
        local accc = ThemeService.getAccentColor(GuiLibrary.Settings.Theme, (v:HasTag("NotAffectedByYPos") and
            Vector2.new(0, 0) or (v:IsA("UIGradient") and v.Parent or v).AbsolutePosition))
        if v:IsA("Frame") then
            v.BackgroundColor3 = accc
        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v.ImageColor3 = accc
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            v.TextColor3 = accc
        elseif v:IsA("UIGradient") then
            v.Color = ColorSequence.new(accc)
        end
    end
    for i, v in pairs(GuiLibrary.RainbowItems) do
        if v == nil then
            table.remove(GuiLibrary.RainbowItems, i)
            return
        end
        if GuiLibrary.Settings.Theme ~= "Rainbow" then
            return
        end
        local accc = ThemeService.getAccentColor(GuiLibrary.Settings.Theme, (v:HasTag("NotAffectedByYPos") and
            Vector2.new(0, 0) or (v:IsA("UIGradient") and v.Parent or v).AbsolutePosition))
        if v:IsA("Frame") then
            v.BackgroundColor3 = accc
        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v.ImageColor3 = accc
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            v.TextColor3 = accc
        elseif v:IsA("UIGradient") then
            v.Color = ColorSequence.new(accc)
        end
    end
    for i, v in pairs(GuiLibrary.DarkerRainbowItems) do
        if v == nil then
            table.remove(GuiLibrary.DarkerRainbowItems, i)
            return
        end
        if GuiLibrary.Settings.Theme ~= "Rainbow" then
            return
        end
        local accc = ThemeService:darker(ThemeService.getAccentColor(GuiLibrary.Settings.Theme, (v:HasTag(
            "NotAffectedByYPos") and Vector2.new(0, 0) or (v:IsA("UIGradient") and v.Parent or v).AbsolutePosition)))
        if v:IsA("Frame") then
            v.BackgroundColor3 = accc
        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v.ImageColor3 = accc
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            v.TextColor3 = accc
        elseif v:IsA("UIGradient") then
            v.Color = ColorSequence.new(accc)
        end
    end
end
task.spawn(function()
    repeat
        colortick()
        task.wait(1 / 9999)
    until not GuiLibrary
end)
local clip = Instance.new("Frame", maingui)
clip.AnchorPoint = Vector2.new(0.5, 0.5)
clip.BackgroundTransparency = 1
clip.Position = UDim2.new(0.5, 0, 0.5, 0)
clip.Name = "MainGUIClip"
clip.Size = UDim2.new(0, 800, 0, 600)
clip.ClipsDescendants = true
local windowshit = Instance.new("Frame", clip)
windowshit.BackgroundTransparency = 1
windowshit.Name = "WindowList"
windowshit.Position = UDim2.new(0, 200, 0, 0)
windowshit.Size = UDim2.new(0, 600, 0, 600)
windowshit.ClipsDescendants = true
local winlist = Instance.new("Frame", clip)
winlist.Name = "WindowButtonList"
winlist.BackgroundTransparency = 1
winlist.Size = UDim2.new(1, 0, 1, 0)
local selectedpos = {80, 120, 162, 203, 243, 285, 325, 367, 408, 449}
local winpos = {80, 121, 162, 203, 244, 285, 326, 367, 408, 449}
local windowbuttonhandle
local selectedwindow
local searchtextboxinit
local initWindowFunction = {
    ["Themes"] = function(frame)
        frame.UIListLayout:Destroy()
        local themesimage = getriseasset("theme.png")
        local textl = Instance.new("TextLabel", frame)
        textl.Position = UDim2.new(1, -33, 0, 20)
        textl.AnchorPoint = Vector2.new(1, 0)
        textl.Text = "You can click on a color to filter by it. Click again to reset."
        table.insert(GuiLibrary.TranslateItems, textl)
        textl:SetAttribute("RiseLanguageKey", "themes.main")
        textl.Size = UDim2.new(1, 0, 0, 15)
        textl.TextSize = 18
        textl.FontFace = shared.RiseFonts.AppleUI
        textl.TextXAlignment = Enum.TextXAlignment.Right
        textl.BackgroundTransparency = 1
        textl.TextColor3 = Color3.fromRGB(139, 140, 144)
        local colorfilterframe = Instance.new("Frame", frame)
        colorfilterframe.Position = UDim2.new(0.5, 0, 0, 70)
        colorfilterframe.AnchorPoint = Vector2.new(0.5, 0)
        colorfilterframe:AddTag("NoTween")
        colorfilterframe.BackgroundTransparency = 1
        colorfilterframe.Size = UDim2.new(1, -16, 0, 80)
        local color = {
            Red = {
                Base = Color3.fromRGB(255, 55, 55),
                Stroke = Color3.fromRGB(19, 22, 36)
            },
            Orange = {
                Base = Color3.fromRGB(255, 128, 55),
                Stroke = Color3.fromRGB(19, 22, 35)
            },
            Yellow = {
                Base = Color3.fromRGB(255, 255, 55),
                Stroke = Color3.fromRGB(19, 22, 33)
            },
            Lime = {
                Base = Color3.fromRGB(128, 255, 55),
                Stroke = Color3.fromRGB(19, 22, 30)
            },
            DarkGreen = {
                Base = Color3.fromRGB(55, 128, 55),
                Stroke = Color3.fromRGB(19, 22, 30)
            },
            Aqua = {
                Base = Color3.fromRGB(55, 200, 255),
                Stroke = Color3.fromRGB(19, 22, 36)
            },
            DarkBlue = {
                Base = Color3.fromRGB(55, 105, 200),
                Stroke = Color3.fromRGB(19, 22, 35)
            },
            Purple = {
                Base = Color3.fromRGB(128, 52, 255),
                Stroke = Color3.fromRGB(19, 22, 33)
            },
            Pink = {
                Base = Color3.fromRGB(255, 128, 255),
                Stroke = Color3.fromRGB(19, 22, 30)
            },
            Gray = {
                Base = Color3.fromRGB(100, 100, 110),
                Stroke = Color3.fromRGB(19, 22, 30)
            }
        } -- colors filter themes: ThemeService.ColorFilters[COLOR]
        local selectedcolorfilter = nil
        local updatecolors
        local spamclickdelay = false
        for i6, v in color do
            local i = table.find({"Red", "Orange", "Yellow", "Lime", "DarkGreen", "Aqua", "DarkBlue", "Purple", "Pink",
                                  "Gray"}, i6)
            local newline = i > 5
            i = i > 5 and i - 5 or i
            local themepicker = Instance.new("TextButton", colorfilterframe)
            themepicker.BackgroundColor3 = v["Base"]
            themepicker.Size = UDim2.new(0, 102, 0, 32)
            themepicker.AutoButtonColor = false
            themepicker.Name = i6
            themepicker.Position = UDim2.new(0, ({0, 117, 234, 350, 467})[i], 0, newline and 48 or 0)
            themepicker.Text = ""
            local tpc = Instance.new("UICorner", themepicker)
            tpc.CornerRadius = UDim.new(0, 6)
            local tps = Instance.new("UIStroke", themepicker)
            tps.Color = v["Stroke"]
            tps.Thickness = 1
            tps.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            themepicker.MouseButton1Click:Connect(function()
                if spamclickdelay then
                    return
                end
                spamclickdelay = true
                if selectedcolorfilter == i6 then
                    selectedcolorfilter = nil
                else
                    selectedcolorfilter = i6
                end
                for i2, v2 in pairs(colorfilterframe:GetChildren()) do
                    if v2.Name ~= selectedcolorfilter and selectedcolorfilter ~= nil then
                        tweenService:Create(v2, TweenInfo.new(0.15), {
                            BackgroundColor3 = ThemeService:darker(color[v2.Name]["Base"])
                        }):Play()
                    else
                        tweenService:Create(v2, TweenInfo.new(0.15), {
                            BackgroundColor3 = color[v2.Name]["Base"]
                        }):Play()
                    end
                end
                updatecolors(selectedcolorfilter)
                task.spawn(function()
                    task.wait(0.2)
                    spamclickdelay = false
                end)
            end)
        end
        local themesframe = Instance.new("Frame", frame)
        themesframe:AddTag("NoTween")
        themesframe.BackgroundTransparency = 1
        themesframe.AnchorPoint = Vector2.new(0.5, 0)
        themesframe.Position = UDim2.new(0.5, 0, 0, 190)
        themesframe.Size = UDim2.new(1, -14, 0, 0)
        local defaultorder = {"Aubergine", "Aqua", "Banana", "Blend", "Blossom", "Bubblegum", "Candy Cane", "Cherry",
                              "Christmas", "Coral", "Digital Horizon", "Express", "Lime Water", "Lush", "Halogen",
                              "Hyper", "Magic", "May", "Orange Juice", "Pastel", "Pumpkin", "Satin", "Snowy Sky",
                              "Steel Fade", "Sundae", "Sunkist", "Water", "Legacy", "Winter", "Peony", "Shadow", "Wood",
                              "Creida", "Creida Two", "Gothic", "Rue", "Purple", "Rainbow"}
        local xpos = {389, 0, 195}
        local function createthemebutton(theme, additionalfilter)
            task.spawn(function()
                additionalfilter = additionalfilter or defaultorder
                if not table.find(additionalfilter, theme) then
                    return
                end
                local themeindex = table.find(additionalfilter, theme)
                local themex = Instance.new("ImageButton", themesframe)
                themex.BackgroundTransparency = 1
                themex.Image = themesimage
                themex.Size = UDim2.new(0, 181, 0, 100)
                themex.Position = UDim2.new(0, xpos[themeindex % 3 + 1], 0, 114 *
                    (themeindex % 3 ~= 0 and math.floor(themeindex / 3) or themeindex / 3 - 1))
                themex.Name = theme
                themex.ImageTransparency = 1
                local xuigra = Instance.new("UIGradient", themex)
                if theme ~= "Rainbow" then
                    if #ThemeService.Themes[theme] == 2 then
                        local firstColor = ThemeService.Themes[theme][1]
                        local secondColor = ThemeService.Themes[theme][2]
                    elseif #ThemeService.Themes[theme] == 1 then
                        xuigra.Color = ColorSequence.new(ThemeService.Themes[theme][1])
                    elseif #ThemeService.Themes[theme] == 3 then
                        local firstColor = ThemeService.Themes[theme][1]
                        local secondColor = ThemeService.Themes[theme][2]
                        local thirdColor = ThemeService.Themes[theme][3]
                    end
                else
                end
                local text = Instance.new("TextLabel", themex)
                text.BackgroundTransparency = 1
                text.Position = UDim2.new(0, 0, 0, 60)
                text.Size = UDim2.new(1, 0, 0, 40)
                text.FontFace = shared.RiseFonts.AppleUISemibold
                text.Text = theme
                text.TextColor3 = Color3.new(1, 1, 1)
                text.TextTransparency = 1
                tweenService:Create(themex, TweenInfo.new(0.15), {
                    ImageTransparency = 0
                }):Play()
                tweenService:Create(text, TweenInfo.new(0.15), {
                    TextTransparency = 0
                }):Play() -- tween in
                text.TextSize = 17
                if GuiLibrary.Settings.Theme == theme then
                    text.TextColor3 = ThemeService.Themes[theme][1]
                end
                if theme == "Rainbow" then
                    table.insert(GuiLibrary.RainbowItems, text)
                end
                themex.MouseButton1Click:Connect(function()
                    if GuiLibrary.Settings.Theme == theme then
                        return
                    end
                    themesframe[GuiLibrary.Settings.Theme].TextLabel.TextColor3 = Color3.new(1, 1, 1)
                    GuiLibrary.Settings.Theme = theme
                    GuiLibrary.UpdateHudEvent:Fire()
                    if theme ~= "Rainbow" then
                        text.TextColor3 = ThemeService.Themes[theme][1] or Color3.new(1, 1, 1)
                    end
                end)
            end)
        end
        updatecolors = function(filter)
            if not filter then
                local allexistingchildrens = themesframe:GetChildren()
                if #allexistingchildrens == 0 then
                    for i, v in pairs(defaultorder) do
                        createthemebutton(v)
                    end
                else
                    for i, v in pairs(allexistingchildrens) do
                        local themeindex = table.find(defaultorder, v.Name)
                        tweenService:Create(v, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, xpos[themeindex % 3 + 1], 0, 114 *
                                (themeindex % 3 ~= 0 and math.floor(themeindex / 3) or themeindex / 3 - 1))
                        }):Play()
                    end
                    for i, v in pairs(defaultorder) do
                        if not themesframe:FindFirstChild(v) then
                            createthemebutton(v)
                        end
                    end
                end
            else
                local filteredarraylist = ThemeService.ColorFilters[selectedcolorfilter]
                for i, v in pairs(themesframe:GetChildren()) do
                    if not table.find(filteredarraylist, v.Name) then
                        tweenService:Create(v, TweenInfo.new(0.15), {
                            ImageTransparency = 1
                        }):Play()
                        tweenService:Create(v.TextLabel, TweenInfo.new(0.15), {
                            TextTransparency = 1
                        }):Play()
                        task.spawn(function()
                            wait(.15)
                            v:Destroy()
                        end)
                    else
                        local themeindex = table.find(filteredarraylist, v.Name)
                        tweenService:Create(v, TweenInfo.new(0.15), {
                            Position = UDim2.new(0, xpos[themeindex % 3 + 1], 0, 114 *
                                (themeindex % 3 ~= 0 and math.floor(themeindex / 3) or themeindex / 3 - 1))
                        }):Play()
                    end
                end
                for i, v in pairs(filteredarraylist) do
                    if not themesframe:FindFirstChild(v) then
                        createthemebutton(v, filteredarraylist)
                    end
                end
            end
        end
        updatecolors(nil)
    end,
    ["Language"] = function(frame)
        frame.UIListLayout:Destroy()
        local textl = Instance.new("TextLabel", frame)
        textl.Position = UDim2.new(1, -33, 0, 20)
        textl.AnchorPoint = Vector2.new(1, 0)
        textl.Text = "You can click on a color to filter by it. Click again to reset."
        table.insert(GuiLibrary.TranslateItems, textl)
        textl:SetAttribute("RiseLanguageKey", "languages.main")
        textl.Size = UDim2.new(1, 0, 0, 15)
        textl.TextSize = 18
        textl.FontFace = shared.RiseFonts.AppleUI
        textl.TextXAlignment = Enum.TextXAlignment.Right
        textl.BackgroundTransparency = 1
        textl.TextColor3 = Color3.fromRGB(139, 140, 144)
        local colorfilterframe = Instance.new("Frame", frame)
        colorfilterframe.Position = UDim2.new(0.5, 0, 0, 70)
        colorfilterframe.AnchorPoint = Vector2.new(0.5, 0)
        colorfilterframe:AddTag("NoTween")
        colorfilterframe.BackgroundTransparency = 1
        colorfilterframe.Size = UDim2.new(1, -16, 0, 0)
        local layot = Instance.new("UIListLayout", colorfilterframe)
        layot.Padding = UDim.new(0, 16)
        for i, v in pairs(languages) do
            local langbutton = Instance.new("TextButton", colorfilterframe)
            langbutton.Name = v
            langbutton.Text = ""
            langbutton.AutoButtonColor = false
            langbutton.BackgroundColor3 = Color3.fromRGB(19, 22, 27)
            langbutton.Size = UDim2.new(1, 0, 0, 76)
            local corner = Instance.new("UICorner", langbutton)
            corner.CornerRadius = UDim.new(0, 9)
            local text = Instance.new("TextLabel", langbutton)
            text.BackgroundTransparency = 1
            text.Position = UDim2.new(0, 21, 0, 12)
            text.TextColor3 = Color3.new(1, 1, 1)
            text.FontFace = shared.RiseFonts.AppleUISemibold
            text.TextWrapped = false
            text.Name = "LanguageTitle"
            text.RichText = true
            text.Text = (GuiLibrary.Settings.Language == v and Lang["AvailableName"][i] .. "  " ..
                            Lang["AvailableFlag"][i] or "<font color=\"rgb(255, 255, 255)\">" ..
                            Lang["AvailableName"][i] .. "  " .. Lang["AvailableFlag"][i] .. "</font>")
            text.Size = UDim2.new(0, 0, 0, 19)
            text.TextSize = 21
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.TextYAlignment = Enum.TextYAlignment.Top
            table.insert(GuiLibrary.GradientItems, text)
            local desc = Instance.new("TextLabel", langbutton)
            desc.BackgroundTransparency = 1
            desc.TextColor3 = Color3.fromRGB(114, 113, 116)
            desc.FontFace = shared.RiseFonts.AppleUISemibold
            desc.Position = UDim2.new(0, 21, 0, 47)
            desc.Size = UDim2.new(0, 0, 0, 16)
            desc.TextSize = 18
            desc.Text = Lang["AvailableDesc"][i]
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.TextYAlignment = Enum.TextYAlignment.Top
            desc.TextWrapped = false
            langbutton.MouseButton1Click:Connect(function()
                if GuiLibrary.Settings.Language == v then
                    return
                end
                colorfilterframe[GuiLibrary.Settings.Language].LanguageTitle.Text =
                    "<font color=\"rgb(255, 255, 255)\">" ..
                        Lang["AvailableName"][table.find(Lang["Available"], GuiLibrary["Settings"]["Language"])] .. "  " ..
                        Lang["AvailableFlag"][table.find(Lang["Available"], GuiLibrary["Settings"]["Language"])] ..
                        "</font>"
                GuiLibrary.Settings.Language = v
                text.Text = (v == GuiLibrary.Settings.Language and Lang["AvailableName"][i] .. "  " ..
                                Lang["AvailableFlag"][i] or "<font color=\"rgb(255, 255, 255)\">" ..
                                Lang["AvailableName"][i] .. "  " .. Lang["AvailableFlag"][i] .. "</font>")
                GuiLibrary.UpdateHudEvent:Fire(true)
                local px2 = Instance.new("GetTextBoundsParams")
                px2.Size = 18
                px2.Font = shared.RiseFonts.AppleUI
                px2.Width = 99999
                px2.Text = Lang:GetLanguage(v)["maingui.winlist.language"]
                selectedwindow.Size = UDim2.new(0, 48 + textService:GetTextBoundsAsync(px2).X, 0, 30)
            end)
        end
    end,
    ["CaS"] = function(frame)
        frame.UIListLayout:Destroy()
        local stupiduselesslilframe = Instance.new("Frame", frame)
        stupiduselesslilframe.BackgroundColor3 = Color3.fromRGB(14, 16, 21)
        stupiduselesslilframe.Position = UDim2.new(0.5, 0, 0, 6)
        stupiduselesslilframe.AnchorPoint = Vector2.new(0.5, 0)
        stupiduselesslilframe.Size = UDim2.new(1, -12, 0, 220)
        local lilfrc = Instance.new("UICorner", stupiduselesslilframe)
        lilfrc.CornerRadius = UDim.new(0, 17)
        local featured = Instance.new("TextLabel", frame)
        featured.BackgroundTransparency = 1
        featured.Text = "<font color=\"rgb(255, 255, 255)\">Featured Configs</font>  0"
        featured.FontFace = shared.RiseFonts.AppleUISemibold
        featured.Position = UDim2.new(0, 12, 0, 265)
        featured.TextWrapped = false
        featured.RichText = true
        featured.TextSize = 19
        featured.Size = UDim2.new(0, 0, 0, 17)
        featured.TextXAlignment = Enum.TextXAlignment.Left
        featured:AddTag("NotAffectedByYPos")
        table.insert(GuiLibrary.ThemesItems, featured)
        table.insert(GuiLibrary.RainbowItems, featured)
        local featuredcfgs = Instance.new("ScrollingFrame", frame)
        featuredcfgs.BackgroundTransparency = 1
        featuredcfgs.ClipsDescendants = false
        featuredcfgs.Position = UDim2.new(0, 12, 0, 307)
        featuredcfgs.Size = UDim2.new(0, 559, 0, 173)
        featuredcfgs.ScrollingDirection = Enum.ScrollingDirection.X
        featuredcfgs.AutomaticCanvasSize = Enum.AutomaticSize.X
        featuredcfgs.ScrollBarThickness = 0
        local uipagelayout = Instance.new("UIPageLayout", featuredcfgs)
        uipagelayout.Animated = true
        uipagelayout.Circular = false
        uipagelayout.EasingStyle = Enum.EasingStyle.Back
        uipagelayout.EasingDirection = Enum.EasingDirection.Out
        uipagelayout.Padding = UDim.new(0, -366)
        uipagelayout.TweenTime = 0.5
        uipagelayout.FillDirection = Enum.FillDirection.Horizontal
        uipagelayout.VerticalAlignment = Enum.VerticalAlignment.Center
        local yourcfg = Instance.new("TextLabel", frame)
        yourcfg.BackgroundTransparency = 1
        yourcfg.FontFace = shared.RiseFonts.AppleUISemibold
        yourcfg.Position = UDim2.new(0, 12, 0, 519)
        yourcfg.TextXAlignment = Enum.TextXAlignment.Left
        yourcfg.TextWrapped = false
        yourcfg.RichText = true
        yourcfg.TextSize = 19
        yourcfg.Size = UDim2.new(0, 0, 0, 17)
        yourcfg:AddTag("NotAffectedByYPos")
        table.insert(GuiLibrary.ThemesItems, yourcfg)
        table.insert(GuiLibrary.RainbowItems, yourcfg)
        local ycfgs = Instance.new("ScrollingFrame", frame)
        ycfgs.BackgroundTransparency = 1
        ycfgs.ClipsDescendants = false
        ycfgs.Position = UDim2.new(0, 12, 0, 561)
        ycfgs.Size = UDim2.new(0, 559, 0, 173)
        ycfgs.ScrollingDirection = Enum.ScrollingDirection.X
        ycfgs.AutomaticCanvasSize = Enum.AutomaticSize.X
        ycfgs.ScrollBarThickness = 0
        task.spawn(function()
            repeat
                local cfgCount = 0
                local configs = {}
                for i, v in pairs(listfiles("rise/configs")) do
                    if string.find(v, tostring(shared.CustomRiseSave or game.PlaceId)) then
                        cfgCount = cfgCount + 1
                        local z2val, _unused = string.gsub(v, tostring(shared.CustomRiseSave or game.PlaceId), "")
                        local z3val, _unused = string.gsub(z2val, "rise/configs/", "")
                        local val, _unused = string.gsub(z3val, ".rscfg", "")
                        table.insert(configs, val)
                    end
                end
                yourcfg.Text = "<font color=\"rgb(255, 255, 255)\">Your Configs</font>  " .. cfgCount
                for i, v in pairs(configs) do
                    if not ycfgs:FindFirstChild(v) then
                        local configbutton = Instance.new("TextButton", ycfgs)
                        configbutton.Text = ""
                        configbutton.Name = v
                        configbutton.Size = UDim2.new(0, 137, 0, 137)
                        configbutton.BackgroundColor3 = Color3.fromRGB(18, 21, 27)
                        local corner = Instance.new("UICorner", configbutton)
                        corner.CornerRadius = UDim.new(0, 13)
                        local configname = Instance.new("TextLabel", configbutton)
                        configname.FontFace = shared.RiseFonts.AppleUISemibold
                        configname.AnchorPoint = Vector2.new(0.5, 0)
                        configname.Size = UDim2.new(1, 0, 0, 19)
                        configname.TextSize = 21
                        configname.TextColor3 = Color3.new(1, 1, 1)
                        configname.Text = v:sub(1, 1):upper() .. v:sub(2)
                        configname.BackgroundTransparency = 1
                        configname.Position = UDim2.new(0.5, 0, 0, 70)
                        local ctl = Instance.new("TextLabel", configbutton)
                        ctl.FontFace = shared.RiseFonts.AppleUI
                        ctl.Size = UDim2.new(1, 0, 0, 16)
                        ctl.TextSize = 18
                        configbutton.AutoButtonColor = false
                        ctl.AnchorPoint = Vector2.new(0.5, 0)
                        ctl.Position = UDim2.new(0.5, 0, 0, 103)
                        ctl.Text = "Click to load"
                        ctl.BackgroundTransparency = 1
                        ctl.TextColor3 = Color3.fromRGB(139, 140, 143)
                        configbutton.MouseButton1Click:Connect(function()
                            GuiLibrary.LoadSettings(nil, v)
                            GuiLibrary.ShowNotification("Config", "Loaded " .. v .. " config", 2)
                        end)
                    end
                end
                for i, v in pairs(ycfgs:GetChildren()) do
                    if not table.find(configs, v.Name) then
                        v:Destroy()
                    end
                end
                task.wait(1)
            until GuiLibrary == nil
        end)
        local wer = Instance.new("UIPageLayout", ycfgs)
        wer.Animated = true
        wer.Name = httpService:GenerateGUID(true)
        wer.Circular = false
        wer.EasingStyle = Enum.EasingStyle.Back
        wer.EasingDirection = Enum.EasingDirection.Out
        wer.Padding = UDim.new(0, -366)
        wer.TweenTime = 0.5
        wer.FillDirection = Enum.FillDirection.Horizontal
        wer.VerticalAlignment = Enum.VerticalAlignment.Center
        local scrs = Instance.new("TextLabel", frame)
        scrs.BackgroundTransparency = 1
        scrs.FontFace = shared.RiseFonts.AppleUISemibold
        scrs.Position = UDim2.new(0, 12, 0, 772)
        scrs.TextWrapped = false
        scrs.Text = "Your Scripts"
        scrs.TextColor3 = Color3.new(1, 1, 1)
        scrs.RichText = true
        scrs.TextSize = 19
        scrs.Size = UDim2.new(0, 0, 0, 17)
        scrs.TextXAlignment = Enum.TextXAlignment.Left
    end,
    ["Search"] = function(scrframe)
        local frame = scrframe.Parent
        scrframe:Destroy()
        frame.UIPadding:Destroy()
        local up = Instance.new("UIPadding", frame)
        up.PaddingBottom = UDim.new(0, 14)
        up.PaddingTop = UDim.new(0, 70)
        scrframe = Instance.new("ScrollingFrame", frame)
        scrframe.AnchorPoint = Vector2.new(0.5, 0.5)
        scrframe.BackgroundTransparency = 9999
        scrframe.Position = UDim2.new(0.5, 0, 0.5, 0)
        scrframe.Size = UDim2.new(1, -12, 1, 0)
        scrframe.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrframe.ScrollBarImageColor3 = Color3.fromRGB(39, 72, 77)
        scrframe.ScrollBarThickness = 2
        scrframe.ClipsDescendants = false
        scrframe.ScrollingDirection = Enum.ScrollingDirection.Y
        scrframe.CanvasSize = UDim2.new(0, 0, 0, 0)
        local cf = Instance.new("Frame", scrframe)
        cf.AnchorPoint = Vector2.new(0.5, 0)
        cf.BackgroundTransparency = 1
        cf.Position = UDim2.new(0.5, 0, 0, 0)
        cf.Size = UDim2.new(0, 0, 0, 0)
        local cfl = Instance.new("UIListLayout", cf)
        cfl.Padding = UDim.new(0, 14)
        cfl.SortOrder = Enum.SortOrder.LayoutOrder
        cfl.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local textlabel = Instance.new("TextLabel", scrframe)
        textlabel.AnchorPoint = Vector2.new(0.5, 0)
        textlabel.BackgroundTransparency = 1
        textlabel.Position = UDim2.new(0.5, 0, 0, -37)
        textlabel.Size = UDim2.new(1, 0, 0, 19)
        textlabel.FontFace = shared.RiseFonts.AppleUI
        textlabel.TextColor3 = Color3.fromRGB(69, 72, 78)
        textlabel.Text = "Start typing to search..."
        textlabel.TextSize = 21
        local indicatorframe = Instance.new("Frame", textlabel)
        indicatorframe:AddTag("NoTween")
        indicatorframe.BackgroundTransparency = 1
        indicatorframe.AnchorPoint = Vector2.new(0.5, 0)
        indicatorframe.Position = UDim2.new(0.5, 0, 0, 0)
        indicatorframe.Size = UDim2.new(0, 300, 0, 19) -- roblox android typing indicator stink mf
        local indicator = Instance.new("Frame", indicatorframe)
        indicator.AnchorPoint = Vector2.new(0, 0)
        indicator:AddTag("NoTween")
        indicator.Position = UDim2.new(0, 0, 0, 0)
        indicator.Size = UDim2.new(0, 2, 0, 19)
        indicator.BackgroundColor3 = Color3.new(1, 1, 1)
        indicator.Visible = false
        task.spawn(function()
            repeat
                tweenService:Create(indicator, TweenInfo.new(0.5), {
                    BackgroundTransparency = 1
                }):Play()
                task.wait(.5)
                tweenService:Create(indicator, TweenInfo.new(0.5), {
                    BackgroundTransparency = 0
                }):Play()
                task.wait(.5)
            until GuiLibrary == nil
        end)
        searchtextboxinit = function(val)
            local searchapi = requestinput({
                ["Default"] = val,
                ["TextSize"] = 21,
                ["MaxTextWidth"] = 300
            })
            local indicatorlocation = -1
            indicator.Visible = true
            repeat
                local value = searchapi.Value
                if value == "" then
                    indicatorlocation = -1
                    textlabel.Text = "Start typing to search..."
                    textlabel.TextColor3 = Color3.fromRGB(69, 72, 78)
                else
                    indicatorlocation = searchapi.Width
                    textlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    textlabel.Text = value
                end
                if indicatorlocation == -1 then
                    tweenService:Create(indicator, TweenInfo.new(0.1), {
                        AnchorPoint = Vector2.new(0, 0),
                        Position = UDim2.new(0, 0, 0, 0)
                    }):Play()
                else
                    tweenService:Create(indicator, TweenInfo.new(0.1), {
                        AnchorPoint = Vector2.new(0.5, 0),
                        Position = UDim2.new(0.5, 0, 0, indicatorlocation / 2)
                    }):Play()
                end
                task.wait()
            until not GuiLibrary.AwaitingTextInput
            indicator.Visible = false
        end
        table.insert(GuiLibrary.Connections, inputService.InputBegan:Connect(function(input)
            local accepted = "abcdefghijklmnopqrstuvwxyz1234567890"
            local value = tostring(input.KeyCode):gsub("Enum.KeyCode.", ""):lower()
            if input.KeyCode == Enum.KeyCode.Space or accepted:find(value) and vis and selectedwindowoption == "Search" and value ~= GuiLibrary.Settings.Keybind:lower() then
                local updatevalue = ""
                if input.KeyCode ~= Enum.KeyCode.Space then
                    textlabel.Text = value
                    updatevalue = value
                end
                searchtextboxinit(updatevalue)
            end
        end))
    end
}
selectedwindow = Instance.new("ImageLabel", winlist)
selectedwindow.Image = getriseasset("Window.png")
selectedwindow.BackgroundTransparency = 1
local px = Instance.new("GetTextBoundsParams")
px.Size = 18
px.Font = shared.RiseFonts.AppleUI
px.Width = 99999
px.Text = keys["maingui.winlist.search"]
selectedwindow.Size = UDim2.new(0, 48 + textService:GetTextBoundsAsync(px).X, 0, 30)
selectedwindow.Position = UDim2.new(0, 20, 0, selectedpos[1])
selectedwindow.ZIndex = 0
selectedwindow.ScaleType = Enum.ScaleType.Slice
selectedwindow.ImageTransparency = .25
selectedwindow.SliceScale = 1
selectedwindow:AddTag("NotAffectedByYPos")
selectedwindow.Name = "SelectedWindow"
selectedwindow.SliceCenter = Rect.new(Vector2.new(9, 0), Vector2.new(21, 30))
table.insert(GuiLibrary.GradientItems, selectedwindow)
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
local windowdescendantstweening = false
selectedwindowoption = "Search"
windowbuttonhandle = function(oldname, newname, focus)
    local indexes =
        {"Search", "Combat", "Movement", "Player", "Render", "Exploit", "Ghost", "CaS", "Themes", "Language"}
    if oldname == newname or selectedwindowoption == newname or windowdescendantstweening then
        return false
    end
    local winbutton = {
        Old = winlist[oldname],
        New = winlist[newname]
    }
    local winframe = {
        Old = windowshit[oldname],
        New = windowshit[newname]
    }
    -- This function tweens the window buttons
    task.spawn(function()
        local cs = selectedwindow:Clone()
        cs.Parent = winlist
        tweenService:Create(cs, TweenInfo.new(0.3), {
            ImageTransparency = 1
        }):Play()
        tweenService:Create(winbutton.Old.TNTMinecart, TweenInfo.new(0.3), {
            Position = UDim2.new(0, 24, 0.5, 0),
            TextColor3 = Color3.fromRGB(205, 204, 207)
        }):Play()
        tweenService:Create(winbutton.Old.TNTMinecart:FindFirstChildWhichIsA("TextLabel"), TweenInfo.new(0.3), {
            TextColor3 = Color3.fromRGB(205, 204, 207)
        }):Play()
        task.delay(0.3, function()
            cs:Destroy()
        end)
        selectedwindow.Position = UDim2.new(0, 20, 0, selectedpos[table.find(indexes, newname)])
        selectedwindow.ImageTransparency = 1
        local px = Instance.new("GetTextBoundsParams")
        px.Size = 18
        px.Font = shared.RiseFonts.AppleUI
        px.Width = 99999
        px.Text = winbutton.New.TNTMinecart.TextLabel.Text
        selectedwindow.Size = UDim2.new(0, 48 + textService:GetTextBoundsAsync(px).X, 0, 30)
        tweenService:Create(selectedwindow, TweenInfo.new(0.3), {
            ImageTransparency = 0.25
        }):Play()
        tweenService:Create(winbutton.New.TNTMinecart, TweenInfo.new(0.3), {
            Position = UDim2.new(0, 32, 0.5, 0),
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
        tweenService:Create(winbutton.New.TNTMinecart.TextLabel, TweenInfo.new(0.3), {
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)
    -- This function hides the old window
    task.spawn(function()
        windowdescendantstweening = true
        for i, v in pairs(winframe.Old.ScrollingFrame:GetDescendants()) do
            if not v:HasTag("NoTween") then
                local property = nil
                local value = 1
                if v:HasTag("SpecialTween") then
                    property = "TextTransparency"
                else
                    if v:IsA("TextLabel") or v:IsA("TextBox") then
                        property = "TextTransparency"
                    elseif v:IsA("Frame") or v:IsA("TextButton") then
                        property = "BackgroundTransparency"
                    elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
                        property = "ImageTransparency"
                    elseif v:IsA("UIStroke") then
                        property = "Transparency"
                    end
                end
                if property ~= nil then
                    tweenService:Create(v, TweenInfo.new(0.2), {
                        [property] = value
                    }):Play()
                    task.delay(0.2, function()
                        v[property] = 0
                    end)
                end
            end
        end
        task.delay(0.2, function()
            winframe.Old.Visible = false
            -- This function shows the new window
            task.spawn(function()
                winframe.New.Visible = true
                for i, v in pairs(winframe.New.ScrollingFrame:GetDescendants()) do
                    if not v:HasTag("NoTween") then
                        local property = nil
                        local value = 0
                        if v:HasTag("SpecialTween") then
                            property = "TextTransparency"
                        else
                            if v:IsA("TextLabel") or v:IsA("TextBox") then
                                property = "TextTransparency"
                            elseif v:IsA("Frame") or v:IsA("TextButton") then
                                property = "BackgroundTransparency"
                            elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
                                property = "ImageTransparency"
                            elseif v:IsA("UIStroke") then
                                property = "Transparency"
                            end
                        end
                        if property ~= nil then
                            v[property] = 1
                            tweenService:Create(v, TweenInfo.new(0.2), {
                                [property] = value
                            }):Play()
                        end
                    end
                end
                task.delay(0.2, function()
                    windowdescendantstweening = false
                end)
            end)
        end)
    end)
    selectedwindowoption = newname
end
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
    table.insert(GuiLibrary.TranslateItems, cart)
    cart.Text = icon[v][2]
    cart.TextColor3 = (v == "Search" and Color3.new(1, 1, 1) or Color3.fromRGB(205, 204, 207))
    cart.TextXAlignment = Enum.TextXAlignment.Left
    cart.TextYAlignment = Enum.TextYAlignment.Center
    local lab = Instance.new("TextLabel", cart)
    lab:SetAttribute("RiseLanguageKey", "maingui.winlist." .. v:lower())
    table.insert(GuiLibrary.TranslateItems, lab)
    lab.AnchorPoint = Vector2.new(0, 0.5)
    lab.FontFace = shared.RiseFonts.AppleUI
    lab.BackgroundTransparency = 1
    lab.Position = UDim2.new(1, 7, 0.5, 0)
    lab.Size = UDim2.new(0, 2000, 0, 15)
    lab.Text = v
    lab.TextColor3 = (v == "Search" and Color3.new(1, 1, 1) or Color3.fromRGB(205, 204, 207))
    lab.TextSize = 18
    lab.TextXAlignment = Enum.TextXAlignment.Left
    textbtn.MouseButton1Click:Connect(function()
        windowbuttonhandle(selectedwindowoption, v)
    end)
    local frame = Instance.new("Frame", windowshit)
    frame.Name = v
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
    uilistlayout.SortOrder = Enum.SortOrder.Name
    uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    if initWindowFunction[v] then
        task.spawn(function()
            initWindowFunction[v](scrframe)
        end)
    end
    windowapi["CreateOptionsButton"] = function(argsmaintable)
        local buttonapi = {
            ["Type"] = "OptionsButton",
            NoSave = argsmaintable["NoSave"] ~= nil and argsmaintable["NoSave"] or true,
            ["Name"] = argsmaintable["Name"] or "Example Settings",
            ["Description"] = argsmaintable["Description"] or "An example script to teach how to use rise's settings.",
            ["Suffix"] = nil,
            ["Enabled"] = argsmaintable["Enabled"] or false,
            ["Keybind"] = nil,
            ["Function"] = argsmaintable["Function"] or function()
            end,
            ["Category"] = v
        }
        local buttonexpanded = false
        local buttonobj = Instance.new("TextButton", scrframe)
        buttonapi.Object = buttonobj
        buttonobj.Text = ""
        buttonobj.Name = buttonapi.Name
        buttonapi["Object"] = buttonobj
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
        name.Text = (buttonapi.Enabled and buttonapi.Name or "<font color=\"rgb(180, 180, 180)\">" .. buttonapi.Name ..
                        "</font>") .. "  <font size=\"15\" color=\"rgb(70, 66, 77)\">(" .. v .. ")</font>"
        name:SetAttribute("RiseLanguageKey", "optionsbutton." .. buttonapi.Name:lower() .. ".name")
        GuiLibrary.LanguageFunctions["OptionsButton" .. buttonapi.Name] = function(trans)
            name.Text = (buttonapi.Enabled and trans or "<font color=\"rgb(180, 180, 180)\">" .. trans .. "</font>") ..
                            "  <font size=\"15\" color=\"rgb(70, 66, 77)\">(" .. keys["maingui.winlist." .. v:lower()] ..
                            ")</font>"
        end
        name:SetAttribute("RLReplacement", "OptionsButton" .. buttonapi.Name)
        name.RichText = true
        name.TextColor3 = Color3.new(1, 1, 1)
        table.insert(GuiLibrary.GradientItems, name)
        table.insert(GuiLibrary.TranslateItems, name)
        name.TextSize = 20
        name.TextXAlignment = Enum.TextXAlignment.Left
        local desc = Instance.new("TextLabel", buttonobj)
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextSize = 16
        desc.TextColor3 = Color3.fromRGB(88, 88, 88)
        desc.Text = buttonapi.Description
        desc.FontFace = shared.RiseFonts.AppleUI
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, 12, 0, 48)
        desc.Size = UDim2.new(0, 2000, 0, 14)
        desc:SetAttribute("RiseLanguageKey", "optionsbutton." .. buttonapi.Name:lower() .. ".desc")
        task.spawn(function()
            task.wait()
            table.insert(GuiLibrary.TranslateItems, desc)
        end)
        buttonapi["SetKeybind"] = function(key)
            buttonapi.Keybind = key
        end
        buttonapi["ToggleButton"] = function(toggle, silent)
            if buttonapi.Enabled == toggle then
                return
            end
            buttonapi.Enabled = (toggle or not buttonapi["Enabled"])
            name.Text =
                (buttonapi.Enabled and buttonapi.Name or "<font color=\"rgb(180, 180, 180)\">" .. buttonapi.Name ..
                    "</font>") .. "  <font size=\"15\" color=\"rgb(70, 66, 77)\">(" .. v .. ")</font>"
            buttonapi["Function"](buttonapi.Enabled)
            if not silent then
                GuiLibrary["ShowNotification"]("Toggled", "Toggled " .. buttonapi["Name"] .. " " ..
                    (buttonapi["Enabled"] and "on" or "off"))
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
        local options = Instance.new("Frame", buttonobj)
        options.BackgroundTransparency = 1
        options.ClipsDescendants = true
        options.Position = UDim2.new(0.5, 0, 0, 75)
        options.AnchorPoint = Vector2.new(0.5, 0)
        options.Size = UDim2.new(1, -26, 0, 0)
        options:AddTag("NoTween")
        buttonapi["OptionsObject"] = options
        local list = Instance.new("UIListLayout", options)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.HorizontalAlignment = Enum.HorizontalAlignment.Center
        list.Padding = UDim.new(0, 12)
        buttonobj.MouseButton2Click:Connect(function()
            buttonexpanded = not buttonexpanded
            task.spawn(function()
                buttonobj.BackgroundColor3 = Color3.fromRGB(16, 18, 23)
                task.wait(.1)
                buttonobj.BackgroundColor3 = Color3.fromRGB(18, 21, 27)
            end)
            options.AutomaticSize = options.AutomaticSize == Enum.AutomaticSize.None and Enum.AutomaticSize.Y or
                                        Enum.AutomaticSize.None
            buttonobj:TweenSize(UDim2.new(0, 566, 0, (options.AutomaticSize == Enum.AutomaticSize.None and 75 or
                (options.AbsoluteSize.Y ~= 0 and (85 + options.AbsoluteSize.Y) or 75))), nil, nil, 0.1)
            for i2, v2 in pairs(options:GetDescendants()) do
                local prop = ""
                if v2:IsA("TextLabel") or v2:IsA("TextButton") or v2:IsA("TextBox") then
                    prop = "TextTransparency"
                elseif v2:IsA("Frame") then
                    prop = "BackgroundTransparency"
                end
                if v2:HasTag("NoTween") or prop == "" then
                    return
                end
                v2[prop] = options.AutomaticSize == Enum.AutomaticSize.None and 1 or 0
                tweenService:Create(v2, TweenInfo.new(0.15), {
                    [prop] = options.AutomaticSize == Enum.AutomaticSize.None and 0 or 1
                }):Play()
            end
        end)
        options.Changed:Connect(function(property)
            if property == "AbsoluteSize" and buttonexpanded and not guitweening then
                buttonobj:TweenSize(UDim2.new(0, 566, 0, (85 + options.AbsoluteSize.Y)), nil, nil, 0.1)
            end
        end) -- so we don't have to do shit
        buttonapi["CreateLabel"] = function(argstable)
            local subdata = argstable["SubData"]
            local conditiontype = nil
            local conditionname = nil
            local conditionname2 = nil
            local conditionvalue = nil
            if subdata ~= nil and type(subdata) == "table" then
                conditiontype = argstable["SubData"]["ConditionType"]
                conditionname = argstable["SubData"]["ConditionMainName"]
                conditionname2 = argstable["SubData"]["ConditionName"]
                conditionvalue = subdata["ConditionValue"]
            end
            local fr = Instance.new("Frame", options)
            fr:AddTag("NoTween")
            fr.BackgroundTransparency = 1
            fr.Size = UDim2.new(1, 0, 0, 15)
            fr.LayoutOrder = #options:GetChildren() - 1
            if conditiontype and conditionname and conditionvalue then
                task.spawn(function()
                    local obj = GuiLibrary.ObjectCanBeSaved[conditionname .. (conditionname2 or "") .. conditiontype]
                    if obj then
                        local value = obj["Enabled"] or obj["Value"]
                        if value == conditionvalue then
                            fr.Visible = true
                        else
                            fr.Visible = false
                        end
                    end
                end)
            end
            local label = Instance.new("TextLabel", fr)
            label.AnchorPoint = Vector2.new(0.5, 0)
            label.Position = UDim2.new(0.5, 0, 0, 0)
            label.Size = UDim2.new(1, subdata ~= nil and -38 or 0, 1, 0)
            label.BackgroundTransparency = 1
            label.FontFace = shared.RiseFonts.AppleUI
            label.Text = argstable["Name"]
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            if conditiontype and conditionname and conditionvalue then
                task.spawn(function()
                    repeat
                        local obj =
                            GuiLibrary.ObjectCanBeSaved[conditionname .. (conditionname2 or "") .. conditiontype]
                        if obj then
                            local value = obj["Enabled"] or obj["Value"]
                            if value == conditionvalue then
                                fr.Visible = true
                            else
                                fr.Visible = false
                            end
                        end
                        task.wait(0.05)
                    until GuiLibrary == nil
                end)
            end
        end

        buttonapi["CreateToggle"] = function(argstable)
            local api = {
                ["Type"] = "Toggle",
                ["Name"] = argstable["Name"] or "Example",
                ["Enabled"] = argstable["Enabled"] or false,
                ["Function"] = argstable["Function"] or function(_unused)
                end,
                Parent = argsmaintable["Name"]
            }
            local subdata = argstable["SubData"]
            local conditiontype = nil
            local conditionname = nil
            local conditionname2 = nil
            local conditionvalue = nil
            if subdata ~= nil and type(subdata) == "table" then
                conditiontype = argstable["SubData"]["ConditionType"]
                conditionname = argstable["SubData"]["ConditionMainName"]
                conditionname2 = argstable["SubData"]["ConditionName"]
                conditionvalue = subdata["ConditionValue"]
            end
            local label = Instance.new("TextButton", options)
            label.Size = UDim2.new(1, subdata ~= nil and -38 or 0, 0, 15)
            label.LayoutOrder = #options:GetChildren() - 1 -- uilistlayout
            label.FontFace = shared.RiseFonts.AppleUI
            label.Text = api.Name
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            label:AddTag("SpecialTween")
            if conditiontype and conditionname and conditionvalue then
                task.spawn(function()
                    local obj = GuiLibrary.ObjectCanBeSaved[conditionname .. (conditionname2 or "") .. conditiontype]
                    if obj then
                        local value = obj["Enabled"] or obj["Value"]
                        if value == conditionvalue then
                            label.Visible = true
                        else
                            label.Visible = false
                        end
                    end
                end)
            end
            local param = Instance.new "GetTextBoundsParams"
            param.Font = shared.RiseFonts.AppleUI
            param.Size = 16
            param.Text = api.Name
            param.Width = 99999
            local toggledx = Instance.new("Frame", label)
            toggledx.AnchorPoint = Vector2.new(0, 0.5)
            toggledx.BackgroundColor3 = Color3.fromRGB(25, 26, 35)
            toggledx.Position = UDim2.new(0, textService:GetTextBoundsAsync(param).X + 9, 0.5, 0)
            toggledx.Size = UDim2.new(0, 10, 0, 10)
            local tdc = Instance.new("UICorner", toggledx)
            tdc.CornerRadius = UDim.new(1, 0)
            local fra = Instance.new("Frame", toggledx)
            fra.BackgroundColor3 = ThemeService.Themes[GuiLibrary.Settings.Theme][1]
            fra:AddTag("NotAffectedByYPos")
            table.insert(GuiLibrary.ThemesItems, fra)
            table.insert(GuiLibrary.RainbowItems, fra)
            task.spawn(function()
                fra.BackgroundColor3 = ThemeService.Themes[GuiLibrary.Settings.Theme][1]
            end)
            fra.AnchorPoint = Vector2.new(0.5, 0.5)
            fra.Position = UDim2.new(0.5, 0, 0.5, 0)
            fra.Size = api["Enabled"] and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 0, 0, 0)
            tdc:Clone().Parent = fra
            if api["Enabled"] then
                api["Function"](true)
            end
            api["ToggleButton"] = function(enabled)
                if api.Enabled == enabled then
                    return
                end
                api["Enabled"] = enabled == nil and (not api["Enabled"]) or enabled or false
                fra:TweenSize(UDim2.new(0, api["Enabled"] and 10 or 0, 0, api["Enabled"] and 10 or 0), nil, nil, 0.15,
                    true)
                api["Function"](api["Enabled"])
            end
            if conditiontype and conditionname and conditionvalue then
                task.spawn(function()
                    repeat
                        local obj =
                            GuiLibrary.ObjectCanBeSaved[conditionname .. (conditionname2 or "") .. conditiontype]
                        if obj then
                            local value = obj["Enabled"] or obj["Value"]
                            if value == conditionvalue then
                                label.Visible = true
                            else
                                label.Visible = false
                            end
                        end
                        task.wait(0.05)
                    until GuiLibrary == nil
                end)
            end
            label.MouseButton1Click:Connect(api["ToggleButton"])
            GuiLibrary.ObjectCanBeSaved[buttonapi.Name .. api.Name .. "Toggle"] = api
            return api
        end

        buttonapi["CreateSlider"] = function(argstable)
            local api = {
                ["Type"] = "Slider",
                ["Name"] = argstable["Name"] or "Example",
                ["Value"] = argstable["Value"] or 0, -- default value auto.
                MaxValue = argstable["MaxValue"] or 100,
                MinValue = argstable["MinValue"] or 0,
                ["Function"] = argstable["Function"] or function(_unused)
                end,
                Parent = argsmaintable["Name"]
            }
            local subdata = argstable["SubData"]
            local conditiontype = nil
            local conditionname = nil
            local conditionname2 = nil
            local conditionvalue = nil
            if subdata ~= nil and type(subdata) == "table" then
                conditiontype = argstable["SubData"]["ConditionType"]
                conditionname = argstable["SubData"]["ConditionMainName"]
                conditionname2 = argstable["SubData"]["ConditionName"]
                conditionvalue = subdata["ConditionValue"]
            end
            local label = Instance.new("TextLabel", options)
            label.Size = UDim2.new(1, subdata ~= nil and -38 or 0, 0, 15)
            label.LayoutOrder = #options:GetChildren() - 1 -- uilistlayout
            label.FontFace = shared.RiseFonts.AppleUI
            label.Text = api.Name
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1 -- should not be able to be affected by the btn
            if conditiontype and conditionname and conditionvalue then
                task.spawn(function()
                    local obj = GuiLibrary.ObjectCanBeSaved[conditionname .. (conditionname2 or "") .. conditiontype]
                    if obj then
                        local value = obj["Enabled"] or obj["Value"]
                        if value == conditionvalue then
                            label.Visible = true
                        else
                            label.Visible = false
                        end
                    end
                end)
            end
            local param = Instance.new "GetTextBoundsParams"
            param.Font = shared.RiseFonts.AppleUI
            param.Size = 16
            param.Text = api.Name
            param.Width = 99999
            local bg = Instance.new("Frame", label)
            bg.Position = UDim2.new(0, textService:GetTextBoundsAsync(param).X + 9, 0.5, 0)
            bg.AnchorPoint = Vector2.new(0, 0.5)
            bg.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
            bg.Size = UDim2.new(0, 200, 0, 4)
            local cc = Instance.new("UICorner", bg)
            cc.CornerRadius = UDim.new(1, 0)
            local currentdec = (api.Value - api.MinValue) / (api.MaxValue - api.MinValue)
            local value = Instance.new("TextButton", bg)
            value.BackgroundColor3 = ThemeService.Themes[GuiLibrary.Settings.Theme][1]
            value:AddTag("NotAffectedByYPos")
            table.insert(GuiLibrary.ThemesItems, value)
            table.insert(GuiLibrary.RainbowItems, value)
            value.Position = UDim2.new(currentdec, 0, 0.5, 0)
            value.Text = ""
            value.Size = UDim2.new(0, 10, 0, 10)
            value.AnchorPoint = Vector2.new(0.5, 0.5)
            value.AutoButtonColor = false
            cc:Clone().Parent = value
            --[[local value2 = Instance.new("Frame", bg)
            value2.AnchorPoint = Vector2.new(0, 0.5)
            table.insert(GuiLibrary.DarkerThemesItems, value2)
            value2.Position = UDim2.new(0, 0, 0.5, 0)
            value2.Size = UDim2.new(currentdec, 0, 1, 0)
            value2.ZIndex = 0]]
            local textinput = Instance.new("TextBox", label)
            textinput.BackgroundTransparency = 1
            textinput.Position = UDim2.new(0, 219 + textService:GetTextBoundsAsync(param).X, 0.5, 0)
            textinput.Size = UDim2.new(0, 100, 0, 13)
            textinput.AnchorPoint = Vector2.new(0, 0.5)
            textinput.PlaceholderText = ""
            textinput.ClearTextOnFocus = false
            textinput.FontFace = shared.RiseFonts.AppleUI
            textinput.Text = tostring(api.Value)
            textinput.TextColor3 = Color3.new(1, 1, 1)
            textinput.TextSize = 16
            textinput.TextXAlignment = Enum.TextXAlignment.Left
            api["SetValue"] = function(val)
                if not val or val < api.MinValue or val > api.MaxValue then
                    textinput.Text = tostring(api.Value)
                    return false
                end
                api.Value = math.floor(val)
                textinput.Text = tostring(api.Value)
                currentdec = (api.Value - api.MinValue) / (api.MaxValue - api.MinValue)
                -- value2:TweenSize(UDim2.new(currentdec, 0, 1, 0), nil, nil, 0.1)
                value:TweenPosition(UDim2.new(currentdec, 0, 0.5, 0), nil, nil, 0.1)
                task.spawn(function()
                    api["Function"](api.Value)
                end)
                return true
            end
            value.MouseButton1Down:Connect(function()
                local x, y, xscale, yscale, xscale2 = RelativeXY(bg, inputService:GetMouseLocation())
                api["SetValue"](api.MinValue + ((api.MaxValue - api.MinValue) * xscale))
                local move, kill
                move = inputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local x, y, xscale, yscale, xscale2 = RelativeXY(bg, inputService:GetMouseLocation())
                        api["SetValue"](api.MinValue + ((api.MaxValue - api.MinValue) * xscale))
                    end
                end)
                kill = inputService.InputEnded:Connect(function(o)
                    if o.UserInputType == Enum.UserInputType.MouseButton1 then
                        move:Disconnect()
                        kill:Disconnect()
                    end
                end)
            end)
            textinput.FocusLost:Connect(function()
                local suc, res = pcall(function()
                    return tonumber(textinput.Text)
                end)
                api["SetValue"](res)
            end)
            if conditiontype and conditionname and conditionvalue then
                task.spawn(function()
                    repeat
                        local obj =
                            GuiLibrary.ObjectCanBeSaved[conditionname .. (conditionname2 or "") .. conditiontype]
                        if obj then
                            local valuex = obj["Enabled"] or obj["Value"]
                            if valuex == conditionvalue then
                                label.Visible = true
                            else
                                label.Visible = false
                            end
                        end
                        task.wait(0.05)
                    until GuiLibrary == nil
                end)
            end
            GuiLibrary.ObjectCanBeSaved[buttonapi.Name .. api.Name .. "Slider"] = api
            return api
        end

        buttonapi["CreateBoundsSlider"] = function(argstable)
            local api = {
                ["Type"] = "BoundsSlider",
                ["Name"] = argstable["Name"] or "Example",
                ["Value"] = {argstable["From"] or 0, argstable["To"] or (argstable["MaxValue"] or 100)}, -- default value auto.
                MaxValue = argstable["MaxValue"] or 100,
                MinValue = argstable["MinValue"] or 0,
                ["Function"] = argstable["Function"] or function(_unused)
                end,
                Parent = argsmaintable["Name"]
            }
            local subdata = argstable["SubData"]
            local ct, cn, cn2, cv
            if subdata ~= nil and type(subdata) == "table" then
                ct = subdata["ConditionType"]
                cn = subdata["ConditionMainName"]
                cn2 = subdata["ConditionName"]
                cv = subdata["ConditionValue"]
            end
            local label = Instance.new("TextLabel", options)
            label.Size = UDim2.new(1, subdata ~= nil and -38 or 0, 0, 15)
            label.LayoutOrder = #options:GetChildren() - 1
            label.FontFace = shared.RiseFonts.AppleUI
            label.Text = api.Name
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            if ct and cn and cv then
                task.spawn(function()
                    local obj = GuiLibrary.ObjectCanBeSaved[cn .. (cn2 or "") .. ct]
                    if obj then
                        local value = obj["Enabled"] or obj["Value"]
                        if value == cv then
                            label.Visible = true
                        else
                            label.Visible = false
                        end
                    end
                end)
            end
            local param = Instance.new "GetTextBoundsParams"
            param.Font = shared.RiseFonts.AppleUI
            param.Size = 16
            param.Text = api.Name
            param.Width = 99999
            local bg = Instance.new("Frame", label)
            bg.Position = UDim2.new(0, textService:GetTextBoundsAsync(param).X + 9, 0.5, 0)
            bg.AnchorPoint = Vector2.new(0, 0.5)
            bg.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
            bg.Size = UDim2.new(0, 200, 0, 4)
            local cc = Instance.new("UICorner", bg)
            cc.CornerRadius = UDim.new(1, 0)
            local currentdec1 = (api.Value[1] - api.MinValue) / (api.MaxValue - api.MinValue)
            local currentdec2 = (api.Value[2] - api.MinValue) / (api.MaxValue - api.MinValue)
            local value1 = Instance.new("TextButton", bg)
            value1:AddTag("NotAffectedByYPos")
            table.insert(GuiLibrary.ThemesItems, value1)
            table.insert(GuiLibrary.RainbowItems, value1)
            value1.BackgroundColor3 = ThemeService.Themes[GuiLibrary.Settings.Theme][1]
            value1.Position = UDim2.new(currentdec1, 0, 0.5, 0)
            value1.Text = ""
            value1.Size = UDim2.new(0, 10, 0, 10)
            value1.AnchorPoint = Vector2.new(0.5, 0.5)
            value1.AutoButtonColor = false
            cc:Clone().Parent = value1
            local value2 = value1:Clone()
            value2.Parent = bg
            value2:AddTag("NotAffectedByYPos")
            value2.Position = UDim2.new(currentdec2, 0, 0.5, 0)
            table.insert(GuiLibrary.ThemesItems, value2)
            table.insert(GuiLibrary.RainbowItems, value2)
            value2.BackgroundColor3 = ThemeService.Themes[GuiLibrary.Settings.Theme][1]
            local valuebackground = Instance.new("Frame", bg)
            valuebackground.AnchorPoint = Vector2.new(0, 0.5)
            valuebackground.Position = UDim2.new(currentdec1, 0, 0.5, 0)
            valuebackground:AddTag("NotAffectedByYPos")
            valuebackground.Size = UDim2.new(currentdec2 - currentdec1, 0, 1, 0)
            valuebackground.ZIndex = 0
            table.insert(GuiLibrary.DarkerThemesItems, valuebackground)
            table.insert(GuiLibrary.DarkerRainbowItems, valuebackground)
            local textinput = Instance.new("TextBox", label)
            textinput.BackgroundTransparency = 1
            textinput.Position = UDim2.new(0, 219 + textService:GetTextBoundsAsync(param).X, 0.5, 0)
            textinput.Size = UDim2.new(0, 200, 0, 13)
            textinput.AnchorPoint = Vector2.new(0, 0.5)
            textinput.PlaceholderText = ""
            textinput.ClearTextOnFocus = false
            textinput.FontFace = shared.RiseFonts.AppleUI
            textinput.Text = tostring(api.Value[1]) .. " " .. tostring(api.Value[2])
            textinput.TextColor3 = Color3.new(1, 1, 1)
            textinput.TextSize = 16
            textinput.TextXAlignment = Enum.TextXAlignment.Left
            api["SetValue"] = function(from, to)
                if not from or not to or from < api.MinValue or from > api.MaxValue or from > to or to < api.MinValue or
                    to > api.MaxValue then
                    textinput.Text = tostring(api.Value[1]) .. " " .. tostring(api.Value[2])
                    return false
                end
                api.Value = {math.floor(from), math.floor(to)}
                textinput.Text = tostring(api.Value[1]) .. " " .. tostring(api.Value[2])
                currentdec1 = (api.Value[1] - api.MinValue) / (api.MaxValue - api.MinValue)
                currentdec2 = (api.Value[2] - api.MinValue) / (api.MaxValue - api.MinValue)
                value1:TweenPosition(UDim2.new(currentdec1, 0, 0.5, 0), nil, nil, 0.1)
                value2:TweenPosition(UDim2.new(currentdec2, 0, 0.5, 0), nil, nil, 0.1)
                valuebackground:TweenSizeAndPosition(UDim2.new(currentdec2 - currentdec1, 0, 1, 0),
                    UDim2.new(currentdec1, 0, 0.5, 0), nil, nil, 0.1)
                task.spawn(function()
                    api["Function"](api.Value)
                end)
                return true
            end
            local function value1check(val)
                val = math.floor(val)
                local val2 = api.Value[2]
                if val > val2 then
                    val2 = val
                end
                api["SetValue"](val, val2)
            end
            value1.MouseButton1Down:Connect(function()
                local x, y, xs, ys, xs2 = RelativeXY(bg, inputService:GetMouseLocation())
                value1check((api.MinValue + ((api.MaxValue - api.MinValue) * xs)))
                local move, kill
                move = inputService.InputChanged:Connect(function(o)
                    if o.UserInputType == Enum.UserInputType.MouseMovement then
                        local x, y, xs, ys, xs2 = RelativeXY(bg, inputService:GetMouseLocation())
                        value1check((api.MinValue + ((api.MaxValue - api.MinValue) * xs)))
                    end
                end)
                kill = inputService.InputEnded:Connect(function(o)
                    if o.UserInputType == Enum.UserInputType.MouseButton1 then
                        move:Disconnect()
                        kill:Disconnect()
                    end
                end)
            end)
            local function value2check(val2)
                val2 = math.floor(val2)
                local val = api.Value[1]
                if val2 < val then
                    val = val2
                end
                api["SetValue"](val, val2)
            end
            value2.MouseButton1Down:Connect(function()
                local x, y, xs, ys, xs2 = RelativeXY(bg, inputService:GetMouseLocation())
                value2check((api.MinValue + ((api.MaxValue - api.MinValue) * xs)))
                local move, kill
                move = inputService.InputChanged:Connect(function(o)
                    if o.UserInputType == Enum.UserInputType.MouseMovement then
                        local x, y, xs, ys, xs2 = RelativeXY(bg, inputService:GetMouseLocation())
                        value2check((api.MinValue + ((api.MaxValue - api.MinValue) * xs)))
                    end
                end)
                kill = inputService.InputEnded:Connect(function(o)
                    if o.UserInputType == Enum.UserInputType.MouseButton1 then
                        move:Disconnect()
                        kill:Disconnect()
                    end
                end)
            end)
            textinput.FocusLost:Connect(function()
                local valx = textinput.Text
                if not valx:find(" ") then
                    local suc0, res0 = pcall(function()
                        return tonumber(valx)
                    end)
                    if suc0 and res0 ~= nil then
                        api["SetValue"](res0, res0)
                        return
                    end
                    textinput.Text = tostring(api.Value[1]) .. " " .. tostring(api.Value[2])
                    return
                end
                local vals = valx:split(" ")
                if #vals ~= 2 then
                    textinput.Text = tostring(api.Value[1]) .. " " .. tostring(api.Value[2])
                    return
                end
                local suc1, res1 = pcall(function()
                    return tonumber(vals[1])
                end)
                local suc2, res2 = pcall(function()
                    return tonumber(vals[2])
                end)
                api["SetValue"](res1, res2)
            end)
            if ct and cn and cv then
                task.spawn(function()
                    repeat
                        local obj = GuiLibrary.ObjectCanBeSaved[cn .. (cn2 or "") .. ct]
                        if obj then
                            local valuex = obj["Enabled"] or obj["Value"]
                            if valuex == cv then
                                label.Visible = true
                            else
                                label.Visible = false
                            end
                        end
                        task.wait(0.05)
                    until GuiLibrary == nil
                end)
            end
            GuiLibrary.ObjectCanBeSaved[buttonapi.Name .. api.Name .. "BoundsSlider"] = api
            return api
        end

        buttonapi["CreateTextBox"] = function(argstable)
            local api = {
                Name = argstable["Name"] or "Example",
                Type = "TextBox",
                Value = argstable["Value"] or "",
                Function = argstable["Function"] or function(_unused)
                end,
                Parent = argsmaintable["Name"]
            }
            local sd = argstable["SubData"]
            local ct, cn, cn2, cv
            if sd ~= nil and type(sd) == "table" then
                ct = sd["ConditionType"]
                cn = sd["ConditionMainName"]
                cn2 = sd["ConditionName"]
                cv = sd["ConditionValue"]
            end
            local item = Instance.new("TextBox", options)
            item.BackgroundTransparency = 1
            item.LayoutOrder = #options:GetChildren() - 1
            item.Size = UDim2.new(1, sd ~= nil and -38 or 0, 0, 15)
            item.FontFace = shared.RiseFonts.AppleUI
            item.Text = api.Value
            item.PlaceholderText = ""
            item.TextColor3 = Color3.new(1, 1, 1)
            item.ClearTextOnFocus = false
            item.TextSize = 16
            item.TextXAlignment = Enum.TextXAlignment.Left
            api["SetValue"] = function(val)
                api.Value = val
                task.spawn(function()
                    api["Function"](api.Value)
                end)
            end
            item.FocusLost:Connect(function()
                api.SetValue(item.Text)
            end)
            if ct and cn and cv then
                task.spawn(function()
                    local obj = GuiLibrary.ObjectCanBeSaved[cn .. (cn2 or "") .. ct]
                    if obj then
                        local valx = obj["Enabled"] or obj["Value"]
                        if valx == cv then
                            item.Visible = true
                        else
                            item.Visible = false
                        end
                    end
                end)
            end
            if ct and cn and cv then
                task.spawn(function()
                    repeat
                        local obj = GuiLibrary.ObjectCanBeSaved[cn .. (cn2 or "") .. ct]
                        if obj then
                            local valuex = obj["Enabled"] or obj["Value"]
                            if valuex == cv then
                                item.Visible = true
                            else
                                item.Visible = false
                            end
                        end
                        task.wait(0.05)
                    until GuiLibrary == nil
                end)
            end
            GuiLibrary.ObjectCanBeSaved[buttonapi.Name .. api.Name .. "TextBox"] = api
            return api
        end

        buttonapi["CreateMode"] = function(argstable)
            local api = {
                Type = "Mode",
                Options = argstable["Options"] or {"Mode1"},
                Name = argstable["Name"] or "Mode",
                Value = table.find(argstable["Options"] or {"Mode1"}, argstable["Value"]) or 1,
                Function = argstable["Function"] or function()
                end,
                SetSuffix = argstable["SetSuffix"] or false,
                Parent = argsmaintable["Name"]
            }
            local sd = argstable["SubData"]
            local ct, cn, cn2, cv
            if sd ~= nil and type(sd) == "table" then
                ct = sd["ConditionType"]
                cn = sd["ConditionMainName"]
                cn2 = sd["ConditionName"]
                cv = sd["ConditionValue"]
            end
            local item = Instance.new("TextButton", options)
            item.LayoutOrder = #options:GetChildren() - 1
            item.Size = UDim2.new(1, sd ~= nil and -38 or 0, 0, 15)
            item.FontFace = shared.RiseFonts.AppleUI
            item.Text = api.Name .. ": " .. api.Options[api.Value]
            item.TextColor3 = Color3.new(1, 1, 1)
            item.TextSize = 16
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.BackgroundTransparency = 1
            item:AddTag("SpecialTween")
            api["SetValue"] = function(val)
                if type(val) ~= "number" then
                    return false
                end
                if val < 1 then
                    val = #api.Options
                end
                if val > #api.Options then
                    val = 1
                end
                api.Value = val
                item.Text = api.Name .. ": " .. api.Options[api.Value]
                if api.SetSuffix then
                    buttonapi.Suffix = api.Options[api.Value]
                end
                return true
            end
            item.MouseButton1Click:Connect(function()
                api["SetValue"](api.Value + 1)
            end)
            item.MouseButton2Click:Connect(function()
                api["SetValue"](api.Value - 1)
            end)
            if ct and cn and cv then
                task.spawn(function()
                    local obj = GuiLibrary.ObjectCanBeSaved[cn .. (cn2 or "") .. ct]
                    if obj then
                        local valx = obj["Enabled"] or obj["Value"]
                        if valx == cv then
                            item.Visible = true
                        else
                            item.Visible = false
                        end
                    end
                end)
            end
            if ct and cn and cv then
                task.spawn(function()
                    repeat
                        local obj = GuiLibrary.ObjectCanBeSaved[cn .. (cn2 or "") .. ct]
                        if obj then
                            local valuex = obj["Enabled"] or obj["Value"]
                            if valuex == cv then
                                item.Visible = true
                            else
                                item.Visible = false
                            end
                        end
                        task.wait(0.05)
                    until GuiLibrary == nil
                end)
            end
            GuiLibrary.ObjectCanBeSaved[buttonapi.Name .. api.Name .. "Mode"] = api
            return api
        end
        GuiLibrary.ObjectCanBeSaved[buttonapi.Name .. "OptionsButton"] = buttonapi
        return buttonapi
    end
    GuiLibrary.ObjectCanBeSaved[v .. "Window"] = windowapi
end
inputService.InputBegan:Connect(function(input)
    local closing = false
    if Enum.KeyCode[GuiLibrary.Settings.Keybind] == input.KeyCode then
        task.spawn(tgle)
        closing = true
    end
    for i, v in pairs(GuiLibrary.ObjectCanBeSaved) do
        if v.Keybind == nil then
            return
        end
        if v.Type == "OptionsButton" and Enum.KeyCode[v.Keybind] == input.KeyCode then
            task.spawn(v["ToggleButton"])
        end
    end
end)
GuiLibrary["SelfDestruct"] = function()
    gui:Destroy()
    rise2:Destroy()
    for i, v in pairs(GuiLibrary.Connections) do
        pcall(function()
            v:Disconnect()
        end)
    end
    GuiLibrary = nil
end
GuiLibrary.UpdateHudEvent.Event:Connect(function(ignore)
    local theme = ThemeService.Themes[GuiLibrary.Settings.Theme]
    if not theme then
        theme = ThemeService.Themes["Water"]
    end
    logoimage.Visible = GuiLibrary.ObjectCanBeSaved.InterfaceOptionsButton.Enabled
    if ThemeService:GetColor(ThemeService:GetKeyColor(GuiLibrary.Settings.Theme)) ~= nil and
        ThemeService:GetColor(ThemeService:GetKeyColor(GuiLibrary.Settings.Theme)) ~= 0 then -- rainbow
        shader.BackgroundColor3 = ThemeService:GetColor(ThemeService:GetKeyColor(GuiLibrary.Settings.Theme))
        local color1 = ThemeService.Themes[GuiLibrary.Settings.Theme][1]
        local color2 = #ThemeService.Themes[GuiLibrary.Settings.Theme] == 1 and
                           ThemeService.Themes[GuiLibrary.Settings.Theme][1] or
                           ThemeService.Themes[GuiLibrary.Settings.Theme][2]
        uigra.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color2), ColorSequenceKeypoint.new(1, color1)})
    end
    if GuiLibrary.Settings.Theme == "Rainbow" then
        vergra.Color = ColorSequence.new(Color3.new(1, 1, 1))
    else
        vergra.Color = ColorSequence.new(ThemeService.Themes[GuiLibrary.Settings.Theme][1])
    end
    task.spawn(function()
        local color = ThemeService.Themes[GuiLibrary.Settings.Theme][1]
        if color == nil then
            return
        end -- rainbow
        for i, v in pairs(GuiLibrary.ThemesItems) do
            if v:IsA("TextLabel") then
                v.TextColor3 = color
            else
                v.BackgroundColor3 = color
            end
        end
        for i, v in pairs(GuiLibrary.DarkerThemesItems) do
            if v:IsA("TextLabel") then
                v.TextColor3 = ThemeService:darker(color)
            else
                v.BackgroundColor3 = ThemeService:darker(color)
            end
        end
    end)
    keys = Lang:GetLanguage(GuiLibrary.Settings.Language)
    for i, v in pairs(GuiLibrary.TranslateItems) do
        task.spawn(function()
            task.wait()
            if v == nil then
                return
            end
            local funcattr = v:GetAttribute("RLReplacement")
            if funcattr ~= nil then
                GuiLibrary.LanguageFunctions[funcattr](keys[v:GetAttribute("RiseLanguageKey")])
            else
                local attr = v:GetAttribute("RiseLanguageKey")
                if attr then
                    local value = keys[attr]
                    if value then
                        v.Text = value
                    end
                end
            end
        end)
    end
    if not ignore then
        local px2 = Instance.new("GetTextBoundsParams")
        px2.Size = 18
        px2.Font = shared.RiseFonts.AppleUI
        px2.Width = 99999
        px2.Text = keys["maingui.winlist." .. selectedwindowoption:lower()]
        selectedwindow.Size = UDim2.new(0, 48 + textService:GetTextBoundsAsync(px2).X, 0, 30)
    end
end)
local InterfaceOptionsButton = GuiLibrary.ObjectCanBeSaved["RenderWindow"]["CreateOptionsButton"]({
    ["Name"] = "Interface",
    ["Description"] = "The clients interface with all information",
    ["Enabled"] = true,
    Function = function(val)
        GuiLibrary.UpdateHudEvent:Fire()
    end
})
InterfaceOptionsButton["CreateToggle"]({
    Name = "Toggle Notifications",
    Enabled = true
})
GuiLibrary["RemoveOptionsButton"] = function(key)
    local obj = GuiLibrary.ObjectCanBeSaved[key .. "OptionsButton"]
    if obj then
        obj.Object:Destroy()
        GuiLibrary.ObjectCanBeSaved[key .. "OptionsButton"] = nil
    end
end
GuiLibrary["ClearOptions"] = function()
    for i, v in pairs(GuiLibrary.ObjectCanBeSaved) do
        if v["Type"] == "OptionsButton" then
            v["ToggleButton"](false, true)
        end
    end
end
GuiLibrary["LoadSettings"] = function(customsave, config)
    GuiLibrary.ClearOptions()
    local loadfile = "rise/configs/" .. (config or "") .. (customsave or game.PlaceId) .. ".rscfg"
    if isfile("rise/configs/latest" .. tostring(game.PlaceId) .. ".rscfg") and not config then
        loadfile = "rise/configs/latest" .. tostring(game.PlaceId) .. ".rscfg"
    end
    if not isfile(loadfile) then
        return
    end
    local decoded = httpService:JSONDecode(readfile(loadfile))
    if decoded ~= nil and type(decoded) == "table" then
        for i, v in pairs(decoded) do
            local obj = GuiLibrary.ObjectCanBeSaved[i]
            if obj then
                if v.Type == "OptionsButton" then
                    obj["ToggleButton"](v["Enabled"] or false, true)
                    if v["Keybind"] and v["Keybind"] ~= nil then
                        obj["Keybind"] = v["Keybind"]
                    end
                elseif v.Type == "Toggle" then
                    obj["ToggleButton"](v["Enabled"] or false, true)
                elseif v.Type == "Slider" then
                    if v["Value"] then
                        obj["SetValue"](v["Value"])
                    end
                elseif v.Type == "BoundsSlider" then
                    if v["Value"] and type(v["Value"]) == "table" and type(v["Value"][1]) == "number" and
                        type(v["Value"][2]) == "number" then
                        obj["SetValue"](v["Value"][1], v["Value"][2])
                    end
                elseif v.Type == "TextBox" then
                    if v["Value"] then
                        obj["SetValue"](v["Value"])
                    end
                elseif v.Type == "Mode" then
                    if v["Value"] and type(v["Value"]) == "number" then
                        obj["SetValue"](v["Value"])
                    end
                end
            end
        end
    end
end
GuiLibrary["SaveSettings"] = function()
    if not GuiLibrary.Loaded then
        return
    end
    local file = "rise/configs/latest" .. tostring(game.PlaceId) .. ".rscfg" -- don't ask why its only latest. Try rise yourself.
    local savetable = {}
    for i, v in pairs(GuiLibrary.ObjectCanBeSaved) do
        if v.Type == "OptionsButton" then
            if v["NoSave"] then
                return
            end
            savetable[i] = {
                Type = "OptionsButton",
                Enabled = v["Enabled"],
                Keybind = v["Keybind"]
            }
        elseif v.Type == "Toggle" then
            savetable[i] = {
                Type = "Toggle",
                Enabled = v["Enabled"]
            }
        elseif v.Type == "Slider" then
            savetable[i] = {
                Type = "Slider",
                Value = v["Value"]
            }
        elseif v.Type == "BoundsSlider" then
            savetable[i] = {
                Type = "BoundsSlider",
                Value = v["Value"]
            }
        elseif v.Type == "TextBox" then
            savetable[i] = {
                Type = "TextBox",
                Value = v["Value"]
            }
        elseif v.Type == "Mode" then
            savetable[i] = {
                Type = "Mode",
                Value = v["Value"]
            }
        end
    end
    writefile(file, httpService:JSONEncode(savetable))
end
GuiLibrary.Loaded = true
task.spawn(function()
    coroutine.resume(mainsettingssaveloop)
end)
local tps = false
lplr.OnTeleport:Connect(function()
    if (not tps) then
        tps = true
        local tpss = [[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/MainScript.lua"))()
        ]]
        if shared.RiseDeveloper then
            tpss = "shared.RiseDeveloper = true\n" .. tpss
        end
        GuiLibrary.SaveSettings()
        local qot = syn and syn.queue_on_teleport or queue_on_teleport or function()
        end
        qot(tpss)
    end
end)
return GuiLibrary
