extends VBoxContainer


@onready var button = %Button
@onready var photo_file_comp_scene = preload("res://页面/成就/relatedfile_comp.tscn")
# Called when the node enters the scene tree for the first time.
var photo_data
var current_prize

func _ready():
	Signalbus.related_file_deled.connect(_on_file_delete)
	pass # Replace with function body.



func _on_button_pressed():
	%PhotoFileDialog.show()
	pass # Replace with function body.


func _on_photo_file_dialog_file_selected(path):
	button.disabled=true
	_add_related_photo (path)
	pass # Replace with function body.


func _add_related_photo(filepath:String):
	var photo_save_data=FileAccess.get_file_as_bytes(filepath)
	photo_data={"name":filepath.get_file(),"data":photo_save_data}
	
	_add_related_photo_ui(filepath)
	pass # Replace with function body.

func _add_related_photo_ui(filepath:String):
	var relatedPhotoComp = photo_file_comp_scene.instantiate()
	relatedPhotoComp.filepath = filepath
	add_child(relatedPhotoComp)
	
func _on_file_delete(filepath:String):
	photo_data={}
	button.disabled=false
	
func load_pic():
	var relatedPhotoComp = photo_file_comp_scene.instantiate()
	relatedPhotoComp.file_name=current_prize.photo["name"]
	photo_data=current_prize.photo
	add_child(relatedPhotoComp)
