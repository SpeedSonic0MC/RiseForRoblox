local q = Color3.fromRGB
local Themes = {}

function Themes:brighter(color)
    local i = 1 / (1 - 0.7)
    local r = color.R * 255
    local g = color.G * 255
    local b = color.B * 255
    if r == 0 and g == 0 and b == 0 then
        return Color3.new(i, i, i)
    end
    if r > 0 and r < i then
        r = i
    end
    if g > 0 and g < i then
        g = i
    end
    if b > 0 and b < i then
        b = i
    end
    return q(math.min(r / 0.7, 255), math.min(g / 0.7, 255), math.min(b / 0.7, 255))
end

function Themes:darker(color)
    return Color3.new(math.max(color.R * 0.7, 0), math.max(color.G * 0.7, 0), math.max(color.B * 0.7, 0))
end

Themes["Themes"] = {
    Aubergine = {q(170, 7, 107), q(97, 4, 95)},
    Aqua = {q(185, 250, 255), q(79, 199, 200)},
    Banana = {q(253, 236, 177), q(255, 255, 255)},
    Blend = {q(71, 148, 253), q(71, 253, 160)},
    Blossom = {q(226, 208, 249), q(49, 119, 115)},
    Bubblegum = {q(243, 145, 216), q(152, 165, 243)},
    ["Candy Cane"] = {q(255, 0, 0), q(255, 255, 255)},
    Cherry = {q(187, 55, 125), q(251, 211, 233)},
    Christmas = {q(255, 64, 64), q(255, 255, 255), q(64, 255, 64)},
    Coral = {q(244, 168, 150), q(52, 133, 151)},
    ["Digital Horizon"] = {q(95, 195, 228), q(229, 93, 135)},
    Express = {q(173, 83, 137), q(60, 16, 83)},
    ["Lime Water"] = {q(18, 255, 247), q(179, 255, 171)},
    Lush = {q(168, 224, 99), q(86, 171, 47)},
    Halogen = {q(255, 65, 108), q(255, 75, 43)},
    Hyper = {q(236, 110, 173), q(52, 148, 230)},
    Magic = {q(74, 0, 224), q(142, 45, 226)},
    May = {q(238, 79, 238), q(253, 219, 245)},
    ["Orange Juice"] = {q(252, 74, 26), q(247, 183, 51)},
    Pastel = {q(243, 155, 178), q(207, 196, 243)},
    Pumpkin = {q(241, 166, 98), q(255, 216, 169), q(227, 139, 42)},
    Satin = {q(215, 60, 67), q(140, 23, 39)},
    ["Snowy Sky"] = {q(1, 171, 179), q(234, 234, 234), q(111, 115, 123)},
    ["Steel Fade"] = {q(66, 134, 244), q(55, 59, 68)},
    Sundae = {q(206, 74, 126), q(28, 28, 27)},
    Sunkist = {q(242, 201, 76), q(242, 153, 74)},
    Water = {q(12, 232, 199), q(12, 163, 232)},
    Legacy = {q(116, 202, 251)},
    Winter = {q(255, 255, 255)},
    Peony = {q(226, 208, 249), q(207, 171, 255)},
    Shadow = {q(97, 131, 255), q(206, 212, 255)},
    Wood = {q(79, 109, 81), q(170, 139, 87), q(240, 235, 206)},
    Creida = {Themes:brighter(Themes:brighter(Color3.fromHex("#4e5270"))), Themes:darker(Color3.fromHex("#4e5270"))},
    ["Creida Two"] = {Color3.fromHex("#9ACAEB"), Themes:darker(Color3.fromHex("#7FBBE6"))},
    Gothic = {q(31, 30, 30), q(196, 190, 190)},
    Rue = {q(234, 118, 176), q(31, 30, 30)},
    Purple = {Color3.fromHex("#524391"), Themes:brighter(Color3.fromHex("#524391"))},
    Rainbow = {}
}
Themes["ColorFilters"] = {
    Red = {"Aubergine", "Candy Cane", "Cherry", "Christmas", "Digital Horizon", "Halogen", "Satin", "Sundae"},
    Orange = {"Coral", "Halogen", "Orange Juice", "Pumpkin", "Sunkist"},
    Yellow = {"Banana", "Orange Juice", "Sunkist"},
    Lime = {"Blend", "Christmas", "Lime Water", "Lush"},
    DarkGreen = {"Lush", "Wood"},
    Aqua = {"Aqua", "Blend", "Digital Horizon", "Lime Water", "Hyper", "Snowy Sky", "Water", "Legacy", "Shadow"},
    DarkBlue = {"Coral", "Hyper", "Magic", "Steel Fade", "Water", "Legacy"},
    Purple = {"Aubergine", "Bubblegum", "Cherry", "Express", "Magic", "May", "Sundae"},
    Pink = {"Blossom", "Bubblegum", "Cherry", "Coral", "Digital Horizon", "Express", "Hyper", "May", "Pastel", "Sundae",
            "Peony", "Rue"},
    Gray = {"Blossom", "Snowy Sky", "Steel Fade", "Winter", "Peony", "Creida", "Creida Two", "Gothic"}
}
function Themes:GetKeyColor(theme)
    if theme == "Rainbow" then return 0 end
    for i, v in pairs(self.ColorFilters) do
        if table.find(v, theme) then return i end
    end
    return nil
