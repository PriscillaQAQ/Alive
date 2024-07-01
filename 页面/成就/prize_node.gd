extends VBoxContainer

@onready var prize_pic=%prize_pic
@onready var prize_name=%prize_name
@export var prize: Achievement
@onready var picture

# Called when the node enters the scene tree for the first time.
func _ready():
	if prize:
		prize_name.text=prize.name
		prize_name.tooltip_text=prize.name
		prize_name.mouse_filter=0
		if prize.classification==0:
			picture=load("res://assets/图标/金成就120.svg")
		elif prize.classification==1:
			picture=load("res://assets/图标/银成就120.svg")
		elif prize.classification==2:
			picture=load("res://assets/图标/铜成就120.svg")
		elif prize.classification==3:
			picture=load("res://assets/图标/证书120.svg")
		prize_pic.texture_focused=picture
		prize_pic.texture_hover=picture
		prize_pic.texture_normal=picture
		prize_pic.texture_pressed=picture
	else:
		pass
	

func _on_prize_pic_pressed():
	GlobalVariables.update_achievement=prize
	get_tree().change_scene_to_file("res://页面/成就/成就详情.tscn")
	pass # Replace with function body.


