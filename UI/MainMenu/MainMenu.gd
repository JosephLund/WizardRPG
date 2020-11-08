extends Control

onready var loginButton = $LoginButton
onready var registerButton = $RegisterButton
onready var confirmRegisterButton = $ConfirmRegisterButton
onready var backButton = $BackButton
onready var confirmPassword = $ConfirmPassword
onready var email = $Email
onready var password = $Password
onready var notification = $Notification

onready var http : HTTPRequest = $HTTPRequest

enum {LOGIN, REGISTER, PASSWORD, CONFIRMPASSWORD}

var state = LOGIN
var inputFocus = null
var disabled = false

var Firebase = load("res://Firebase.gd").new()

func _ready():
	state = LOGIN

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !disabled:
			if inputFocus == PASSWORD:
				_on_LoginButton_pressed()
			if inputFocus == CONFIRMPASSWORD:
				_on_ConfirmRegisterButton_pressed()

func _on_RegisterButton_pressed():
	# hides login items
	loginButton.visible = false
	registerButton.visible = false
	
	#shows just registration items
	confirmPassword.visible = true
	confirmRegisterButton.visible = true
	backButton.visible = true
	state = REGISTER


func _on_BackButton_pressed():
	# shows login items
	loginButton.visible = true
	registerButton.visible = true
	
	#hides  registration items
	confirmPassword.visible = false
	confirmRegisterButton.visible = false
	backButton.visible = false
	
	notification.text = ""
	state = LOGIN


func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	enableButtons()
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
	else:
		if state == REGISTER:
			notification.text = "Registration Successful!"
			yield(get_tree().create_timer(2.0), "timeout")
			_on_BackButton_pressed()
		else:
			notification.text = "Login Successful!"


func _on_ConfirmRegisterButton_pressed():
	if password.text != confirmPassword.text or email.text.empty() or password.text.empty():
		notification.text = "Invalid password or username"
		return
	disableButtons()
	Firebase.register(email.text, password.text, http)


func _on_LoginButton_pressed():
	if email.text.empty() or password.text.empty():
		notification.text = "Invalid password or username"
		return
	disableButtons()
	Firebase.login(email.text, password.text, http)


func _on_Password_focus_entered():
	inputFocus = PASSWORD


func _on_Password_focus_exited():
	inputFocus = null


func _on_ConfirmPassword_focus_entered():
	inputFocus = CONFIRMPASSWORD


func _on_ConfirmPassword_focus_exited():
	inputFocus = null



func disableButtons():
	disabled = true
	loginButton.disabled = true
	registerButton.disabled = true
	confirmRegisterButton.disabled = true
	backButton.disabled = true

func enableButtons():
	disabled = false
	loginButton.disabled = false
	registerButton.disabled = false
	confirmRegisterButton.disabled = false
	backButton.disabled = false
