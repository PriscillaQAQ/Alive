extends Control

@onready var routine_name = %Routine
@onready var routine_color = %Color
@onready var routine_ddl = %DDL
@onready var routine_note = %Note

@onready var start_date = %StartDate
@onready var start_hour = %StartHour
@onready var start_min = %StartMin
@onready var end_date = %EndDate
@onready var end_hour = %EndHour
@onready var end_min = %EndMin

@onready var date_picker = %DatePicker
@onready var popup_panel_container = %PopupPanelContainer

@onready var fail_msg_date = $"PopupPanelContainer/失败日期"
@onready var fail_msg_name = $"PopupPanelContainer/失败名称"
@onready var fail_msg_ddl = $"PopupPanelContainer/失败ddl"
@onready var succeed_msg = $"PopupPanelContainer/添加成功"

#let datePicker determine its target
@onready var target=0








# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.date_selected.connect(_on_date_picked_task)
	pass # Replace with function body.

func _on_确认_pressed():
	if check_task() and check_time_setted():
		add_task()
		save_task_locally()
		show_add_success_msg()
		pass
	else:
		popup_panel_container.show()
		pass
	pass # Replace with function body.

func check_task():
	if routine_name.text != "" and routine_ddl.text != "":
		return true
	else:
		if routine_name.text=="":
			fail_msg_name.show()
		elif routine_ddl.text == "":
			fail_msg_ddl.show()
		return false	

func add_task():
	var task=Task.new()
	task.name=routine_name.text
	task.color=routine_color.color
	task.ddl=GlobalVariables.time_str_2_date(routine_ddl.text)
	task.description=routine_note.text
	# deal detail date
	var start_hour_text=start_hour.get_item_text(start_hour.selected)
	var start_min_text=start_hour.get_item_text(start_min.selected)
	task.start_time=deal_detail_time(start_date.text,start_hour_text,start_hour_text)
	var end_hour_text=end_hour.get_item_text(end_hour.selected)
	var end_min_text=end_hour.get_item_text(end_min.selected)
	task.end_time=deal_detail_time(end_date.text,end_hour_text,end_min_text)
	
	GlobalVariables.tasks.append(task)
	show_add_success_msg()
	
func deal_detail_time(date:String,hour:String,min:String):
	var detail_time=[GlobalVariables.time_str_2_date(date),int(hour),int(min)]
	return detail_time
	
func check_time_setted():
	if start_date.text!="" and start_hour.selected != -1 and start_min.selected != -1:
		if end_date.text != "" and end_hour.selected != -1 and end_min.selected != -1:
			if check_timesetting_follow_rule():
				return true
			else:
				fail_msg_date.show()
				return false
		else:
			fail_msg_date.show()
			return false
	else:
		fail_msg_date.show()
		return false

func check_timesetting_follow_rule():
	var start_date_date=GlobalVariables.time_str_2_date(start_date.text)
	var end_date_date=GlobalVariables.time_str_2_date(end_date.text)
	if end_date_date.is_after(start_date_date):
		return true
	elif end_date_date.is_before(start_date_date):
		return false
	else:
		if int(end_hour.selected)>int(start_hour.selected):
			return true
		elif int(end_hour.selected)<int(start_hour.selected):
			return false
		else:
			if int(end_min)>=int(start_min):
				return true
			else:
				return false

func save_task_locally():
	pass

func show_add_success_msg():
	succeed_msg.show()
	popup_panel_container.show()


func _on_取消_pressed():
	clear_nodes_data()
	pass # Replace with function body.
	
func clear_nodes_data():
	routine_name.clear()
	routine_color.color=Color.hex(0x74706a)
	routine_ddl.clear()
	routine_note.clear()
	time_clear()
	
func time_clear():
	start_date.clear()
	end_date.clear()
	start_hour.selected=-1
	end_hour.selected=-1
	start_min.selected=-1
	end_min.selected=-1


func _on_返回_pressed():
	clear_nodes_data()
	get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	pass # Replace with function body.


	
func _on_date_picked_task(select_date:Date):
	print("enter choose")
	if target==1:
		routine_ddl.clear()
		routine_ddl.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	elif target==2:
		start_date.clear()
		start_date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	elif target==3:
		end_date.clear()
		end_date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	target=0
	date_picker.hide()


func _on_ddl_focus_entered():
	target=1
	date_picker.position=Vector2(164,330)
	date_picker.size=Vector2(518,291)
	date_picker.show()
	pass # Replace with function body.


func _on_start_date_focus_entered():
	target=2
	date_picker.position=Vector2(164,554)
	date_picker.size=Vector2(432,263)
	date_picker.show()


func _on_end_date_focus_entered():
	target=3
	date_picker.position=Vector2(164,642)
	date_picker.size=Vector2(432,263)
	date_picker.show()



func _on_关闭弹窗_pressed():
	fail_msg_date.hide()
	fail_msg_ddl.hide()
	fail_msg_name.hide()
	succeed_msg.hide()
	popup_panel_container.hide()
	pass # Replace with function body.











