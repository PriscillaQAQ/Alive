extends Control
@onready var studyShowPanel = %"学习"
@onready var amusShowPanel = %"娱乐"
@onready var allShowPanel = %"总日程"
@onready var add_task_btn = %"添加日程"

@onready var tab_container = %TabContainer
@onready var v_box_container_0 = %VBoxContainer0
@onready var v_box_container_1 = %VBoxContainer1
@onready var v_box_container_2 = %VBoxContainer2



@onready var singleTaskNode=preload("res://页面/日程管理/single_task.tscn")





func _ready():
	tab_container.current_tab=GlobalVariables.page_status
	tab_container.tab_changed.connect(change_tab)
	if GlobalVariables.page_status==1:
		studyShowPanel.show()
	elif GlobalVariables.page_status==2:
		amusShowPanel.show()
	show_tasks()

func show_tasks():
	GlobalVariables.sort_tasks_by_date()
	if GlobalVariables.page_status==0:
		GlobalVariables.clear_container(v_box_container_0)
		for task in GlobalVariables.tasks:
			var task_node=singleTaskNode.instantiate()
			task_node.task=task
			v_box_container_0.add_child(task_node)	
			if task != GlobalVariables.tasks[-1]:
				v_box_container_0.add_child(create_line())
				
	elif GlobalVariables.page_status==1:
		GlobalVariables.clear_container(v_box_container_1)
		for task in GlobalVariables.tasks:
			if task.classification==1:
				var task_node=singleTaskNode.instantiate()
				task_node.task=task
				v_box_container_1.add_child(task_node)	
				#if task != GlobalVariables.tasks[-1]:
					#v_box_container_1.add_child(create_line())
				
	else:
		GlobalVariables.clear_container(v_box_container_2)
		for task in GlobalVariables.tasks:
			if task.classification==2:
				var task_node=singleTaskNode.instantiate()
				task_node.task=task
				v_box_container_2.add_child(task_node)	
				#if task != GlobalVariables.tasks[-1]:
					#v_box_container_2.add_child(create_line())
				
	
			
func _on_说明_pressed() -> void:
	get_tree().change_scene_to_file("res://页面/设置/说明三条.tscn")
	pass # Replace with function body.

func create_line():
	var h_line=HSeparator.new()
	var new_stylebox=StyleBoxLine.new()
	new_stylebox.thickness=2
	new_stylebox.color=Color.hex(0x73614b99)
	h_line.add_theme_stylebox_override("Separator",new_stylebox)
	return h_line


func _on_关闭_pressed() -> void:
	$AnimationPlayer.play_backwards("说明")


func _on_添加日程_pressed():
	add_task_btn.show()
	get_tree().change_scene_to_file("res://页面/日程管理/添加日程.tscn")
	pass # Replace with function body.
	
	
func _on_返回主页_pressed():
	get_tree().change_scene_to_file("res://页面/首页/首页.tscn")
	pass # Replace with function body.


func _on_ddl_pressed():
	get_tree().change_scene_to_file("res://页面/日程管理/ddl.tscn")
	pass # Replace with function body.

	
func change_tab(tab:int):
	GlobalVariables.page_status=tab
	if GlobalVariables.page_status==0:
		add_task_btn.hide()
		allShowPanel.show()
	else:
		add_task_btn.show()
		if tab==1:
			studyShowPanel.show()
		else:
			amusShowPanel.show()
			
	show_tasks()
