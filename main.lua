window = {
    options={}
}


function createNativeUI(name,title,image,color,namecolor,titlecolor,align)
    if not name then return end
    if not title then return end
    if image == nil and not color then return end
    if not align then return end
    if align ~= "left" and align ~= "right" then return end
    window = {}
    zoom = getZoom()
    window.name = name
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
    window.options={}
end

function addNativePlaceholder(text)
    local table = {
        ["type"] = "placeholder",
        ["value"] = text
    }
    window.options[#window.options+1]=table
end

addEventHandler("onClientRender",getRootElement(),function()
    dxDrawImage(window.namepos,window.namesize,window.image)
    dxDrawRectangle(window.titlepos,window.titlesize,tocolor(0,0,0))
    dxDrawText(window.name,window.titlepos2,nil,nil,window.titlecolor,1,window.titlefont,"left","center")
    dxDrawText(window.name,window.namepos2,nil,nil,window.namecolor,1,window.namefont,"center","center")
    for i,v in pairs(window.options) do
        local pos = Vector2(window.titlepos["x"],window.titlepos["y"]+window.titlesize["y"]+(window.titlesize["y"]*(i-1)))
        local pos2= Vector2(window.titlepos["x"]+(10/zoom),window.titlepos["y"]+window.titlesize["y"]/2+(window.titlesize["y"]*(i)))
        dxDrawRectangle(pos,window.titlesize,tocolor(0,0,0,255*0.6))
        dxDrawText(v.value,pos2,nil,nil,tocolor(255,255,255),1,window.titlefont,"left","center")
    end
end)