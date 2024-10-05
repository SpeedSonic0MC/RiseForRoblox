local HttpService = game:GetService("HttpService")
local a = {
    Languages = {},
    Available = {"en", "zh_hant"},
    AvailableName = { -- love windows not showing the flag
    [[English (Global)]], [[Chinese Traditional (Hong Kong)]]},
    AvailableFlag = {
        
    }
}
function a:GetLanguage(key)
    if not a.Languages[key] then
        local b, c = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/lang/" .. key ..
                                    ".json")
        end)
        if not b or c == "404: Not Found" then
            setfpscap(9e9)
            return
        end
        a.Languages[key] = HttpService:JSONDecode(c)
    end
    return a.Languages[key]
end
return a
