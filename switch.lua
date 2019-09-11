addEvent("onClientAcceptSwitch", true)
addEvent("onClientChangeSwitch", true)

function addNativeSwitch(text, values, color)
    if type(color) == "string" then
        color = tocolor(getColorFromString(color))
    end
    color = color or tocolor(255, 255, 255)
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
    assert(tonumber(id), "Bad argument @ getSwitchText [expected number at argument 1,  got "..type(id).." '"..id.."'']")
    local actualswitch = window.items[id].actual
    local actualswitch = window.items[id].value[tonumber(actualswitch)]
    return actualswitch
end

function setNativeSwitchSelection(id,selection)
    if not id or not selection then return end
    assert(tonumber(id),"Bad argument @ setNativeButtonIcon [expected number at argument 1,  got "..type(id).." '"..id.."'']")
    if window.items[id].type ~= "switch" then return end
    itemindex = 1
    for i,v in pairs(window.items[id].value) do
        if v == selection then
            print(i)
            itemindex = i
        end
    end
    window.items[id].actual = itemindex
end