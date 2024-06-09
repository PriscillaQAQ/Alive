extends Control
@onready var studyShowPanel = %"学习"
@onready var amusShowPanel = %"娱乐"
@onready var allShowPanel = %"总日程"




func _ready():
	allShowPanel.show()
	if GlobalVariables.page_status==1:
		_on_学习_focus_entered()
	elif GlobalVariables.page_status==2:
		_on_娱乐_focus_entered()
	GlobalVariables.page_status=0

# @onready var popupPanel=%PopupPanel

func _on_说明_pressed() -> void:
	$AnimationPlayer.play("说明")
	pass # Replace with function body.


func _on_关闭_pressed() -> void:
	$AnimationPlayer.play_backwards("说明")


func _on_添加日程_pressed():
	get_tree().change_scene_to_file("res://页面/日程管理/添加日程.tscn")
	pass # Replace with function body.


func _on_学习_focus_entered():
	studyShowPanel.show()


func _on_娱乐_focus_entered():
	amusShowPanel.show()
	
	
func _on_返回主页_pressed():
	get_tree().change_scene_to_file("res://页面/首页/首页.tscn")
	pass # Replace with function body.


func _on_ddl_pressed():
	get_tree().change_scene_to_file("res://页面/日程管理/ddl.tscn")
	pass # Replace with function body.
