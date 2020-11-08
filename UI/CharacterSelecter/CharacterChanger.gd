extends Control

onready var baseBody = $BaseBody
onready var colorPicker = $ColorPicker
onready var username = $Username
onready var notification = $Notification
onready var http = $HTTPRequest

var Firebase = load("res://Firebase.gd").new()

var newUser := false
var informationSent = false 
var user :={
	"username":{},
	"skinColor":{}
} setget setUser
#	User.username = username.text
#	User.skinColor = colorPicker.currentHex
#	User.newUser = false
func _ready():
	self.user.username = {"stringValue": User.username}
	self.user.skinColor = User.skinColor
	self.newUser = User.newUser


func _on_Color_Picker_color_selected():
	baseBody.self_modulate = colorPicker.currentPickerColor


func _on_SaveButton_pressed():
	if username.text.empty():
		notification.text = "Please enter a username"
		return
	user.username = {"stringValue": username.text}
	user.skinColor = {"stringValue": colorPicker.currentHex}
	match newUser:
		true:
			Firebase.save_document("users?documentId=%s" % User.id, user, http)
		false:
			Firebase.update_document("users/%s" % User.id, user, http)


func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		200:
			notification.text = "Character saved!"
			self.user = result_body.fields

func setUser(value: Dictionary) -> void:
	user = value
	username.text = user.username.stringValue
