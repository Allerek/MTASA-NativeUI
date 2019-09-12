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

function nativeSetCheckBoxSelected(id, selected)
    if window.items[id].type == "checkbox" then 
        if window.items[id].actual == 1 then 
            window.items[id].actual = 0
        else
            window.items[id].actual = 1
        end
    end
end

function nativeGetCheckBoxSelected(id)
    if window.items[id].type == "checkbox" then 
        if window.items[id].actual == 1 then 
            return true
        else
            return false
        end
    end
end