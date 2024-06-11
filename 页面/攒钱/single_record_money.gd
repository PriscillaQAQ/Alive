extends PanelContainer

@onready var save_date = %"日期"
@onready var money_note = %"备注"
@onready var money_value = %"金额"

@export var money_record:Money

# Called when the node enters the scene tree for the first time.
func _ready():
	if money_record:
		save_date.text=deal_record_date(money_record.date)
		money_note.text=money_record.note
		money_value.text=str(money_record.money)
	else:
		pass
func deal_record_date(date:Date):
	var date_str=str(date.month)+"月"+str(date.day)+"日"
	return date_str

