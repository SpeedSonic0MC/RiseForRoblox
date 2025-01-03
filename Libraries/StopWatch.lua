local StopWatchClass = {}
StopWatchClass.__index = StopWatchClass

-- Rise 6 equalivant, error picked because rise love throwing this error so why not use it :trollface:
function StopWatchClass.new()
    local StopWatch = {
        ["millis"] = DateTime.now().UnixTimestampMillis
    }

    function StopWatch.finished(del)
        return DateTime.now().UnixTimestampMillis - del >= StopWatch.millis
    end

    function StopWatch.reset()
        StopWatch.millis = DateTime.now().UnixTimestampMillis
    end

    function StopWatch.getElapsedTime()
        return DateTime.now().UnixTimestampMillis - StopWatch.millis
    end

    function StopWatch.setMillis(mi)
        StopWatch.millis = mi
    end

    return setmetatable(StopWatch, {
        __newindex = function()
            error("Fatal: Error executing task with throwable: java.util.concurrent.ExecutionException: java.lang.NullPointerException: Cannot invoke \"net.minecraft.entity.a.JG()\" because \"this.cwl\" is null")
        end
    })
end

return setmetatable(StopWatchClass, {
    __newindex = function()
        error("Fatal: Error executing task with throwable: java.util.concurrent.ExecutionException: java.lang.NullPointerException: Cannot invoke \"net.minecraft.entity.a.JG()\" because \"this.cwl\" is null")
    end
})
