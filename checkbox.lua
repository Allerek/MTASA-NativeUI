function addNativeCheckBox(text, color, check)
    if type(color) == "string" then
        color = tocolor(getColorFromString(color))
    end
    color = color or tocolor(255, 255, 255)
    local table = {
        ["type"] = "checkbox",
        ["color"] = color,
        ["text"] = text,
        ["actual"] = check
    }
    window.items[#window.items+1] = table
end

function nativeSetCheckBoxSelection(id, selection)
    if not id or not selection then return end
    assert(tonumber(id),"Bad argument @ nativeSetCheckBoxSelection [expected number at argument 1,  got "..type(id).." '"..id.."'']")
    assert(tonumber(selection),"Bad argument @ nativeSetCheckBoxSelection[expected number at argument 2,  got "..type(selection).." '"..selection.."'']")
    if window.items[id].type == "checkbox" then 
        window.items[id].actual = selection
    end
end

function nativeGetCheckBoxSelection(id)
    if not id then return end
    assert(tonumber(id),"Bad argument @ nativeSetCheckBoxSelection [expected number at argument 1,  got "..type(id).." '"..id.."'']")
    if window.items[id].type == "checkbox" then 
        if window.items[id].actual == 1 then 
            return true
        else
            return false
        end
    end
end
