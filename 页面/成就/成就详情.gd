extends Control

@onready var prize_name = %"成就全称"
@onready var prize_date = %"日期"
@onready var prize_note = %"备注"
@onready var prize_pic = %Classification
@onready var prize_class = %"奖杯"

@onready var cancel_btn = %"取消"
@onready var change_btn = %"修改"
@onready var determine_btn = %"确认"

@onready var popup_panel_container = %PopupPanelContainer
@onready var failure_msg = %"添加失败"
@onready var succeed_msg = %"添加成功"

@onready var date_picker = %DatePicker

@onready var music = %music

@onready var picture

@onready var prize:Achievement


# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.date_selected.connect(_on_date_picked_task)
	prize=GlobalVariables.update_achievement
	GlobalVariables.play_music(music)
	show_origin_achievement_detail()
	ban_edit()
	pass # Replace with function body.

func show_origin_achievement_detail():
	prize_name.text=prize.name
	prize_date.text=GlobalVariables.format_date(prize.date)
	prize_note.text=prize.note
	prize_class.selected=prize.classification
	if prize.classification==0:
		picture=load("res://assets/图标/金成就120.svg")
	elif prize.classification==1:
		picture=load("res://assets/图标/银成就120.svg")
	elif prize.classification==2:
		picture=load("res://assets/图标/铜成就120.svg")
	elif prize.classification==3:
		picture=load("res://assets/图标/证书120.svg")
	prize_pic.texture=picture
	
	determine_btn.hide()
	cancel_btn.hide()
	change_btn.show()

	
func ban_edit():
	prize_name.editable=false
	prize_note.editable=false
	prize_date.editable=false
	prize_class.disabled=true
	
	var style_box=load("res://页面/成就/te只读.tres")
	prize_note.add_theme_stylebox_override("normal",style_box)
	
	cancel_btn.hide()
	determine_btn.hide()
	change_btn.show()
	pass

func allow_change():
	prize_name.editable=true
	prize_note.editable=true
	prize_date.editable=true
	prize_class.disabled=false
	
	var style_box=load("res://页面/成就/te可改.tres")
	prize_note.add_theme_stylebox_override("normal",style_box)


func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/成就/成就.tscn")
	pass # Replace with function body.


func _on_修改_pressed():
	allow_change()
	change_btn.hide()
	determine_btn.show()
	cancel_btn.show()
	pass # Replace with function body.

func _on_确认_pressed():
	if check_prize():
		update_achievement()
		GlobalVariables.save_achievements(GlobalVariables.achievements_path)
		GlobalVariables.save_data_cloud()
		show_add_success_msg()
	else:
		popup_panel_container.show()
		pass
	pass # Replace with function body.

func check_prize():
	if prize_name.text!="" and prize_class.selected !=-1 and prize_date.text!='':
		return true
	else:
		failure_msg.show()
		return false
		
func update_achievement():
	var changed_achievement=Achievement.new()
	changed_achievement.name=prize_name.text
	changed_achievement.classification=prize_class.selected
	changed_achievement.date=GlobalVariables.time_str_2_date(prize_date.text)
	changed_achievement.note=prize_note.text
	changed_achievement.id=prize.id
	
	#GlobalVariables.achievements.append(changed_achievement)
	#GlobalVariables.achievements.erase(prize)
	GlobalVariables.achievements[GlobalVariables.achievements.find(prize)]=changed_achievement
	pass

func show_add_success_msg():
	succeed_msg.show()
	popup_panel_container.show()
	ban_edit()
	
func _on_取消_pressed():
	show_origin_achievement_detail()
	ban_edit()
	pass # Replace with function body.


func _on_奖杯_item_selected(index):
	if index==0:	
		picture=load("res://assets/图标/金成就120.svg")
	elif index==1:
		picture=load("res://assets/图标/银成就120.svg")
	elif index==2:
		picture=load("res://assets/图标/铜成就120.svg")
	elif index==3:
		picture=load("res://assets/图标/证书120.svg")
	prize_pic.texture=picture
		
	pass # Replace with function body.

func _on_关闭弹窗_pressed():
	failure_msg.hide()
	succeed_msg.hide()
	popup_panel_container.hide()
	pass # Replace with function body.
	
func _on_date_picked_task(select_date:Date):
	prize_date.clear()
	prize_date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	date_picker.hide()
	
	
func _on_日期_focus_entered():
	if prize_date.editable:
		date_picker.show()
	pass # Replace with function body.

func _on_成就全称_focus_entered():
	date_picker.hide()
	pass # Replace with function body.

func _on_奖杯_focus_entered():
	date_picker.hide()
	pass # Replace with function body.

func _on_备注_focus_entered():
	date_picker.hide()
	pass # Replace with function body.
