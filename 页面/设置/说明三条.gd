extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_返回_pressed():
	return_to_last_place()
	pass # Replace with function body.

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
	elif GlobalVariables.current_place==6:
		get_tree().change_scene_to_file("res://页面/反馈/反馈.tscn")
