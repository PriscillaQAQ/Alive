extends Control

@onready var emailNode=%email
@onready var passwordNode=%password
@onready var password_rule=%rule
@onready var aliasNode=%"输入用户名"


@onready var popupPanel=%PopupPanel
@onready var sign_succeed_msg = %"成功"
@onready var sign_fail_cuz_pw_msg = %"密码失败"
@onready var sign_fail_cuz_em_msg = %"邮箱失败"
@onready var sign_fail_cuz_al_msg=%"姓名缺失"


# Called when the node enters the scene tree for the first time.
func _ready():

	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	pass # Replace with function body.


func _on_注册_pressed():
	var alias=aliasNode.text
	var email=emailNode.text
	var password=passwordNode.text
	if not check_alias(alias):
		return
	print(email)
	print(password)
	Firebase.Auth.signup_with_email_and_password(email,password)
	pass # Replace with function body.

func check_alias(alias):
	if alias=='':
		sign_fail_cuz_al_msg.show()
		popupPanel.show()
		return false
	else:
		return true

func _on_返回_pressed():
	emailNode.clear()
	passwordNode.clear()
	get_tree().change_scene_to_file("res://页面/初始页面/初始页.tscn")
	pass # Replace with function body.
	
func on_signup_succeeded(auth):
	sign_succeed_msg.show()
	popupPanel.show()
	print(auth)
	pass

func on_signup_failed(error_code,message):
	var email=emailNode.text
	var password=passwordNode.text
	if password.length()<6:
		sign_fail_cuz_pw_msg.show()
	else:
		sign_fail_cuz_em_msg.show()
	popupPanel.show()
	pass

func _on_password_focus_entered():
	password_rule.show()
	pass # Replace with function body.


func _on_password_focus_exited():
	password_rule.hide()
	pass # Replace with function body.

func _on_关闭弹窗_pressed():
	sign_succeed_msg.hide()
	sign_fail_cuz_em_msg.hide()
	sign_fail_cuz_pw_msg.hide()
	sign_fail_cuz_al_msg.hide()
	popupPanel.hide()
	pass # Replace with function body.
