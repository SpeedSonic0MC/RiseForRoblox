local HttpService = game:GetService("HttpService")
local a = {
    Languages = {},
    Available = {"en", "zh_hant", "fr"},
    AvailableName = { -- love windows breaking the flag
    [[English (Global)]], [[Chinese Traditional (Hong Kong)]], [[French (France)]]},
    AvailableFlag = {
        "🇺🇸", "🇭🇰", "🇫🇷"
    },
    AvailableDesc = {
        [[English (Global)]], [[繁體中文 （香港）]], [[Français (France)]]
    }
}
function a:GetLanguage(key)
    if not a.Languages[key] then
        local b, c = pcall(function()
            return game:HttpGet("https://cdn.jsdelivr.net/gh/SpeedSonic0MC/RiseForRoblox/lang/" .. key ..
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
