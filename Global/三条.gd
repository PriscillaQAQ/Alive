extends GridContainer

@onready var life = %"生命条"
@onready var mood = %"心情条"
@onready var iq = %"智力条"
@onready var life_l = %"生命"
@onready var mood_l = %"心情"
@onready var iq_l = %"智力"



# Called when the node enters the scene tree for the first time.
func _ready():
	life.value=GlobalVariables.life
	mood.value=GlobalVariables.mood
	iq.value=GlobalVariables.iq
	check_figure_value(GlobalVariables.life,life_l)
	check_figure_value(GlobalVariables.mood,mood_l)
	check_figure_value(GlobalVariables.iq,iq_l)
	
	pass # Replace with function body.
	
func check_figure_value(value:int,label:Label):
	var bad_font=load("res://assets/字体/LingKO゙SHIKKU-2.otf")
	var good_font=load("res://assets/字体/1.ttf")
	if value<=30:
		label.add_theme_font_override("font",bad_font)
	else:
		label.add_theme_font_override("font",good_font)


