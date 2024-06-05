extends Control

@onready var prizeNode=preload("res://页面/成就/prize.tscn")
@onready var prize_container = %PrizeContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	show_achievements()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_确认_pressed():
	get_tree().change_scene_to_file("res://页面/成就/添加成就.tscn")
	pass # Replace with function body.
	
func show_achievements():
	for prize in GlobalVariables.achievements:
		var prize_square_node=prizeNode.instantiate()
		prize_square_node.prize=prize
		prize_container.add_child(prize_square_node)
		
		
