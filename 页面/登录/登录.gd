extends Control

@onready var emailNode=%"输入邮箱"
@onready var passwordNode=%"输入密码"

@onready var popupPanel=%PopupPanelContainer

@onready var white_bg = $"白色背景板"

@onready var video_stream_player = $VideoStreamPlayer
@onready var video_stream_player_2 = $VideoStreamPlayer2
@onready var video_stream_player_3 = $VideoStreamPlayer3
@onready var video_stream_player_4 = $VideoStreamPlayer4
@onready var video_stream_player_5 = $VideoStreamPlayer5



# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	
	#if Firebase.Auth.check_auth_file():
		#get_tree().change_scene_to_file("res://页面/首页/首页.tscn")
	pass # Replace with function body.


func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/初始页面/初始页.tscn")
	pass # Replace with function body.

func _on_登录_pressed():
	show_loading_page()
	var email=emailNode.text
	var password=passwordNode.text
	Firebase.Auth.login_with_email_and_password(email,password)
	pass # Replace with function body.
	
func on_login_succeeded(auth):
	GlobalVariables.load_localid()
	initial_data_save_path()
	load_local_data()
	close_loading_page()
	#Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://页面/首页/首页.tscn")
	pass

func on_login_failed(error_code,message):
	close_loading_page()
	popupPanel.show()
	print(error_code)
	print(message)
	pass

func _on_关闭弹窗_pressed():
	emailNode.clear()
	passwordNode.clear()
	popupPanel.hide()
	
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

func initial_data_save_path():
	GlobalVariables.achievements_path=GlobalVariables.get_user_data_path("achievements.cfg")
	GlobalVariables.tasks_path=GlobalVariables.get_user_data_path("tasks.cfg")
	GlobalVariables.player_path=GlobalVariables.get_user_data_path("player.cfg")
	print(GlobalVariables.achievements_path)
	
func load_local_data():
	GlobalVariables.load_user_data(GlobalVariables.user_id)



