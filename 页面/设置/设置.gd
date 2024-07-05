extends Control

@onready var option_button = %OptionButton
@onready var figure_option_button = %FigureOptionButton
@onready var fail_msg = %"修改失败"
@onready var success_msg = %"修改成功"
@onready var fail_reason = %"原因"



@onready var aliasNode = %"用户名"
@onready var new_password_node = %"新密码"

@onready var music = %music
@onready var figure_1 = %Figure1

@onready var fig_picture



# Called when the node enters the scene tree for the first time.
func _ready():
	load_bg()
	pass # Replace with function body.


func load_bg():
	figure_option_button.selected=GlobalVariables.figure-1
	option_button.selected=GlobalVariables.music-1
	aliasNode.text=GlobalVariables.alias
	MusicManager.resume_music()
	GlobalVariables.set_figure(figure_1)
	


func _on_option_button_item_selected(index):
	MusicManager.pause_music()
	var m_file_name=str(index+1)+".mp3"
	music.stream=load("res://assets/音乐/"+m_file_name)
	music.play()


func _on_返回_pressed():
	MusicManager.set_music()
	return_to_last_place()



func _on_确认_pressed():
	if check_reasonable() and check_password():
		GlobalVariables.alias=aliasNode.text
		GlobalVariables.music=option_button.selected+1
		GlobalVariables.figure=figure_option_button.selected+1
		music.stop()
		MusicManager.set_music()
		
		#云端存储
		GlobalVariables.save_player_data(GlobalVariables.player_path)
		GlobalVariables.save_data_cloud()
		show_success_msg()
	else:
		show_fail_msg()
		pass
		
func show_success_msg():
	fail_msg.hide()
	success_msg.show()
func show_fail_msg():
	success_msg.hide()
	fail_msg.show()
	

	
func check_reasonable():
	if aliasNode.text != "":
		return true
	else:
		fail_reason.text="昵称不得为空"
		return false
	pass
	
func check_password():
	var new_pw=new_password_node.text
	if new_pw.length()==0:
		return true
	elif new_pw.length()>=6:
		Firebase.Auth.change_user_password(new_pw)
		return true
	else:
		show_error()
		return false
		pass
		
func show_error():
	fail_reason.text="密码应大于六位"
	pass
	

func _on_figure_option_button_item_selected(index):
	var file_pic_name=figure_option_button.get_item_text(index)+'.png'
	fig_picture=load("res://assets/图片/"+file_pic_name)
	figure_1.texture=fig_picture
	
func return_to_last_place():
	if GlobalVariables.current_place==0:
		get_tree().change_scene_to_file("res://页面/首页/首页.tscn")
	elif GlobalVariables.current_place==1:
		get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	elif GlobalVariables.current_place==2:
		get_tree().change_scene_to_file("res://页面/日程管理/ddl.tscn")
	elif GlobalVariables.current_place==3:
		get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	elif GlobalVariables.current_place==4:
		get_tree().change_scene_to_file("res://页面/攒钱/攒钱记录.tscn")
	elif GlobalVariables.current_place==5:
		get_tree().change_scene_to_file("res://页面/攒钱/攒钱.tscn")


