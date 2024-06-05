extends Control

var today = GlobalVariables.get_current_date()
@export var current_year:int = today.year 
@export var current_month:int = today.month


@onready var month_calendar = %month_calendar
@onready var year_label = %year_label
@onready var month_label = %month_label

var month_names = ['一','二','三','四','五','六','七','八','九','十','十一','十二']
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.cal.set_first_weekday(Time.WEEKDAY_SUNDAY)
	month_calendar.year = current_year
	month_calendar.month = current_month
	month_label.text= str(month_names[current_month-1])+'月'
	year_label.text=str(current_year)
	_update_year_label()

func _update_calendar():
	month_calendar._set_month_days(current_year,current_month)

func _on_pre_year_btn_pressed():
	current_year -=1
	_update_year_label()
	

func _on_next_year_btn_pressed():
	current_year +=1
	_update_year_label()
	

func _update_year_label():
	year_label.text = str(current_year)
	_update_calendar()

func _update_month_label():
	month_label.text = str(month_names[current_month-1])+'月'
	_update_calendar()


func _on_pre_month_btn_pressed():
	current_month -= 1
	if current_month <=1:
		current_month = 1
	_update_month_label()


func _on_next_month_btn_pressed():
	current_month += 1
	if current_month >12:
		current_month = 12
	_update_month_label()
