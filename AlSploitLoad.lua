-- this will not work.
local httpService = game:GetService("HttpService")
local tweenService = game:GetService("TweenService")
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local iamge = game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/alsploit/AlSploit.png")
writefile("alsploit.png", iamge) -- ignore spelling mistakes
local sfprodisplaymediumasset = request {
    Url = "https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/alsploit/SF-Pro-Display-Medium.ttf",
    Method = "GET"
}
writefile("sfprodisplay.ttf", sfprodisplaymediumasset.Body)
writefile("sfprodisplay.json", httpService:JSONEncode({
    name = "SF Pro Display",
    faces = {{
        name = "Regular",
        weight = 300,
        style = "normal",
        assetId = getcustomasset("sfprodisplay.ttf")
    }}
}))
local sfprodisplaymediumasse2t = request {
    Url = "https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/alsploit/SF-Pro-Display-Medium.ttf",
    Method = "GET"
}
writefile("sfprodisplay2.ttf", sfprodisplaymediumasse2t.Body)
writefile("sfprodisplay2.json", httpService:JSONEncode({
    name = "SF Pro Rounded",
    faces = {{
        name = "Regular",
        weight = 300,
        style = "normal",
        assetId = getcustomasset("sfprodisplay2.ttf")
    }}
}))
local SFProDisplay = Font.new(getcustomasset("sfprodisplay.json"))
local SFProRounded = Font.new(getcustomasset("sfprodisplay2.json"))
local isvalidplace = true
if not table.find({6872265039, 6872274481, 8444591321, 8560631822}, game.PlaceId) then
    isvalidplace = false
end
local loadergui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
loadergui.ScreenInsets = Enum.ScreenInsets.None
loadergui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
loadergui.OnTopOfCoreBlur = true -- appears on top of roblox githubusercontent
loadergui.DisplayOrder = 999
loadergui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local image = Instance.new("ImageLabel", loadergui)
image.Image = getcustomasset("alsploit.png")
image.BackgroundTransparency = 1
image.Size = UDim2.new(0, 628, 0, 428)
image.AnchorPoint = Vector2.new(0.5, 0.5)
image.Position = UDim2.new(0.5, 0, 0.5, 0)
image.ImageTransparency = 1
local uiscale = Instance.new("UIScale", image)
local maxscale = 1
uiscale.Scale = maxscale / 5
tweenService:Create(uiscale, TweenInfo.new(0.2), {
    Scale = maxscale / 5
}):Play() -- why change image size or scale when you can just scale the UI instead?
tweenService:Create(image, TweenInfo.new(0.2), {
    ImageTransparency = 0
}):Play()
task.wait(0.2)
local rm = Instance.new("Frame", image)
rm.AnchorPoint = Vector2.new(0.5, 0.5)
rm.BackgroundTransparency = 1
rm.Position = UDim2.new(0.5, 0, 0.5, 0)
rm.Size = UDim2.new(0, 600, 0, 400)
local adver = Instance.new("TextLabel", rm)
adver.BackgroundTransparency = 1
adver.Position = UDim2.new(0, 164, 0, 372)
adver.FontFace = SFProRounded
adver.TextSize = 15
adver.Size = UDim2.new(0, 265, 0, 18)
adver.TextColor3 = Color3.fromHex("#DDDDDD")
adver.Text = "discord.gg/4ntWmUHmYf - @godclutcher"
adver.TextTransparency = 1
tweenService:Create(adver, TweenInfo.new(0.4), {
    TextTransparency = 0
}):Play()
local loadingtext = Instance.new("TextLabel", rm)
loadingtext.FontFace = SFProDisplay
loadingtext.TextSize = 30
loadingtext.Text = "Please Wait"
loadingtext.Position = UDim2.new(0, 0, 0, 182)
loadingtext.Size = UDim2.new(0, 600, 0, 36)
loadingtext.TextColor3 = Color3.new(1, 1, 1)
loadingtext.TextTransparency = 1
loadingtext.BackgroundTransparency = 1
tweenService:Create(loadingtext, TweenInfo.new(0.6), {
    TextTransparency = 0
}):Play()
task.wait(0.6)
local function changetext(val)
    task.spawn(function()
        tweenService:Create(loadingtext, TweenInfo.new(0.2), {
            TextTransparency = 1
        }):Play()
        task.wait(0.2)
        loadingtext.Text = val
        tweenService:Create(loadingtext, TweenInfo.new(0.2), {
            TextTransparency = 0
        }):Play()
    end)
end
if not isvalidplace then
    changetext("AlSploit is incompatible with this game")
else
    changetext("Starting AlSploit")
    local currenttick = tick()
    local callbacktime = 0
    local suc, res = pcall(function()
        game:HttpGet("https://raw.githubusercontent.com/AlSploit/AlSploit/main/AlSploit/Bedwars/MainScript.lua")
    end)
    if not suc then
        changetext("AlSploit Failed To Load")
        task.wait(2)
        tweenService:Create(uiscale, TweenInfo.new(0.4), {
            Scale = maxscale / 5
        }):Play()
        tweenService:Create(image, TweenInfo.new(0.2), {
            ImageTransparency = 1
        }):Play()
    else
        callbacktime = tick() - currenttick
        local pgb = Instance.new("Frame", rm)
        pgb.BackgroundColor3 = Color3.fromHex("#222222")
        pgb.BackgroundTransparency = 1
        pgb.Position = UDim2.new(0, 100, 0, 304)
        pgb.Size = UDim2.new(0, 400, 0, 10)
        local corner = Instance.new("UICorner", pgb)
        corner.CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", pgb)
        stroke.Transparency = 1
        stroke.Color = Color3.new(1, 1, 1)
        tweenService:Create(pgb, TweenInfo.new(0.2), {
            BackgroundTransparency = 0
        }):Play()
        tweenService:Create(stroke, TweenInfo.new(0.2), {
            Transparency = 0.1
        }):Play()
        task.wait(0.2)
        local pg = Instance.new("Frame", pgb)
        pg.BackgroundColor3 = Color3.fromHex("#CCCCCC")
        pg.Position = UDim2.new(0, 0, 0, 0)
        pg.Size = UDim2.new(0, 0, 1, 0)
        corner:Clone().Parent = pg
        local tween = tweenService:Create(pg, TweenInfo.new(callbacktime * 50, Enum.EasingStyle.Sine,
            Enum.EasingDirection.In), {
            Size = UDim2.new(1, 0, 1, 0)
        })
        tween:Play()
        tween.Completed:Wait()
        changetext("AlSploit Loaded")
        task.wait(0.4)
        task.spawn(function()
            loadstring(res)()
        end)
        task.spawn(function()
            loadstring(game:HttpGet(
                "https://raw.githubusercontent.com/AlSploit/AlSploit/refs/heads/main/AlSploit/Bedwars/Executed"))()
        end)
        task.wait(2)
        tweenService:Create(uiscale, TweenInfo.new(0.4), {
            Scale = maxscale / 5
        }):Play()
        tweenService:Create(image, TweenInfo.new(0.2), {
            ImageTransparency = 1
        }):Play()
    end
end
