extends Control
@onready var studyShowPanel = %"学习"
@onready var amusShowPanel = %"娱乐"
@onready var allShowPanel = %"总日程"
@onready var add_task_btn = %"添加日程"

@onready var tab_container = %TabContainer
@onready var v_box_container_0 = %VBoxContainer0


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
	for task in GlobalVariables.tasks:
		var task_node=singleTaskNode.instantiate()
		task_node.task=task
		v_box_container_0.add_child(task_node)	

func _on_说明_pressed() -> void:
	$AnimationPlayer.play("说明")
	pass # Replace with function body.


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
