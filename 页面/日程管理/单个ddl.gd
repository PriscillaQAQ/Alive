extends PanelContainer

@onready var ddl = %"日期"
@onready var classification = %"分类"
@onready var task_name = %"任务名"
@onready var task_note = %"备注"
@onready var emergent_tip = %"紧急提示"


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
		
		check_emergent()
	else:
		pass # Replace with function body.


func deal_task_date(ddl:Date):
	var ddl_str=str(ddl.month)+"月"+str(ddl.day)+"日"
	return ddl_str

func check_emergent():
	var most_emergent=Date.today()
	most_emergent.add_days(1)
	var second_emergent=Date.today()
	second_emergent.add_days(2)
	var third_emergent=Date.today()
	third_emergent.add_days(3)
	
	if (third_emergent.is_equal(task.ddl) or third_emergent.is_after(task.ddl)) and Date.today().is_before(task.ddl):
		if most_emergent.is_equal(task.ddl):
			print(1)
			show_emergent("1")
		if second_emergent.is_equal(task.ddl):
			print(2)
			show_emergent("2")
		if third_emergent.is_equal(task.ddl):
			print(3)
			show_emergent("3")
			
	if Date.today().is_after(task.ddl):
		set_special_ddl(Color.hex(0x9f9f9fff))
		show_emergent("0")
	
	if Date.today().is_equal(task.ddl):
		set_special_ddl(Color.hex(0xff0000ff))
		show_emergent("1")
		
func set_special_ddl(sp_color:Color):
	ddl.add_theme_color_override("font_color",sp_color)
	task_name.add_theme_color_override("font_color",sp_color)
	classification.add_theme_color_override("font_color",sp_color)
	task_note.add_theme_color_override("font_color",sp_color)
	
func show_emergent(degree:String):
	var file_name="res://assets/图标/感叹号"
	var clue_pic=load(file_name+degree+".svg")
	emergent_tip.texture=clue_pic
	set_emergent_tip_text(degree)
	emergent_tip.show()
	pass
	
func set_emergent_tip_text(degree:String):
	if degree=="1":
		emergent_tip.tooltip_text="期限将至(;´༎ຶД༎ຶ`)"
	elif degree=="2":
		emergent_tip.tooltip_text="还有两天orz"
	elif degree=="3":
		emergent_tip.tooltip_text="还有三天orz"
	elif degree=="0":
		emergent_tip.tooltip_text="ddl已过T^T"
		
		
	

