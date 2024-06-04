extends Control
@onready var dataPcker=%DatePicker

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	pass # Replace with function body.


func _on_日期_focus_entered():
	dataPcker.show()
	pass # Replace with function body.
