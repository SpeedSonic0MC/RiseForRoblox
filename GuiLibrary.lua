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
        ["Notification.png"] = "rbxassetid://117437484840382"
    },
    Version = "6.0"
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
GuiLibrary.UpdateHudEvent.Event:Connect(function()
    local theme = ThemeService.Themes[GuiLibrary.Settings.Theme]
    if not theme then
        theme = ThemeService.Themes["Water"]
    end
end)
local notif = false
GuiLibrary["ShowNotification"] = function(title, description, time)
    task.spawn(function()
        if not GuiLibrary.Settings.Notifications then
            return
        end
        if notif then
            repeat
                task.wait()
            until notif == false
        end
        notif = true
        local param = Instance.new("GetTextBoundsParams")
        param.Font = shared.RiseFonts.AppleUI
        param.Width = 99999
        param.Size = 14
        param.Text = description
        local int = textService:GetTextBoundsAsync(param)
        local xs = math.min(60 + int.X + 15, 280)
        local nf = Instance.new("ImageLabel", rise2)
        nf.BackgroundTransparency = 1
        nf.AnchorPoint = Vector2.new(0.5, 0.5)
        nf.Position = UDim2.new(0, 155, 0, 84)
        nf.Size = UDim2.new(0, xs + 25, 0, 85)
        nf.ImageTransparency = 1
        nf.Image = getriseasset("Notification.png")
        nf.ImageColor3 = Color3.new(1, 1, 1)
        nf.ScaleType = Enum.ScaleType.Slice
        nf.SliceCenter = Rect.new(Vector2.new(71, 0), Vector2.new(249, 60))
        nf.SliceScale = 1
        local title2 = Instance.new("TextLabel", nf)
        title2.BackgroundTransparency = 1
        title2.Position = UDim2.new(0, 60, 0.233, 0)
        title2.Size = UDim2.new(0, 0, 0, 14)
        title2.FontFace = shared.RiseFonts["AppleUIBold"]
        title2.TextTransparency = 1
        title2.Text = title or "Toggled"
        title2.TextColor3 =
            GuiLibrary.Settings.Theme ~= "Rainbow" and ThemeService.Themes[GuiLibrary.Settings.Theme][1] or
                Color3.new(1, 1, 1)
        title2.TextSize = 14
        title2.TextXAlignment = Enum.TextXAlignment.Left
        local dsc = Instance.new("TextLabel", nf)
        dsc.BackgroundTransparency = 1
        dsc.Position = UDim2.new(0, 60, 0.567, 0)
        dsc.TextTransparency = 1
        dsc.Size = UDim2.new(0, 0, 0, 14)
        dsc.FontFace = shared.RiseFonts["AppleUI"]
        dsc.Text = description
        dsc.TextColor3 = Color3.fromRGB(215, 215, 215)
        dsc.TextSize = 14
        dsc.TextXAlignment = Enum.TextXAlignment.Left
        tweenService:Create(nf, TweenInfo.new(.25), {
            Size = UDim2.new(0, xs, 0, 60),
            ImageTransparency = 0
        }):Play()
        tweenService:Create(title2, TweenInfo.new(.25), {
            TextTransparency = 0
        }):Play()
        tweenService:Create(dsc, TweenInfo.new(.25), {
            TextTransparency = 0
        }):Play()
        task.wait(.25 + (time or 0.8))
        tweenService:Create(nf, TweenInfo.new(.25), {
            Size = UDim2.new(0, xs + 25, 0, 85),
            ImageTransparency = 1
        }):Play()
        tweenService:Create(title2, TweenInfo.new(.25), {
            TextTransparency = 1
        }):Play()
        tweenService:Create(dsc, TweenInfo.new(.25), {
            TextTransparency = 1
        }):Play()
        task.wait(0.25)
        nf:Destroy()
        notif = false
    end)
end
GuiLibrary.UpdateHudEvent:Fire()
GuiLibrary.ShowNotification("Rise 6", "Rise loaded. Press " .. GuiLibrary.Settings.Keybind .. " to open Click GUI")
return GuiLibrary
