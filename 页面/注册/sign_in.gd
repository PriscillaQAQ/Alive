extends Control

@onready var emailNode=%email
@onready var passwordNode=%password
@onready var password_rule=%rule
@onready var aliasNode=%"输入用户名"

@onready var popupPanel=%PopupPanelContainer
@onready var sign_succeed_msg = %"成功"
@onready var sign_fail_cuz_pw_msg = %"密码失败"
@onready var sign_fail_cuz_em_msg = %"邮箱失败"
@onready var sign_fail_cuz_al_msg=%"姓名缺失"

@onready var white_bg = %"白色背景板"
@onready var video_stream_player = %VideoStreamPlayer
@onready var video_stream_player_2 = %VideoStreamPlayer2
@onready var video_stream_player_3 = %VideoStreamPlayer3
@onready var video_stream_player_4 = %VideoStreamPlayer4
@onready var video_stream_player_5 = %VideoStreamPlayer5

func _ready():
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	

func _on_注册_pressed():
	show_loading_page()
	var alias=aliasNode.text
	var email=emailNode.text
	var password=passwordNode.text
	if not check_alias(alias):
		return
	Firebase.Auth.signup_with_email_and_password(email,password)


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

	
func on_signup_succeeded(auth):
	originate_account()
	GlobalVariables.alias=aliasNode.text
	sign_succeed_msg.show()
	popupPanel.show()
	GlobalVariables.save_data_cloud()
	close_loading_page()


func on_signup_failed(error_code,message):
	close_loading_page()
	
	print(error_code)
	print(message)
	
	var email=emailNode.text
	var password=passwordNode.text
	if password.length()<6:
		sign_fail_cuz_pw_msg.show()
	else:
		sign_fail_cuz_em_msg.show()
	popupPanel.show()


func _on_password_focus_entered():
	password_rule.show()


func _on_password_focus_exited():
	password_rule.hide()
	

func _on_关闭弹窗_pressed():
	sign_succeed_msg.hide()
	sign_fail_cuz_em_msg.hide()
	sign_fail_cuz_pw_msg.hide()
	sign_fail_cuz_al_msg.hide()
	popupPanel.hide()
	pass # Replace with function body.
	
func show_loading_page():
	white_bg.show()
	video_stream_player.show()
	video_stream_player_2.show()
	video_stream_player_3.show()
	video_stream_player_4.show()
	video_stream_player_5.show()
	
func close_loading_page():
	white_bg.hide()
	video_stream_player.hide()
	video_stream_player_2.hide()
	video_stream_player_3.hide()
	video_stream_player_4.hide()
	video_stream_player_5.hide()
	
func originate_account():
	GlobalVariables.alias=""
	GlobalVariables.life=80
	GlobalVariables.mood=80
	GlobalVariables.iq=80
	GlobalVariables.money=0
	GlobalVariables.music=1
	GlobalVariables.figure=1
	GlobalVariables.achievements=[]
	GlobalVariables.tasks=[]
	GlobalVariables.money_records=[]
