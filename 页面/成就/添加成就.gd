extends Control
@onready var datePcker=%DatePicker
@onready var date = %"日期"
@onready var prize_name = %"成就名称"
@onready var prize_class = %"奖杯"
@onready var prize_note = %"备注"

@onready var popup_panel = %"气泡"
@onready var p_add_failure_msg= %"添加失败"
@onready var p_add_success_msg = %"添加成功"


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
		add_achievement()
		save_locally()
		GlobalVariables.save_data_cloud()

		show_success_msg()
		pass
	else:
		show_failure_msg()
	pass # Replace with function body.
	
func check_prize():
	if prize_name.text!="" and prize_class.selected !=-1 and date.text!='':
		return true
	else:
		return false

func add_achievement():
	var achievement=Achievement.new()
	achievement.id=GlobalVariables.uuid_util.v4()
	achievement.name=prize_name.text
	achievement.date=GlobalVariables.time_str_2_date(date.text)
	achievement.note=prize_note.text
	achievement.classification=prize_class.selected
	GlobalVariables.achievements.append(achievement)

func save_locally():
	GlobalVariables.save_achievements(GlobalVariables.achievements_path)
	pass


func show_failure_msg():
	p_add_failure_msg.show()
	popup_panel.show()
	
func show_success_msg():
	p_add_success_msg.show()
	popup_panel.show()
	clear_prize_node()

	
	
func _on_成就名称_focus_entered():
	datePcker.hide()
	pass # Replace with function body.

func _on_奖杯_button_up():
	datePcker.hide()
	pass # Replace with function body.

func _on_备注_focus_entered():
	datePcker.hide()
	pass # Replace with function body.



