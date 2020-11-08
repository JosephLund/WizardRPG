extends Control

onready var baseBody = $BaseBody
onready var colorPicker = $ColorPicker

func _ready():
	pass


func _on_Color_Picker_color_selected():
	baseBody.self_modulate = colorPicker.currentPickerColor
