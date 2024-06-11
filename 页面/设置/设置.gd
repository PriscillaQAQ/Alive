extends Control

@onready var option_button = %OptionButton

@onready var m_1 = %"1"
@onready var m_2 = %"2"
@onready var m_3 = %"3"
@onready var m_4 = %"4"
@onready var m_5 = %"5"


# Called when the node enters the scene tree for the first time.
func _ready():
	play_music()
	load_bg()
	pass # Replace with function body.
	
func play_music():
	pass

func load_bg():
	pass

func _on_option_button_item_selected(index):
	var music_option=[m_1,m_2,m_3,m_4,m_5]
	stop_all_play()
	music_option[index].play()
	pass # Replace with function body.

func stop_all_play():
	var music_option=[m_1,m_2,m_3,m_4,m_5]
	for music in music_option:
		music.stop()


func _on_返回_pressed():
	get_tree().change_scene_to_file("res://页面/首页/首页.tscn")
	pass # Replace with function body.
