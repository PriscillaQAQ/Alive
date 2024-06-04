extends Button

@export_enum('week_label','normal_day','today','weekends','day_in_other') var label_type:String = 'week_label'
@onready var tody_style = preload('res://addons/Calendar/calendar_label.tres')

func _ready():
	# 根据label的类型进行样式设置
	if label_type == 'week_label':
		self.add_theme_color_override('font_color',Color.html('#818181'))
		self.disabled = true
		self.focus_mode = Control.FOCUS_NONE
		self.mouse_default_cursor_shape = Control.CURSOR_ARROW
	elif label_type == 'normal_day':
		self.add_theme_color_override('font_color',Color.html('#272727'))
	elif label_type == 'weekends':
		self.add_theme_color_override('font_color',Color.html('#808080'))
	elif label_type == 'today':
		self.add_theme_color_override('font_color',Color.html('#ffffff'))
		self.add_theme_stylebox_override('normal',tody_style)
	elif label_type == 'day_in_other':
		self.add_theme_color_override('font_color',Color.html('#BDBDBD'))
		
func _on_pressed():
	Signalbus.date_selected.emit(self.get_meta('date'))
