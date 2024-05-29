extends Control

@onready var emailNode=%"输入邮箱"
@onready var passwordNode=%"输入密码"

@onready var popupPanel=%PopupPanel


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	pass # Replace with function body.


func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/初始页面/初始页.tscn")
	pass # Replace with function body.


func _on_登录_pressed():
	var email=emailNode.text
	var password=passwordNode.text
	Firebase.Auth.login_with_email_and_password(email,password)

	pass # Replace with function body.
	
func on_login_succeeded(auth):
	get_tree().change_scene_to_file("res://页面/首页.tscn")
	pass

func on_login_failed(error_code,message):
	popupPanel.show()
	print(error_code)
	print(message)
	pass


func _on_关闭弹窗_pressed():
	emailNode.clear()
	passwordNode.clear()
	popupPanel.hide()
	pass # Replace with function body.
