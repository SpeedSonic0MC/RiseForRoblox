local rise = {}

function rise:GetService(service)
    local suc, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/SpeedSonic0MC/RiseForRoblox/main/services/" .. service .. ".lua", true)
    end)
    if not suc or res == "404: Not Found" then
        error("Rise >> Invalid Service Name " .. service)
    end
    return loadstring(res)()
end

return rise