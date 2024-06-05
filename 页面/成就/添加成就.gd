extends Control
@onready var datePcker=%DatePicker
@onready var date = %"日期"
@onready var prize_name = %"成就名称"
@onready var prize_class = %"奖杯"
@onready var prize_note = %"备注"




# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.date_selected.connect(_on_pick_date)
	pass # Replace with function body.


func _on_日期_focus_entered():
	datePcker.show()
	pass # Replace with function body.

func _on_pick_date(select_date:Date):
	date.clear()
	date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	datePcker.hide()
	pass
	

func _on_返回_pressed():
	clear_prize_node()
	get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	pass # Replace with function body.
	
func clear_prize_node():
	prize_name.clear()
	prize_note.clear()
	prize_class.selected=-1
	date.clear()
	
func _on_取消_pressed():
	clear_prize_node()
	pass # Replace with function body.
	
func _on_确认_pressed():
	if check_prize():
		var achievement=Achievement.new()
		achievement.name=prize_name.text
		achievement.date=deal_str_date(date.text)
		achievement.note=prize_note.text
		achievement.classification=prize_class.selected
		GlobalVariables.achievements.append(achievement)
		print(GlobalVariables.achievements)
		# achievement.classification=
		pass
	else:
		print('Error input.')
	pass # Replace with function body.
	
func check_prize():
	if prize_name.text!="" and prize_class.selected !=-1 and date.text!='':
		return true
	else:
		return false
		
func deal_str_date(date_str:String) -> Date:
	var date_array=date_str.split('/')
	var year=int(date_array[0])
	var month=int(date_array[1])
	var day=int(date_array[2])
	var date_date=Date.new(year,month,day)
	return date_date
	
	




