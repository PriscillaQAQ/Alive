extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	load_player_data()
	#GlobalVariables.load_data()
	pass # Replace with function body.


func _on_娱乐按钮_pressed():
	GlobalVariables.page_status=2
	get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	#get_tree().change_scene_to_file()
	pass # Replace with function body.


func _on_学习按钮_pressed():
	GlobalVariables.page_status=1
	get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	pass # Replace with function body.


func _on_攒钱_pressed():
	pass # Replace with function body.


func _on_成就_pressed():
	get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	pass # Replace with function body.
	
func load_player_data():
	pass
	

	

	
	
		

			
		
		
