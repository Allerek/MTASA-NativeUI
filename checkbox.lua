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