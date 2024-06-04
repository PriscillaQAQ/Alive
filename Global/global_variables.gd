extends Node

var uuid_util=preload("res://addons/uuidv5/v5.gd")

var life:int
var mood:int
var iq:int
var user_data:String

var COLLECTION_ID="Alive"

#####=========================
##### 日期相关操作
####==========================
var cal: Calendar = Calendar.new()
func get_current_date()->Calendar.Date:
	return Calendar.Date.today()

func time_str_2_date(timeStr:String)->Calendar.Date:
	var splits = timeStr.split('/')
	return Calendar.Date.new(int(splits[0]),int(splits[1]),int(splits[2]))

func format_date(date:Calendar.Date)->String:
	return '%d/%02d/%02d' % [date.year,date.month,date.day]


# task 对应存储位置

func save_data():
	var auth=Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection=Firebase.Firestore.collection(COLLECTION_ID)
		# data must be dictionary, objects inside change based on detailed conditions
		var data:Dictionary={
			"life": life,
			"mood": mood,
			"IQ":iq,
			"User_data":user_data
		}
		var task:FirestoreTask=collection.update(auth.localid,data)
		
