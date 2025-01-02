if getgenv and not getgenv().shared then
    getgenv().shared = {}
end
if shared.RiseExecuted then
    return
end
shared.RiseExecuted = true

shared.Rise = {
    Fonts = {}
}

for _, v in pairs({"Rise", "Rise/Assets", "Rise/Configs", "Rise/Assets/Fonts", "Rise/Assets/Interface"}) do
    if not isfolder(v) then
        makefolder(v)
    end
end

local geturl = function(p)
    local customurl = "https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/" .. p
    if shared.RiseDeveloper and shared.RiseUrls[p] then
        customurl = shared.RiseUrls[p]
    end
    local suc, res = pcall(function()
        return game:HttpGet(customurl)
    end)
    if not suc or res == "404: Not Found" then
        error("❌ Failed to load rise file : rise/" .. p)
    end
    return res
end

local gui = "Modern"
if not isfile("Rise/Configs/ClickGUITheme") then
    writefile("Rise/Configs/ClickGUITheme", "Modern")
else
    gui = readfile("Rise/Configs/ClickGUITheme")
end
local new = Instance.new
local playersService = game:GetService"Players"
local lplr = playersService.LocalPlayer
local function randomString()
    local randomlength = math.random(10, 20)
    local array = {}
    for i = 1, randomlength do
        array[i] = string.char(math.random(32, 126))
    end
    return table.concat(array)
end
local userInputService = game:GetService"UserInputService"

if not shared.Rise.UpdateClickGUITheme then
    local maingui = Instance.new("ScreenGui", lplr.PlayerGui)
maingui.ClipToDeviceSafeArea = false
maingui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
maingui.ScreenInsets = Enum.ScreenInsets.None
maingui.ResetOnSpawn = false
maingui.OnTopOfCoreBlur = true
maingui.DisplayOrder = 999
maingui.Name = randomString()
maingui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local mbgui = Instance.new("ScreenGui", lplr.PlayerGui)
mbgui.ClipToDeviceSafeArea = false
mbgui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
mbgui.ScreenInsets = Enum.ScreenInsets.None
mbgui.ResetOnSpawn = false
mbgui.OnTopOfCoreBlur = true
mbgui.DisplayOrder = 997
mbgui.Enabled = true
mbgui.Name = randomString()
mbgui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local ToggleClickGUI
local riseformobile
local mobileButtonAwaiting = false
task.spawn(function()
    riseformobile = new("TextButton", game:GetService("CoreGui"):WaitForChild("RobloxGui"))
    riseformobile.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
    riseformobile.BackgroundTransparency = 0.3
    riseformobile.Position = UDim2.new(1, 0, 0, 68)
    riseformobile.AnchorPoint = Vector2.new(1, 0)
    riseformobile.Size = UDim2.new(0, 30, 0, 20)
    riseformobile.Font = Enum.Font.GothamBold
    riseformobile.Text = "Rise"
    riseformobile.TextColor3 = Color3.new(1, 1, 1)
    riseformobile.TextSize = 14
    riseformobile.Name = "Rise for Mobile"
    riseformobile.Visible = (not userInputService.KeyboardEnabled)
    riseformobile.MouseButton1Click:Connect(function()
        ToggleClickGUI()
    end)
end)

userInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseMovement then
        riseformobile.Visible = false
    elseif input.UserInputType == Enum.UserInputType.Touch and not mobileButtonAwaiting then
        riseformobile.Visible = true
    end
end)

local hudgui = Instance.new("ScreenGui", lplr.PlayerGui)
hudgui.ResetOnSpawn = false
hudgui.Name = randomString()
hudgui.OnTopOfCoreBlur = true
hudgui.DisplayOrder = 998
hudgui.DisplayOrder = math.huge
hudgui.ZIndexBehavior = Enum.ZIndexBehavior.Global
shared.Rise.MainGui = {
    Main = maingui,
    Mobile = mbgui,
    HUD = hudgui,
    MBG = riseformobile
}
end

shared.Rise.GuiLibrary = loadstring(geturl("Gui/" .. (gui == "Modern" and "Rise" or gui) .. ".lua"))()
--[[pcall(function()
    request {
        Url = "https://rise-for-roblox.glitch.me/api/v1/execute",
        Method = "POST"
    } -- wow Solara HttpGet doesnt throw but this does "attempt to index nil with find" :nerd:
end)]]

local sx, fx = pcall(function()
    return geturl("Modules/" .. game.PlaceId .. ".lua")
end)

local function wt()
    shared.Rise.GuiLibrary["CreateNotification"]({
        Duration = 5,
        Title = "Rise Client",
        Text = "Rise is not supported in this game."
    })
end

if sx and fx ~= "404: Not Found" then
    loadstring(fx)()
end
shared.Rise.GuiLibrary.Loaded = false
shared.Rise.GuiLibrary.LoadSettings()
shared.Rise.GuiLibrary.Events.UpdateShaderEvents:Fire()
shared.Rise.GuiLibrary.Events.UpdateLanguageEvent:Fire()
shared.Rise.GuiLibrary.Loaded = true
shared.RiseUAL()

shared.Rise.Chat.PushRiseMessage("Press " .. (shared.Rise.GuiLibrary.MainSettings.ClickGUIKeybind or "NONE") .. " to open Click GUI")

if shared.Rise.Chat["GameNoChat"] then
    shared.Rise.Chat.PushRiseMessage("This game has chat (temporarily / permanently) disabled. Send messages at your own risk.")
end
if not sx or fx == "404: Not Found" then
    wt()
end
