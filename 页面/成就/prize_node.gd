extends VBoxContainer

@onready var prize_pic=%prize_pic
@onready var prize_name=%prize_name
@export var prize: Achievement

# Called when the node enters the scene tree for the first time.
func _ready():
	prize_name.text=prize.name
	if prize.classification==1:
		prize_pic.texture="res://assets/图标/金成就120.svg"
	elif prize.classification==2:
		prize_pic.texture="res://assets/图标/银成就120.svg"
	elif prize.classification==3:
		prize_pic.texture="res://assets/图标/铜成就120.svg"
	
	
	pass # Replace with function body.
