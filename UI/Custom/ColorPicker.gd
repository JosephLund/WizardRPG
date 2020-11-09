extends Panel

enum{RED, GREEN, BLUE}

signal color_selected

onready var pickerColorDisplay = $Display
onready var hexValue = $HexValue
onready var redValue = $RedValue
onready var greenValue = $GreenValue
onready var blueValue = $BlueValue
onready var redSlider = $Red
onready var greenSlider = $Green
onready var blueSlider = $Blue


var currentPickerColor : Color = Color(1.0, 1.0, 1.0)
var currentHex : String = "ffffff"
var updateCurrentColor : bool = true
var swapColors : bool = true
var redTextValue : String = "100"
var greenTextValue : String = "100"
var blueTextValue : String = "100"



func _ready():
	swapColors = false;
	currentHex = User.skinColor
	currentPickerColor = Color(currentHex)
	pickerColorDisplay.color = currentPickerColor
	applyColor()

func _on_Color_changed(value, color):
	if updateCurrentColor:
		match color:
			0:
				currentPickerColor.r = value * .01
			1:
				currentPickerColor.g = value * .01
			2:
				currentPickerColor.b = value * .01
			
			
		pickerColorDisplay.color = currentPickerColor
		
		updateColor()



func updateColor():
	# sets values
	redTextValue = str(int(currentPickerColor.r * 100))
	greenTextValue = str(int(currentPickerColor.g * 100))
	blueTextValue = str(int(currentPickerColor.b * 100))
	
	currentHex = currentPickerColor.to_html(false)
	redValue.text = redTextValue
	greenValue.text = greenTextValue
	blueValue.text = blueTextValue
	hexValue.text = currentHex
	redSlider.value =currentPickerColor.r * 100
	greenSlider.value =currentPickerColor.g * 100
	blueSlider.value =currentPickerColor.b * 100
	
	#Update reference shader Colors
	if swapColors:
		emit_signal("color_selected")

func applyColor():
	# sets values
	redTextValue = str(int(currentPickerColor.r * 100))
	greenTextValue = str(int(currentPickerColor.g * 100))
	blueTextValue = str(int(currentPickerColor.b * 100))
	
	currentHex = currentPickerColor.to_html(false)
	redValue.text = redTextValue
	greenValue.text = greenTextValue
	blueValue.text = blueTextValue
	hexValue.text = currentHex
	redSlider.value =currentPickerColor.r * 100
	greenSlider.value =currentPickerColor.g * 100
	blueSlider.value =currentPickerColor.b * 100
	
	swapColors = true;

func _on_HexValue_text_entered(new_text):
	var regex = RegEx.new()
	#This is to check to see if the new_text is a hexadecimal number
	regex.compile("(?:[0-9a-fA-F]{6}){1}$")
	var result = regex.search(new_text)
	if result:
		var newHex = result.get_string()
		currentPickerColor = Color(newHex)
		updateColor()
	else:
		# Cancels users input as it didnt have a valid hex value
		hexValue.text = currentHex


func _on_ColorText_entered(new_text, color):
	var regex = RegEx.new()
	#This is to check to see if the new_text is a number 000-999
	regex.compile("[0-9]{1,3}")
	var result = regex.search(new_text)
	if result:
		if int(new_text) > -1 and int(new_text) < 101:
			match color:
				0:
					currentPickerColor.r = int(new_text) * .01
				1:
					currentPickerColor.g = int(new_text) * .01
				2:
					currentPickerColor.b = int(new_text) * .01
			updateColor()
	else:
		match color:
			0:
				redValue = redTextValue
			1:
				greenValue = greenTextValue
			2:
				blueValue = blueTextValue
