extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_pressed():
	print(GlobalVariables.current_place)
	get_tree().change_scene_to_file("res://页面/设置/设置.tscn")
	pass # Replace with function body.
