extends Control
@onready var datePcker=%DatePicker
@onready var date = %"日期"



# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.date_selected.connect(_on_pick_date)
	pass # Replace with function body.


func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	pass # Replace with function body.


func _on_日期_focus_entered():
	datePcker.show()
	pass # Replace with function body.

func _on_pick_date(select_date:Calendar.Date):
	date.clear()
	date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	datePcker.hide()
	pass
