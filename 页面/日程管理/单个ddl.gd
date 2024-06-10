extends PanelContainer

@onready var ddl = %"日期"
@onready var classification = %"分类"
@onready var task_name = %"任务名"
@onready var task_note = %"备注"

@onready var task:Task


# Called when the node enters the scene tree for the first time.
func _ready():
	if task:
		ddl.text=deal_task_date(task.ddl)
		classification.text="学习" if task.classification==1 else "娱乐"
		task_name.text=task.name
		task_note.text=task.description
		task_name.add_theme_color_override("font_color",task.color)
		if task.classification==1:
			classification.add_theme_color_override("font_color",Color.hex(0x5b8564))
			classification.text="学习"
		else:
			classification.add_theme_color_override("font_color",Color.hex(0xb36d70))
			classification.text="娱乐"
	else:
		pass # Replace with function body.


func deal_task_date(ddl:Date):
	var ddl_str=str(ddl.month)+"月"+str(ddl.day)+"日"
	return ddl_str

