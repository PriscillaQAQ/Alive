extends Control


@onready var vbox = %vbox
@onready var player_data_bars= %"三条"
@onready var texture_rect = %TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.current_place=0
	player_data_bars.show()
	GlobalVariables.page_status=0
	GlobalVariables.set_figure_ogv(texture_rect,"shoot_gun")
	#GlobalVariables.load_data()
	pass # Replace with function body.


func _on_娱乐按钮_pressed():
	get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	#get_tree().change_scene_to_file()
	pass # Replace with function body.


func _on_学习按钮_pressed():
	GlobalVariables.page_status=1
	get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	pass # Replace with function body.


func _on_攒钱_pressed():
	get_tree().change_scene_to_file("res://页面/攒钱/攒钱.tscn")
	pass # Replace with function body.


func _on_成就_pressed():
	get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	pass # Replace with function body.

func _on_说明_pressed():
	get_tree().change_scene_to_file("res://页面/设置/说明三条.tscn")
	pass # Replace with function body.


func _on_设置_pressed():
	#MusicManager.pause_music()
	get_tree().change_scene_to_file("res://页面/设置/设置.tscn")
	pass # Replace with function body.
