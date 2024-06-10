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

func task_to_dic():
	var task_dic={
		"id":id,
		"name":name,
		"color":color,
		"ddl":[ddl.year,ddl.month,ddl.day],
		"start_time":[[start_time[0].year,start_time[0].month,start_time[0].day],start_time[1],start_time[2]],
		"end_time":[[end_time[0].year,end_time[0].month,end_time[0].day],end_time[1],end_time[2]],
		"description":description,
		"classification":classification
	}
	return task_dic
