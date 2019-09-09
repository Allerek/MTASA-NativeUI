window = {
    options={}
}

local sound
local actual = 1
isNativeShown = false
switch={}

function createNativeUI(name, title, image, color, namecolor, titlecolor, align, counter, scroll, scrollitems)
    if name == "" then
        assert(type(name) == string, "Bad argument @ createNativeUI [expected string at argument 1,  got "..type(name).." '"..name.."'']")
    end
    if title then
        assert(title and tostring(title), "Bad argument @ createNativeUI [expected string at argument 2,  got "..type(title).." '"..title.."'']")
    end
    if not image then
        assert(color, "[Native UI]No specified image and not specified color")
    end
    if align then
        assert(align == "left" or align == "right", "Invalid align type @ createNativeUI [expected 'left'/'right' at argument 7,  got"..type(align).." '"..align.."'']")
    end
    window = {}
    window.items={}
    zoom = getZoom()
    window.name = name
    window.title = title or "Native UI"
    window.scale = scaleScreen(10, 10, 431, 107, align, "top")
    window.namepos = Vector2(unpack(window.scale, 1), unpack(window.scale, 2))
    window.namesize = Vector2(unpack(window.scale, 3), unpack(window.scale, 4))
    window.namepos2 = Vector2(window.namepos["x"]+(window.namesize["x"]/2), window.namepos["y"]+(window.namesize["y"]/1.75))
    window.scale = scaleScreen(0, 0, 431, 37, "left", "top")
    window.titlepos = Vector2(window.namepos["x"], window.namepos["y"]+window.namesize["y"])
    window.titlesize = Vector2(unpack(window.scale, 3), unpack(window.scale, 4))
    window.titlepos2 = Vector2(window.titlepos["x"]+(15/zoom), window.titlepos["y"]+(window.titlesize["y"]/2))
    window.titlepos3 = Vector2(window.titlepos["x"]+window.titlesize["x"]-(15/zoom), window.titlepos["y"]+(window.titlesize["y"]/2))
    window.namefont = dxCreateFont("assets/font.ttf", 55/zoom)
    window.titlefont = dxCreateFont("assets/fonttitle.ttf", 18/zoom, false)
    window.image = image or "assets/defaultbg.png"
    window.namecolor = namecolor or tocolor(255, 255, 255)
    window.titlecolor = titlecolor or tocolor(255, 255, 255)
    window.counter = counter or false
    window.scroll = scroll or false
    if not scrollitems or scrollitems > 10 then
        scrollitems = 10
    end
    window.scrollitems = scrollitems
    bindKeys()
    isNativeShown = true
    addEventHandler("onClientRender", getRootElement(), renderNative)
end

