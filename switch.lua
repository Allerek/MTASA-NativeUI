addEvent("onClientAcceptSwitch",true)
addEvent("onClientChangeSwitch",true)

function addNativeSwitch(text,values,color)
    if not color then
        color = false
   else
       color = tocolor(getColorFromString(color))
   end
    local table = {
        ["type"] = "switch",
        ["text"] = text,
        ["color"] = color,
        ["value"] = values,
        ["actual"] = 1,
    }
    window.items[#window.items+1] = table
end

function getSwitchText(id)
    assert(tonumber(id),"Bad argument @ getSwitchText [expected number at argument 1, got "..type(id).." '"..id.."'']")
    local actualswitch = window.items[id].actual
    local actualswitch = window.items[id].value[tonumber(actualswitch)]
    return actualswitch
end
