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


var Firebase = load("res://Firebase.gd").new()

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
	
	notification.text = ""


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
	else:
		notification.text = "Registration Successful!"
		yield(get_tree().create_timer(2.0), "timeout")
		_on_BackButton_pressed()


func _on_ConfirmRegisterButton_pressed():
	if password.text != confirmPassword.text or email.text.empty() or password.text.empty():
		notification.text = "Invalid password or username"
		return
	Firebase.register(email.text, password.text, http)


func _on_LoginButton_pressed():
	pass # Replace with function body.
