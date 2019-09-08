local window = {
    options={}
}
local sound
local actual = 1
local isNativeShown = false

function createNativeUI(name,title,image,color,namecolor,titlecolor,align)
    if not name then return end
    if not title then return end
    if image == nil and not color then return end
    if not align then return end
    assert(align == "left" or align == "right","Invalid align type @ createNativeUI ('left'/'right' expected, got " .. align .. ")")
    window = {}
    window.items={}
    zoom = getZoom()
    window.name = name
    window.title = title
    window.scale = scaleScreen(10,10,431,107,align,"top")
    window.namepos = Vector2(unpack(window.scale,1),unpack(window.scale,2)) 
    window.namesize = Vector2(unpack(window.scale,3),unpack(window.scale,4))
    window.namepos2 = Vector2(window.namepos["x"]+(window.namesize["x"]/2),window.namepos["y"]+(window.namesize["y"]/2))
    window.scale = scaleScreen(0,0,431,37,"left","top")
    window.titlepos = Vector2(window.namepos["x"],window.namepos["y"]+window.namesize["y"])
    window.titlesize = Vector2(unpack(window.scale,3),unpack(window.scale,4))
    window.titlepos2 = Vector2(window.titlepos["x"]+(10/zoom),window.titlepos["y"]+(window.titlesize["y"]/2))
    window.namefont = dxCreateFont("assets/font.ttf",55/zoom)
    window.titlefont = dxCreateFont("assets/fonttitle.ttf",20/zoom,false)
    if not image then
        window.image = "assets/defaultbg.png"
    end
    if not namecolor then
        window.namecolor = tocolor(255,255,255)
    end
    if not titlecolor then
        window.titlecolor = tocolor(255,255,255)
    end
    unbindKey("arrow_d")
    bindKey("arrow_d","up",function()
        actual = actual+1
        if isElement(sound) then
            destroyElement(sound)
            sound = playSound("assets/change.wav",false)
        else
            sound = playSound("assets/change.wav",false)
        end
    end)
    bindKey("arrow_u","up",function()
        actual = actual-1
        if isElement(sound) then
            destroyElement(sound)
            sound = playSound("assets/change.wav",false)
        else
            sound = playSound("assets/change.wav",false)
        end
    end)
    isNativeShown = true
    addEventHandler("onClientRender",getRootElement(),renderNative)
end

function addNativePlaceholder(text)
    local table = {
        ["type"] = "placeholder",
        ["value"] = text
    }
    window.items[#window.items+1]=table
end

function renderNative()
    dxDrawImage(window.namepos,window.namesize,window.image)
    dxDrawRectangle(window.titlepos,window.titlesize,tocolor(0,0,0))
    dxDrawText(window.title,window.titlepos2,nil,nil,window.titlecolor,1,window.titlefont,"left","center")
    dxDrawText(window.name,window.namepos2,nil,nil,window.namecolor,1,window.namefont,"center","center")
    for i,v in pairs(window.items) do
        local pos = Vector2(window.titlepos["x"],window.titlepos["y"]+window.titlesize["y"]+(window.titlesize["y"]*(i-1)))
        local pos2= Vector2(window.titlepos["x"]+(10/zoom),window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(i)))
        local multiplier = 255*(0.03*i)
        if actual == i then
            color = tocolor(255,255,255,255)
            textcolor = tocolor(0,0,0,255) 
        else
            color = tocolor(0,0,0,255-multiplier)
            textcolor = tocolor(255,255,255)
        end
        dxDrawRectangle(pos,window.titlesize,color)
        dxDrawText(v.value,pos2,nil,nil,textcolor,1,window.titlefont,"left","center")
    end
    if actual > #window.items then
        actual = 1
    end
    if actual == 0 then
        actual = #window.items
    end
end

addEventHandler("onClientKey",getRootElement(),function(btn,state)
    if not isNativeShown then return end 
    if btn == "arrow_d" and state == true then
        cancelEvent()
    end
    if btn == "arrow_u" and state == true then
        cancelEvent()
    end
end)