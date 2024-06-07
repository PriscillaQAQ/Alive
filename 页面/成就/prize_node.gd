extends VBoxContainer

@onready var prize_pic=%prize_pic
@onready var prize_name=%prize_name
@export var prize: Achievement
@onready var picture

# Called when the node enters the scene tree for the first time.
func _ready():
	if prize:
		prize_name.text=prize.name
		if prize.classification==0:
			picture=load("res://assets/图标/金成就120.svg")
		elif prize.classification==1:
			picture=load("res://assets/图标/银成就120.svg")
		elif prize.classification==2:
			picture=load("res://assets/图标/铜成就120.svg")
		elif prize.classification==3:
			picture=load("res://assets/图标/证书120.svg")
		prize_pic.texture=picture
	else:
		pass
	
	pass # Replace with function body.
