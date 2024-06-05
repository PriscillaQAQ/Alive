extends Resource


class_name Date

## The year of this date.
var year: int

## The month of this date. An integer value from 1 to 12 representing January to December.
var month: int

## The day of this date. An integer value from 1 to 31.
var day: int


@warning_ignore("shadowed_variable")
func _init(year: int, month: int, day: int) -> void:
	set_date(year, month, day)


## Returns [code]true[/code] or [code]false[/code]
## if the date is a valid date or not.
func is_valid() -> bool:
	if month < 1 or month > 12:
		return false
	elif day < 1 or day > _get_days_in_month():
		return false
	
	if month == 2 and day == 29 and not is_leap_year():
		return false
	
	return true


func _validate():
	var valid: bool = true
	var error_msg = "Date is not valid (%s, %s, %s): " % [year, month, day]
	if month < 1 or month > 12:
		error_msg += "Month has to be 1 - 12. "
		valid = false
	elif day < 1:
		error_msg += "Days can not be less than 1. "
		valid = false
	elif day > _get_days_in_month():
		error_msg += "Too many days in month. "
		valid = false
	if month == 2 and day == 29 and not is_leap_year():
		error_msg += "Day can not be 29 in a non-leap year February. "
		valid = false
	
	if not valid:
		push_error(error_msg)
		return false
	
	return true


## Returns [code]true[/code] or [code]false[/code] depending on whether
## the date is a leap year or not.
func is_leap_year() -> bool:
	return (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0))


## Returns [code]true[/code] if this Date is before the provided date.
func is_before(date: Date) -> bool:
	if year < date.year:
		return true
	elif year == date.year:
		if month < date.month:
			return true
		elif month == date.month:
			return day < date.day
	return false


## Returns [code]true[/code] if this Date is after the provided date.
func is_after(date: Date) -> bool:
	if year > date.year:
		return true
	elif year == date.year:
		if month > date.month:
			return true
		elif month == date.month:
			return day > date.day
	return false


## Returns [code]true[/code] if this Date is the same as the provided date.
func is_equal(date: Date) -> bool:
	if year == date.year and month == date.month and day == date.day:
		return true
	return false


# Returns the number of days in the month. If the year
# is a leap year February will return 29 days.
func _get_days_in_month() -> int:
	var days_in_month: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if month == 2 and is_leap_year():
		return 29
	return days_in_month[month - 1]


## Returns the weekday of a given date as a [code]Time.Weekday[/code] 
## value where Sunday = 0 and Saturday = 6.
@warning_ignore("integer_division")
func get_weekday() -> Time.Weekday:
	# Zeller's Congruence algorithm to find the day of the week
	if month < 3:
		month += 12
		year -= 1
	var k: int = year % 100
	var j: int = int(year / 100)
	var f = day + (13 * (month + 1) / 5) + k + (k / 4) + (j / 4) - 2 * j
	# Adjusted Zeller's Congruence for Godot's Sunday = 0
	return (f + 6) % 7 as Time.Weekday


## Similar to [method get_weekday] but returns an integer value 
## where Monday = 1 and Sunday = 7, according to the ISO8601 standard.
func get_weekday_iso() -> int:
	var weekday: Time.Weekday = get_weekday()
	return weekday if weekday != 0 else 7


## Add any number of days to this date.
func add_days(days: int) -> void:
	day += days
	while day > _get_days_in_month():
		day -= _get_days_in_month()
		month += 1
		if month > 12:
			month = 1
			year += 1


## Adds a specified number of months to the date. 
## [br][br]
## If the resulting date's day does not correspond to the number of days in the new month, 
## it will be adjusted to the nearest valid day. For example, if the day 
## is 31 and the new month is June, the day will be set to 30. Additionally, 
## February 29 will be adjusted to February 28 in non-leap years.
func add_months(months: int) -> void:
	month += months
	while month > 12:
		month -= 12
		year += 1
	var days_in_new_month: int = _get_days_in_month()
	if day > days_in_new_month:
		day = days_in_new_month


## Adds any number of years to the date. February 29 will be set 
## to February 28 if the new year is not a leap year.
func add_years(years: int) -> void:
	year += years
	if month == 2 and day == 29 and not is_leap_year():
		day = 28


## Subtract any number of days from this date.
func subtract_days(days: int) -> void:
	day -= days
	while day < 1:
		month -= 1
		if month < 1:
			month = 12
			year -= 1
		day += _get_days_in_month()


## Subtracts a specified number of months from the date. 
## [br][br]
## If the resulting date's day does not correspond to the number of days in the new month, 
## it will be adjusted to the nearest valid day. For example, if the day 
## is 31 and the new month is June, the day will be set to 30. Additionally, 
## February 29 will be adjusted to February 28 in non-leap years.
func subtract_months(months: int) -> void:
	month -= months
	while month < 1:
		month += 12
		year -= 1
	var days_in_new_month: int = _get_days_in_month()
	if day > days_in_new_month:
		day = days_in_new_month


## Subtracts any number of years from the date. February 29 will be set 
## to February 28 if the new year is not a leap year.
func subtract_years(years: int) -> void:
	year -= years
	if month == 2 and day == 29 and not is_leap_year():
		day = 28
	

## Set the year, month and day of this Date. Throws an error if the 
## date is not a valid date.
@warning_ignore("shadowed_variable")
func set_date(year: int, month: int, day: int):
	self.year = year
	self.month = month
	self.day = day
	_validate()


## Set this Date to today's date
func set_today():
	var today_date: Dictionary = Time.get_date_dict_from_system()
	self.set_date(today_date.year, today_date.month, today_date.day)


## Returns the ordinal day for the given [param year], [param month] and [param day].
func get_day_of_year() -> int:
	var days_in_month: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	
	if is_leap_year():
		days_in_month[1] = 29
	
	var day_number: int = day
	for i in range(month - 1):
		day_number += days_in_month[i]
	
	return day_number


## Set this Date to the given dictionary's date. The
## dictionary must contain a [code]year[/code], [code]month[/code]
## and [code]day[/code] key. 
## [br][br]
## This function's main purpose is to convert dates returned from 
## the built in [Time] singleton, which mainly return dictionaries.
func from_dict(date: Dictionary):
	self.set_date(date.year, date.month, date.day)


## Returns a new Date object which is a copy of this Date.
#func duplicate() -> Date:
	#return Date.new(year, month, day)


# Helper function to calculate how many days are between two Date objects
@warning_ignore("integer_division")
func _to_julian_day() -> int:
	# Algorithm to convert a Gregorian date to a Julian Day Number.
	# This is a simplified version and works for dates after 1582.
	var a: int = (14 - month) / 12
	var y: int = year + 4800 - a
	var m: int = month + 12 * a - 3
	var jdn: int = day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045
	return jdn


## Return the number of days between two Date objects. Is only accurate
## when dates are after the year 1582.
func days_to(date: Date) -> int:
	return self._to_julian_day() - date._to_julian_day()


## A static function that returns a Date object with todays date.
## The date is fetched from the system.
## [codeblock]
## var todays_date = Calendar.Date.today()
## print(todays_date) # Outputs the current date from the system
## [/codeblock]
static func today() -> Date:
	var date: Date = Date.new(1, 1, 1)
	var today_date: Dictionary = Time.get_date_dict_from_system()
	date.set_date(today_date.year, today_date.month, today_date.day)
	return date

# Present the date as "Year-Month-Day" when printed (i.e., 2023-12-01).
# This is a build in function froom Godot that changed how a class
# behaves when printed.
func _to_string() -> String:
	return "%s-%s-%s" % [year, month, day]

