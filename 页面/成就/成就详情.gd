extends Control

@onready var prize_name = %"成就全称"
@onready var prize_date = %"日期"
@onready var prize_note = %"备注"
@onready var classification = %Classification

@onready var picture


# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.prize_node_selected.connect(show_achievement_detail)
	pass # Replace with function body.

func show_achievement_detail(prize:Achievement):
	prize_name.text=prize.name
	prize_date.text=GlobalVariables.format_date(prize.date)
	prize_note.text=prize.note
	
	if prize.classification==0:
		picture=load("res://assets/图标/金成就120.svg")
	elif prize.classification==1:
		picture=load("res://assets/图标/银成就120.svg")
	elif prize.classification==2:
		picture=load("res://assets/图标/铜成就120.svg")
	elif prize.classification==3:
		picture=load("res://assets/图标/证书120.svg")
	classification.texture=picture
	
	pass

func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	pass # Replace with function body.
