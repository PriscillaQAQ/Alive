extends Control


@onready var vbox = %vbox
@onready var player_data_bars= %"三条"
@onready var texture_rect = %TextureRect


const notif=preload("res://页面/首页/notif.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.current_place=0
	player_data_bars.show()
	GlobalVariables.page_status=0
	GlobalVariables.set_figure_ogv(texture_rect,"shoot_gun")
	check_figure_value()
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

func check_figure_value():
	var origin_child=get_child_count()
	if GlobalVariables.life<=30:
		print(1)
		show_notif("生命垂危T^T  请注意休息^ ^",origin_child)
	if GlobalVariables.mood<=30:
		print(2)
		show_notif("心情低落T^T  放松一下吧～",origin_child)
	if GlobalVariables.iq<=30:
		print(3)
		show_notif("智力堪忧T^T  快去学习！",origin_child)
		
func show_notif(text:String,basic_node:int):
	while get_child_count() != basic_node:
		await get_tree().create_timer(0.1).timeout
		if get_child_count()==basic_node:
			continue
	var notif_temp=notif.instantiate()
	notif_temp.get_node("Panel/Label").text=text
	add_child(notif_temp)
	await get_tree().create_timer(2).timeout
	notif_temp.queue_free()
