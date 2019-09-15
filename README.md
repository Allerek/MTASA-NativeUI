
# NativeUI

**Screen:**

## Client Functions

## Menu


**createNativeUI**


Description:

*This function will create a menu*

Parameters:

 - string Menu Title
 - string Menu Caption or bool false
 - string Image Path **Standard Picture Paths "assets/defaultbg.png" and "assets/24.png"**
 -  color Color of something no one knows what it is
 -  color Title color
 -  color Caption Color
 -  string Position that the menu will be **Possible positions right, left**
 - bool Show counter
 - bool something no one knows what it is
 - int Quantity of items per page **Recommended 10**
 - string Position that the menu title will be **Possible positions right, left, center**

**clearNativeUI**

Description:
*This function will remove all menu items.*

Parameters:

*This function has no parameters*

**removeNativeItem**

Description:
*This function will remove the item from the specified id.*

Parameters:

 - int Item ID

**removeNativeUI**

Description:
*This function will remove the menu.*

Parameters:

*This function has no parameters*

## Button

**addNativeButton**

Description:
*This function will create a button*

Parameters:

 - string Button Title
 - color Button title color
 - string Button icon **Possible icons accept, ammo, armour, art, barber, clothing**

**setNativeButtonIcon**

Description:
*This function will set the icon of the specified button.*

Parameters:

 - int Button ID
 - string Button icon **Possible icons accept, ammo, armour, art, barber, clothing**

**removeNativeButtonIcon**

Description:
*This function will remove the icon from the specified button.*

Parameters:

- int Button ID

## Checkbox

**addNativeCheckBox**

Description:
*This function will create a checkbox*

Parameters:

 - string Checkbox Title
 - color Checkbox Title Color
 - bool Set whether the check box is selected or cleared by default.

**nativeSetCheckBoxSelection**

Description:
*This function will set the tick box to be checked or unchecked.*

Parameters:

 - int Checkbox ID
 - bool Checked or unchecked

**nativeGetCheckBoxSelection**

Description:
*This function returns whether the check box is selected or not.*

Parameters:

 - int Checkbox ID

## Switch

**addNativeSwitch**

Description:
*This function will create a switch*

Parameters:

 - string Switch Title
 - table A table with switch values
 - color Switch title color

**getSwitchText**

Description:
*This function will return the selected switch value.*

Parameters:
	
- int Switch ID

**setNativeSwitchSelection**

Description:
*This function will set the value of the switch.*

Parameters:

 - Switch ID
 - int/string Switch value **This value must have in the table when creating the switch**

## Client Events

## Button

**onClientAcceptButton**

Description:
*This event is triggered when the player presses the "enter" key on any button.*

```lua
addEventHandler("onClientAcceptButton", getRootElement(), function(id, text)

	print(id, text)

end)
```

## Switch

**onClientAcceptSwitch**

Description:  
*This event is triggered when the player presses the “enter” key on any switch.*

```lua
addEventHandler("onClientAcceptSwitch", getRootElement(), function(id, value)

print(value)

end)
```

**onClientChangeSwitch**

Description:  
*This event is triggered every time the switch value changes*

```lua
addEventHandler("onClientChangeSwitch", getRootElement(), function(id, value)

print(value)

end)
```

**onClientCheckBoxChange**

Description:  
*This event is triggered every time the check box is checked or unchecked.*

```lua
addEventHandler("onClientCheckBoxChange", getRootElement(), function(id, checked)

print(nativeGetCheckBoxSelection(id))

end)
```
