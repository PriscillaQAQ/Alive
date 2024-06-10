extends Resource

class_name Task

@export var name:String
@export var id:String
@export var color:Color
@export var ddl:Date
@export var start_time:Array
@export var end_time:Array
@export var description:String

@export var classification:int

func task_to_dic() -> Dictionary:
	var task_dic={
		"id":id,
		"name":name,
		"color":color,
		"description":description,
		"classification":classification,
		"ddl":[ddl.year,ddl.month,ddl.day],
		"start_time":start_time,
		"end_time":end_time
	}
	return task_dic