function addNativePlaceholder(text, color)
    if type(color) == "string" then
        color = tocolor(getColorFromString(color))
    end
    color = color or tocolor(255, 255, 255)
    local table = {
        ["type"] = "placeholder",
        ["color"] = color,
        ["text"] = text
    }
    window.items[#window.items+1] = table
end

function renderNative()
    dxDrawImage(window.namepos, window.namesize, window.image)
    dxDrawRectangle(window.titlepos, window.titlesize, tocolor(0, 0, 0))
    dxDrawText(window.title, window.titlepos2, nil, nil, window.titlecolor, 1, window.titlefont, "left", "center")
    if window.counter then
        dxDrawText(actual.."/"..#window.items, window.titlepos3, nil, nil, window.titlecolor, 1, window.titlefont, "right", "center")
    end
    if window.name then
        dxDrawText(window.name, window.namepos2, nil, nil, window.namecolor, 1, window.namefont, "center", "center")
    end
    for i, v in pairs(window.items) do
        page = math.ceil(i/window.scrollitems)
        dxDrawText(getCurrentPage(), 0, 0, 0, 0)
        if i > window.scrollitems*(getCurrentPage()-1) and i <= window.scrollitems*getCurrentPage() then
            i=i-window.scrollitems*(getCurrentPage()-1)
            if actual-window.scrollitems*(getCurrentPage()-1) == i then
                color = tocolor(255, 255, 255, 255*0.6)
                textcolor = tocolor(0, 0, 0, 255)
            else
                local multiplier = 255*(0.03*i)
                color = tocolor(0, 0, 0, 255-multiplier)
                textcolor = v.color
            end
            local pos = Vector2(window.titlepos["x"], window.titlepos["y"]+window.titlesize["y"]+(window.titlesize["y"]*(i-1)))
            dxDrawRectangle(pos, window.titlesize, color)
            local pos = Vector2(window.titlepos["x"]+(15/zoom), window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(i)))
            dxDrawText(v.text, pos, nil, nil, textcolor, 1, window.titlefont, "left", "center")
            if v.type == "switch" then
                local pos = Vector2(window.titlepos["x"]+window.titlesize["x"]-(15/zoom), window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(i)))
                local actual = tonumber(v.actual)
                dxDrawText("⮜ "..v.value[actual].." ⮞", pos, nil, nil, textcolor, 1, window.titlefont, "right", "center")
            end
            if #window.items > window.scrollitems  then
                local pos = Vector2(window.titlepos["x"], window.titlepos["y"]+window.titlesize["y"]+(window.titlesize["y"]*(10)))
                dxDrawRectangle(pos, window.titlesize, tocolor(0, 0, 0, 255*0.4))
                local pos = Vector2(window.titlepos["x"]+(window.titlesize["x"]/2), window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(11)))
                if page == 1 then
                    text = "⮟"
                elseif page == math.ceil(#window.items/window.scrollitems) then
                    text = "⮝"
                else
                    text = "⮝ \ ⮟"
                end
                dxDrawText(text, pos, nil, nil, tocolor(255, 255, 255), 1, window.titlefont, "center", "center")
            end
        end
    end
end

function getCurrentPage()
    local currentpage = math.ceil(actual/window.scrollitems)
    return currentpage
end

function removeNativeItem(id)
    table.remove(window.items, id)
end

addEventHandler("onClientKey", getRootElement(), function(btn, state)
    if not isNativeShown then return end
    if btn == "arrow_d" and state == true then
        cancelEvent()
    end
    if btn == "arrow_u" and state == true then
        cancelEvent()
    end
    if btn == "arrow_r" and state == true then
        cancelEvent()
    end
    if btn == "arrow_l" and state == true then
        cancelEvent()
    end
    if btn == "enter" and state == true then
        cancelEvent()
    end
end)


function bindKeys()
    bindKey("arrow_d", "up", function()
        if not isNativeShown then return end
        if actual+1 > #window.items then
            actual = 1
        else
            actual = actual+1
        end
        playNativeSound()
    end)
    bindKey("arrow_u", "up", function()
        if not isNativeShown then return end
        if actual-1 < 1 then
            actual = #window.items
        else
            actual = actual-1
        end
        playNativeSound()
    end)
    bindKey("arrow_r", "up", function()
        if window.items[actual].type == "switch" then
            window.items[actual].actual = window.items[actual].actual+1
            if window.items[actual].actual > #window.items[actual].value then window.items[actual].actual = 1 end
            playNativeSound()
            local actualswitch = window.items[actual].actual
            local actualswitch = window.items[actual].value[tonumber(actualswitch)]
            triggerEvent("onClientChangeSwitch", localPlayer, actual, actualswitch)
        end
    end)
    bindKey("arrow_l", "up", function()
        if window.items[actual].type == "switch" then
            window.items[actual].actual = window.items[actual].actual-1
            if window.items[actual].actual < 1 then window.items[actual].actual = #window.items[actual].value end
            playNativeSound()
        end
    end)
    bindKey("enter", "up", function()
        if window.items[actual].type == "switch" then
            local actualswitch = window.items[actual].actual
            local actualswitch = window.items[actual].value[tonumber(actualswitch)]

            triggerEvent("onClientAcceptSwitch", localPlayer, actual, actualswitch)

        end
    end)
end

function playNativeSound()
    if isElement(sound) then
        destroyElement(sound)
        sound = playSound("assets/change.wav", false)
    else
        sound = playSound("assets/change.wav", false)
    end
end
