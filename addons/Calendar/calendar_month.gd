extends PanelContainer

@onready var calendar_label_scene = preload('res://addons/Calendar/calendar_label.tscn')
@onready var month_container = %month_container
@onready var month_label = %month_label
var month_names = ['一','二','三','四','五','六','七','八','九','十','十一','十二']

var today = GlobalVariables.get_current_date()
@export var year:int = today.year 
@export_range(1,13) var month:int = today.month

func _ready():
	_set_month_days(year,month)
	
func _clear_calendar():
	for child in month_container.get_children():
		month_container.remove_child(child)
		child.queue_free()

func _set_month_days(_year:int,_month:int):
	_clear_calendar()
	var month_data = GlobalVariables.cal.get_calendar_month(_year,_month,true,true)
	month_label.text = month_names[_month-1]+'月'
		
	#添加了week label
	_add_week_labels()
	# 添加week day
	for week in month_data:
		_add_week_days(week,_month)
	
func _add_week_labels():
	var week_labels = ['日','一','二','三','四','五','六']
	# 前面七个是week day
	for i in range(7):
		_add_day(week_labels[i],'week_label','')

func _add_week_days(week:Array,month_index:int):
	var week_index = 1
	for date in week:
		var day = date.day
		var day_type = 'normal_day' if date.month == month_index else 'day_in_other'
		if day_type == 'normal_day':
			if week_index ==1 or week_index ==7:
				day_type = 'weekends'
			if date.is_equal(today):
				day_type = 'today'
		_add_day(day,day_type,date)
		week_index +=1

func _add_day(day_label,day_type,date):
	var week_day_label = calendar_label_scene.instantiate()
	week_day_label.label_type = day_type
	week_day_label.text = str(day_label)
	week_day_label.set_meta('date',date)
	month_container.add_child(week_day_label)
