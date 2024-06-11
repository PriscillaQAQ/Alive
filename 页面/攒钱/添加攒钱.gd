extends Control

@onready var money_date = %"日期"
@onready var money_value = %"存钱金额"
@onready var money_note = %"备注"

@onready var date_picker =%DatePicker

@onready var popup_panel = %"气泡"
@onready var p_add_failure_msg = %"添加失败"
@onready var p_add_success_msg = %"添加成功"



# Called when the node enters the scene tree for the first time.
func _ready():
	popup_panel.hide()
	Signalbus.date_selected.connect(_on_pick_date)
	pass # Replace with function body.



func _on_日期_focus_entered():
	date_picker.show()
	pass # Replace with function body.
	
func _on_pick_date(select_date:Date):
	money_date.clear()
	money_date.text=str(select_date.year)+'/'+str(select_date.month)+'/'+str(select_date.day)
	date_picker.hide()
	pass


func _on_取消_pressed():
	clear_node_data()
	pass # Replace with function body.
	
func clear_node_data():
	money_date.clear()
	money_note.clear()
	money_value.clear()

func _on_确认_pressed():
	if check_money():
		add_money()
		GlobalVariables.save_money_records(GlobalVariables.money_records_path)
		GlobalVariables.save_data_cloud()
		show_success_msg()
		
		GlobalVariables.current_part=3
		get_tree().change_scene_to_file("res://页面/反馈/反馈.tscn")
		
	else:
		show_failure_msg()


func add_money():
	var added_money=Money.new()
	added_money.id=GlobalVariables.uuid_util.v4()
	added_money.note=money_note.text
	added_money.date=GlobalVariables.time_str_2_date(money_date.text)
	added_money.money=int(money_value.text)
	GlobalVariables.money_records.append(added_money)
	GlobalVariables.money+=added_money.money
	GlobalVariables.update_money_record=added_money
	pass

func check_money():
	if money_date.text!="":
		if money_value.text.is_valid_int():
			return true
		else:
			return false
	else:
		return false
		
func show_success_msg():
	p_add_failure_msg.hide()
	p_add_success_msg.show()
	popup_panel.show()
	clear_node_data()
	
func show_failure_msg():
	p_add_success_msg.hide()
	p_add_failure_msg.show()
	popup_panel.show()
	
