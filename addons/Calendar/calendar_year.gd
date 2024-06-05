extends PanelContainer

@onready var year_container = %year_container
@onready var month_scene = preload("res://addons/Calendar/calendar_month.tscn")
@onready var year_label = %year_label
@export var year_to_show:int = 2024
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_year(year_to_show)
	

func _clear_calendar():
	for child in year_container.get_children():
		year_container.remove_child(child)
		child.queue_free()

func _set_year(year:int):
	_clear_calendar()
	year_label.text = str(year)
	GlobalVariables.cal.set_first_weekday(Time.WEEKDAY_SUNDAY)
	for month in range(1,13):
		_add_month(year,month)

func _add_month(year:int,month:int):
	var month_view = month_scene.instantiate()
	month_view.year = year
	month_view.month = month
	year_container.add_child(month_view)

func _on_pre_year_btn_pressed():
	year_to_show-=1
	_set_year(year_to_show)

func _on_mext_year_btn_pressed():
	year_to_show+=1
	_set_year(year_to_show)


func _on_today_btn_pressed():
	year_to_show = GlobalVariables.get_current_date().year
	_set_year(year_to_show)


func _on_date_selected(date:Date):
	print(date)
