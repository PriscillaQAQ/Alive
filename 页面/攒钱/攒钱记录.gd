extends Control

@onready var v_box_container = %VBoxContainer
@onready var money_record_node=preload("res://页面/攒钱/single_record_money.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	show_records()
	pass # Replace with function body.


func show_records():
	GlobalVariables.sort_records_by_date_after()
	for record in GlobalVariables.money_records:
		var record_node=money_record_node.instantiate()
		record_node.money_record=record
		v_box_container.add_child(record_node)
	
func _on_返回主页_pressed():
	get_tree().change_scene_to_file("res://页面/攒钱/攒钱.tscn")
	pass # Replace with function body.
