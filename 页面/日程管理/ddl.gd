extends Control

@onready var v_box_container = %VBoxContainer
@onready var single_ddl_node=preload("res://页面/日程管理/单个ddl.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	show_ddl()
	pass # Replace with function body.

func show_ddl():
	GlobalVariables.clear_container(v_box_container)
	GlobalVariables.sort_tasks_by_ddl()
	for each_task in GlobalVariables.tasks:
		var ddl_node=single_ddl_node.instantiate()
		ddl_node.task=each_task
		v_box_container.add_child(ddl_node)
		

func _on_返回主页_pressed():
	get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	pass # Replace with function body.
