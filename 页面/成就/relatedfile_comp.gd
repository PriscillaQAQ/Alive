extends HBoxContainer

@export var filepath:String
@export var file_name:String
@onready var file_button = %file_button
@onready var del_button = %del_button

var photo_file



func _ready():
	Signalbus.allow_change.connect(switch_status)
	if file_name != null and file_name!="":
		file_button.text=file_name
	else:
		file_button.text = filepath.get_file()

func _on_del_button_pressed():
	Signalbus.related_file_deled.emit(filepath)
	self.queue_free()

func _on_file_button_pressed():
	OS.shell_show_in_file_manager(filepath)
	
func switch_status(allow_change:bool):
	del_button.disabled=allow_change
