addEventHandler("onClientResourceStart",resourceRoot,function()
    createNativeUI(nil,"Neku umar","assets/24.png",tocolor(255,255,255),tocolor(0,0,0),tocolor(255,255,255),"right",true)
    for i=1,15 do
        addNativePlaceholder("This is ąężźćłó ["..i.."]")
    end
end)