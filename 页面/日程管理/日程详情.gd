extends Control

@onready var task_name= %"日程全称"
@onready var task_date = %"日期"
@onready var task_color = %Color
@onready var task_note = %"备注"

@onready var start_date = %StartDate
@onready var start_hour = %StartHour
@onready var start_min = %StartMin
@onready var end_date = %EndDate
@onready var end_hour = %EndHour
@onready var end_min = %EndMin

@onready var change_btn = %"修改"
@onready var determine_btn= %"确认"
@onready var cancel_btn = %"取消"

@onready var date_picker = %DatePicker
@onready var fail_msg_date = %"失败日期"
@onready var fail_msg_name = %"失败名称"
@onready var fail_msg_ddl = %"失败ddl"
@onready var succeed_msg = %"修改成功"
@onready var popup_panel_container = %PopupPanelContainer

@onready var task:Task
@onready var target:int
# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.date_selected.connect(_on_date_picked_task)
	task=GlobalVariables.update_task
	origin_show()
	ban_edit()
	
func origin_show():
	task_date.text=GlobalVariables.format_date(task.ddl)
	task_name.text=task.name
	task_color.color=task.color
	task_note.text=task.description
	
	start_date.text=task.start_time[0]
	start_hour.selected=int(task.start_time[1])
	start_min.selected=int(task.start_time[2])/5
	end_date.text=task.end_time[0]
	end_hour.selected=int(task.end_time[1])
	end_min.selected=int(task.end_time[2])/5
	
	determine_btn.hide()
	cancel_btn.hide()
	change_btn.show()

func ban_edit():
	task_name.editable=false
	task_note.editable=false
	task_date.editable=false
	task_color.disabled=true
	
	start_date.editable=false
	start_hour.disabled=true
	start_min.disabled=true
	end_date.editable=false
	end_hour.disabled=true
	end_min.disabled=true
	
	var style_box=load("res://页面/日程管理/te只读.tres")
	task_note.add_theme_stylebox_override("normal",style_box)

func allow_change():
	task_name.editable=true
	task_note.editable=true
	task_date.editable=true
	task_color.disabled=false
	
	start_date.editable=true
	start_hour.disabled=false
	start_min.disabled=false
	end_date.editable=true
	end_hour.disabled=false
	end_min.disabled=false
	
	var style_box=load("res://页面/日程管理/te可改.tres")
	task_note.add_theme_stylebox_override("normal",style_box)


func _on_修改_pressed():
	allow_change()
	change_btn.hide()
	determine_btn.show()
	cancel_btn.show()
	
	pass # Replace with function body.

func _on_取消_pressed():
	origin_show()
	ban_edit()
	pass # Replace with function body.

func _on_确认_pressed():
	if check_task() and check_time_setted():
		update_tasks()
		GlobalVariables.save_tasks(GlobalVariables.tasks_path)
		GlobalVariables.save_data_cloud()
		show_add_success_msg()
	else:
		popup_panel_container.show()
		pass # Replace with function body.
	
func update_tasks():
	var changed_task=Task.new()
	changed_task.classification=task.classification
	changed_task.name=task_name.text
	changed_task.color=task_color.color
	changed_task.ddl=GlobalVariables.time_str_2_date(task_date.text)
	changed_task.description=task_note.text
	changed_task.id=task.id
	# deal detail date
	var start_hour_text=start_hour.get_item_text(start_hour.selected)
	var start_min_text=start_min.get_item_text(start_min.selected)
	changed_task.start_time=deal_detail_time(start_date.text,start_hour_text,start_min_text)
	var end_hour_text=end_hour.get_item_text(end_hour.selected)
	var end_min_text=end_min.get_item_text(end_min.selected)
	changed_task.end_time=deal_detail_time(end_date.text,end_hour_text,end_min_text)

	#update tasks
	GlobalVariables.tasks.append(changed_task)
	GlobalVariables.tasks.erase(task)
	
	
func deal_detail_time(date:String,hour:String,min:String):
	var detail_time=[date,hour,min]
	return detail_time
	
func check_task():
	if task_name.text != "" and task_date.text != "":
		return true
	else:
		if task_name.text=="":
			fail_msg_name.show()
		elif task_date.text == "":
			fail_msg_ddl.show()
		return false	
		
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
			if int(end_min.selected)>=int(start_min.selected):
				return true
			else:
				return false

func show_add_success_msg():
	cancel_btn.hide()
	determine_btn.hide()
	change_btn.show()
	succeed_msg.show()
	popup_panel_container.show()
	ban_edit()
	


func _on_关闭弹窗_pressed():
	fail_msg_date.hide()
	fail_msg_ddl.hide()
	fail_msg_name.hide()
	succeed_msg.hide()
	popup_panel_container.hide()

func _on_date_picked_task(select_date:Date):
	if target==1:
		task_date.clear()
		task_date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	elif target==2:
		start_date.clear()
		start_date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	elif target==3:
		end_date.clear()
		end_date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	target=0
	date_picker.hide()

func _on_日期_focus_entered():
	if task_date.editable:
		target=1
		date_picker.size=Vector2(432,263)
		date_picker.position=Vector2(274,422)
		date_picker.show()
	
	pass # Replace with function body.


func _on_start_date_focus_entered():
	if start_date.editable:
		target=2
		date_picker.position=Vector2(272,650)
		date_picker.size=Vector2(432,263)
		date_picker.show()
	pass # Replace with function body.


func _on_end_date_focus_entered():
	if end_date.editable:
		target=3
		date_picker.position=Vector2(272,737)
		date_picker.size=Vector2(432,263)
		date_picker.show()
	pass # Replace with function body.


func _on_color_pressed():
	if !task_color.disabled:
		date_picker.hide()
func _on_日程全称_focus_entered():
	if task_name.editable:
		date_picker.hide()
func _on_start_hour_pressed():
	if !start_hour.disabled:
		date_picker.hide()
func _on_备注_focus_entered():
	if task_note.editable:
		date_picker.hide()
func _on_start_min_pressed():
	if !start_min.disabled:
		date_picker.hide()
func _on_end_hour_pressed():
	if !end_hour.disabled:
		date_picker.hide()
func _on_end_min_pressed():
	if !end_min.disabled:
		date_picker.hide()
	pass # Replace with function body.


func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	pass # Replace with function body.
