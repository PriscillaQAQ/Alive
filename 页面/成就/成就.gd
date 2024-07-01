extends Control

@onready var prizeNode=preload("res://页面/成就/prize.tscn")
@onready var prize_container = %PrizeContainer
@onready var limit_class_btn = %"筛选按钮"
@onready var order_date_btn = %"日期排序"

var showing_achievements=[]

# Called when the node enters the scene tree for the first time.
func _ready():
	show_achievements()
	var popup_menu_class=limit_class_btn.get_popup()
	var popup_menu_date=order_date_btn.get_popup()
	popup_menu_class.id_pressed.connect(_on_select_class)
	popup_menu_date.id_pressed.connect(_on_select_date)
	
	pass # Replace with function body.



func _on_确认_pressed():
	get_tree().change_scene_to_file("res://页面/成就/添加成就.tscn")
	pass # Replace with function body.
	
func show_achievements():
	GlobalVariables.clear_grid_container(prize_container)
	showing_achievements=GlobalVariables.achievements
	for prize in GlobalVariables.achievements:
		var prize_square_node=prizeNode.instantiate()
		prize_square_node.prize=prize
		prize_container.add_child(prize_square_node)
		
func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/首页/首页.tscn")
	pass # Replace with function body.


func _on_筛选按钮_pressed():
	show_popup_panel()
	pass # Replace with function body.
func show_popup_panel():
	var popup_menu=limit_class_btn.get_popup()
	popup_menu.get_window().transparent = true
	popup_menu.position=Vector2i(476,267)
	
func _on_select_class(id:int):
	GlobalVariables.clear_grid_container(prize_container)
	if id==4:
		show_achievements()
	else:
		var re_showing_achievements=[]
		for prize in GlobalVariables.achievements:
			if prize.classification==id:
				var prize_square_node=prizeNode.instantiate()
				prize_square_node.prize=prize
				prize_container.add_child(prize_square_node)
				
				re_showing_achievements.append(prize)
		showing_achievements=re_showing_achievements


func _on_日期排序_pressed():
	show_popup_panel_date()
	pass # Replace with function body.
func show_popup_panel_date():
	var popup_menu=order_date_btn.get_popup()
	popup_menu.get_window().transparent = true
	popup_menu.position=Vector2i(467,267)
	
func _on_select_date(id:int):
	if id==0:
		showing_achievements.sort_custom(_sort_achievements_asc)
	elif id==1:
		showing_achievements.sort_custom(_sort_achievements_des)
		
	GlobalVariables.clear_grid_container(prize_container)
	for prize in showing_achievements:
		var prize_square_node=prizeNode.instantiate()
		prize_square_node.prize=prize
		prize_container.add_child(prize_square_node)
		
		
func _sort_achievements_asc(achieve1:Achievement,achieve2:Achievement):
	if achieve1.date.is_before(achieve2.date):
		return true
	else:
		return false
		
func _sort_achievements_des(achieve1:Achievement,achieve2:Achievement):
	if achieve1.date.is_after(achieve2.date):
		return true
	else:
		return false
	
	
