extends PanelContainer

@onready var start_time = %"开始日期"
@onready var end_time = %"截止日期"
@onready var task_name = %"任务名"
@onready var task_note = %"备注"

@onready var task: Task



# Called when the node enters the scene tree for the first time.
func _ready():
	if task:
		start_time.text=deal_task_time(task.start_time)
		end_time.text=deal_task_time(task.end_time)
		task_name.text=task.name
		task_note.text=task.description
		task_name.add_theme_color_override("font_color",task.color)
	else:
		pass # Replace with function body.

func deal_task_time(detailed_time:Array):
	var date=GlobalVariables.time_str_2_date(detailed_time[0])
	var date_str=str(date.month)+"月"+str(date.day)+"日"
	var time_str=detailed_time[1]+":"+detailed_time[2]
	return date_str+time_str

func _on_编辑_pressed():
	GlobalVariables.update_task=task
	get_tree().change_scene_to_file("res://页面/日程管理/日程详情.tscn")

	pass # Replace with function body.

func _on_完成_pressed():
	GlobalVariables.update_task=task
	GlobalVariables.tasks.erase(GlobalVariables.update_task)
	GlobalVariables.current_part=1
	get_tree().change_scene_to_file("res://页面/反馈/反馈.tscn")
	pass # Replace with function body.
