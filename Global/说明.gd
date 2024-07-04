extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_pressed():
	get_tree().change_scene_to_file("res://页面/设置/说明三条.tscn")
	pass # Replace with function body.
