extends Resource

class_name Achievement

@export var id:String
@export var name:String
@export var date:Date
@export var classification:int
@export var note:String

func achieve_to_dic() -> Dictionary:
	var achieve_dic={
		"id":id,
		"name":name,
		"date":[date.year,date.month,date.day],
		"classification":classification,
		"note":note
		}
	return achieve_dic
