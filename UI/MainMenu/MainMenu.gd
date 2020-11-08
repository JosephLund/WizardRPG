extends Control

onready var loginButton = $LoginButton
onready var registerButton = $RegisterButton
onready var confirmRegisterButton = $ConfirmRegisterButton
onready var backButton = $BackButton
onready var confirmPassword = $ConfirmPassword



func _ready():
	pass




func _on_RegisterButton_pressed():
	# hides login items
	loginButton.visible = false
	registerButton.visible = false
	
	#shows just registration items
	confirmPassword.visible = true
	confirmRegisterButton.visible = true
	backButton.visible = true


func _on_BackButton_pressed():
	# shows login items
	loginButton.visible = true
	registerButton.visible = true
	
	#hides  registration items
	confirmPassword.visible = false
	confirmRegisterButton.visible = false
	backButton.visible = false
