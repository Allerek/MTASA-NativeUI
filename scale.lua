local screenW, screenH = guiGetScreenSize( )
local baseX = 1920
if screenW < baseX then
    zoom = math.min(2, baseX/screenW)
end

function getZoom()
    local screenW, screenH = guiGetScreenSize(  )
    if screenW < 1920 then
        return math.min(2, 1920/screenW)
    else
        return 1.0
    end
end

function scaleScreen(x, y, w, h, alignX, alignY)
    assert(x, "Bad argument @ 'scaleScreen' [Execpted number at argument 1, got "..tostring(x).."]")
    assert(tonumber(x), "Bad argument @ 'scaleScreen' [The argument 1 must be a number!]")
    assert(y, "Bad argument @ 'scaleScreen' [Execpted number at argument 2, got "..tostring(y).."]")
    assert(tonumber(y), "Bad argument @ 'scaleScreen' [The argument 2 must be a number!]")
    assert(w, "Bad argument @ 'scaleScreen' [Execpted number at argument 3, got "..tostring(w).."]")
    assert(tonumber(w), "Bad argument @ 'scaleScreen' [The argument 3 must be a number!]")
    assert(h, "Bad argument @ 'scaleScreen' [Execpted number at argument 4, got "..tostring(h).."]")
    assert(tonumber(h), "Bad argument @ 'scaleScreen' [The argument 4 must be a number!]")
    alignX = alignX or "left"
    alignY = alignY or "top"
    w = w/zoom
    h = h/zoom
    assert( (string.lower(alignX) == "left" or string.lower(alignX) == "center" or string.lower(alignX) == "right") , "Bad argument 5 @ scaleScreen (invalid type alignment X)")
    assert( (string.lower(alignY) == "top" or string.lower(alignY) == "center" or string.lower(alignY) == "bottom") , "Bad argument 5 @ scaleScreen (invalid type alignment X)")

    -- assert(alignX, "Bad argument @ 'scaleScreen' [Execpted string at argument 5, got none]")
    -- assert(alignY, "Bad argument @ 'scaleScreen' [Execpted string at argument 5, got none]")
    if alignX == "left" then
        x = x/zoom
    elseif alignX == "center" then
        x = (screenW/2-w/2)-(x/zoom)
    elseif alignX == "right" then
        x = (screenW-w)-(x/zoom)
    end
    if alignY == "top" then
        y = y/zoom
    elseif alignY == "center" then
        y = (screenH/2-h/2)-(y/zoom)
    elseif alignY == "bottom" then
        y = (screenH-h)-(y/zoom)
    end
    return {x, y, w, h}
end