end
function Themes:GetColor(keycolor)
    return ({
        Red = q(255, 55, 55),
        Orange = q(255, 128, 55),
        Yellow = q(255, 255, 55),
        Lime = q(128, 255, 55),
        DarkGreen = q(55, 128, 55),
        Aqua = q(55, 200, 255),
        DarkBlue = q(55, 105, 200),
        Purple = q(128, 52, 255),
        Pink = q(255, 128, 255),
        Gray = q(100, 100, 110)
    })[keycolor]
end
function Themes:GetColorSequence(theme)
    if theme == "Rainbow" then
        return ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                   ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 1, 1)),
                   ColorSequenceKeypoint.new(0.3, Color3.fromHSV(0.3, 1, 1)),
                   ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 1, 1)),
                   ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                   ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 1, 1)),
                   ColorSequenceKeypoint.new(0.7, Color3.fromHSV(0.7, 1, 1)),
                   ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 1, 1)),
                   ColorSequenceKeypoint.new(0.9, Color3.fromHSV(0.9, 1, 1)),
                   ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))})
    end
    local tm = self.Themes[theme]
    if not tm then
        return nil
    end
    if #tm < 3 then
        return ColorSequence.new({ColorSequenceKeypoint.new(0, tm[1]),
                                  ColorSequenceKeypoint.new(1, (#tm == 1 and tm[1] or tm[2]))})
    else
        return ColorSequence.new({ColorSequenceKeypoint.new(0, tm[1]), ColorSequenceKeypoint.new(0.5, tm[2]),
                                  ColorSequenceKeypoint.new(1, tm[3])})
    end
end
function Themes:GetColorValue(theme, time)
    local cs = self:GetColorSequence(theme)
    if time == 0 then
        return cs.Keypoints[1].Value
    elseif time == 1 then
        return cs.Keypoints[#cs.Keypoints].Value
    end
    for i = 1, #cs.Keypoints - 1 do
        local _1 = cs.Keypoints[i]
        local _2 = cs.Keypoints[i + 1]
        if time >= _1.Time and time <= _2.Time then
            local _3 = (time - _1.Time) / (_2.Time - _1.Time)
            return Color3.new((_2.Value.R - _1.Value.R) * _3 + _1.Value.R, (_2.Value.G - _1.Value.G) * _3 + _1.Value.G,
                (_2.Value.B - _1.Value.B) * _3 + _1.Value.B)
        end
    end
end
return Themes
