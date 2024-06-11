extends GridContainer

@onready var life = %"生命条"
@onready var mood = %"心情条"
@onready var iq = %"智力条"


# Called when the node enters the scene tree for the first time.
func _ready():
	life.value=GlobalVariables.life
	mood.value=GlobalVariables.mood
	iq.value=GlobalVariables.iq
	pass # Replace with function body.


