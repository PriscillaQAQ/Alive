extends Control

@onready var part_name = %"板块名称"
@onready var detail_name = %"具体名称"

@onready var whole = %"总体完成情况"
@onready var eff_life = %"生命影响"
@onready var eff_mood = %"心情影响"
@onready var eff_iq = %"智力影响"

@onready var value_list=[10,5,0,-5,-10]
@onready var times_list=[1.1,1.05,1,1.05,1.1]

@onready var fail_msg = %"添加失败"
@onready var fail_pop = %PopupPanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.current_place=6
	fail_pop.hide()
	if GlobalVariables.current_part==1:
		show_routine_relevant()
	elif GlobalVariables.current_part==2:
		show_achieve_relevant()
	else:
		show_money_relevant()
	pass # Replace with function body.

func show_routine_relevant():
	part_name.text = "日程"
	detail_name.text=GlobalVariables.update_task.name
	pass

func show_achieve_relevant():
	part_name.text = "成就"
	detail_name.text=GlobalVariables.update_achievement.name
	pass

func show_money_relevant():
	pass
	part_name.text="存储"
	detail_name.text=str(GlobalVariables.update_money_record.money)
	pass
	

func _on_取消_pressed():
	back_to_origin()

	pass # Replace with function body.

func back_to_origin():
	whole.selected=-1
	eff_life.selected=-1
	eff_mood.selected=-1
	eff_iq=-1
	
func _on_返回_pressed():
	back_to_origin()
	return_relevant_page()
	pass # Replace with function body.

func return_relevant_page():
	if GlobalVariables.current_part==1:
		# 看能不能回到对应类型的页面
		get_tree().change_scene_to_file("res://页面/日程管理/学习娱乐.tscn")
	elif GlobalVariables.current_part==2:
		get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	elif GlobalVariables.current_part==3:
		get_tree().change_scene_to_file("res://页面/攒钱/攒钱.tscn")

func _on_确认_pressed():
	if check_choice():
		var life_change=value_list[eff_life.selected]
		var mood_change=value_list[eff_mood.selected]
		var iq_change=value_list[eff_iq.selected]
		var whole_times=times_list[whole.selected]
		GlobalVariables.life+=(life_change*whole_times)
		GlobalVariables.mood+=(mood_change*whole_times)
		GlobalVariables.iq+=(iq_change*whole_times)
		
		if GlobalVariables.current_part==1:
			GlobalVariables.tasks.erase(GlobalVariables.update_task)
		
		GlobalVariables.save_player_data(GlobalVariables.player_path)
		return_relevant_page()
	else:
		fail_pop.show()
		pass
	
func check_choice():
	if whole.selected != -1 and eff_iq.selected != -1 and eff_mood.selected != -1 and eff_life.selected != -1:
		return true
	elif whole.selected == -1:
		fail_msg.text="请评价任务\n总体完成情况"
	elif eff_iq.selected == -1:
		fail_msg.text="请评价对\n生命的影响"
	elif eff_mood.selected != -1:
		fail_msg.text="请评价对\n心情的影响"
	else:
		fail_msg.text="请评价对\n智力的影响"
	return false
	pass


func _on_关闭弹窗_pressed():
	fail_pop.hide()
	pass # Replace with function body.


func _on_不反馈_pressed():
	back_to_origin()
	return_relevant_page()
	pass # Replace with function body.
