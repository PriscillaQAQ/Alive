extends Control


# @onready var popupPanel=%PopupPanel



func _on_说明_pressed() -> void:
	$AnimationPlayer.play("说明")
	pass # Replace with function body.


func _on_关闭_pressed() -> void:
	$AnimationPlayer.play_backwards("说明")
	pass # Replace with function body.
