extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_注册_pressed():
	get_tree().change_scene_to_file("res://页面/注册/注册.tscn")
	pass # Replace with function body.


func _on_登录_pressed():
	get_tree().change_scene_to_file("res://页面/登录/登录.tscn")
	pass # Replace with function body.
