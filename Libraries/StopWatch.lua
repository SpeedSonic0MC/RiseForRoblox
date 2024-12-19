local StopWatchClass = {}
StopWatchClass.__index = StopWatchClass

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
            error(":face_with_symbols_over_mouth: Attempt to create new value in StopWatch class")
        end
    })
end

return setmetatable(StopWatchClass, {
    __newindex = function()
        error(":face_with_symbols_over_mouth: Attempt to create new value in StopWatch class")
    end
})
