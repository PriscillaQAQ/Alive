extends Resource

class_name Money

@export var id:String
@export var date:Date
@export var money:int
@export var note:String

func money_record_to_dic() -> Dictionary:
	var money_record_dic={
		"id":id,
		"date":[date.year,date.month,date.day],
		"money":money,
		"note":note
		}
	return money_record_dic
