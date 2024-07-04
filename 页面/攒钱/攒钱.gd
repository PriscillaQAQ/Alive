extends Control

@onready var money = %money
@onready var figure_1 = %Figure1



# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.current_place=5
	GlobalVariables.set_figure(figure_1)
	if GlobalVariables.money<=9999:
		money.text=str(GlobalVariables.money)
	else:
		money.text="9999"
	
	pass # Replace with function body.

func _on_添加_pressed():
	get_tree().change_scene_to_file("res://页面/攒钱/添加攒钱.tscn")
	pass # Replace with function body.


func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/首页/首页.tscn")
	pass # Replace with function body.


func _on_纪录_pressed():
	get_tree().change_scene_to_file("res://页面/攒钱/攒钱记录.tscn")
	pass # Replace with function body.
