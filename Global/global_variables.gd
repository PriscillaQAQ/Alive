extends Node

var uuid_util=preload("res://addons/uuid/uuid.gd")

var life:int
var mood:int
var iq:int
var achievements:Array[Achievement]
var tasks:Array[Task]
var page_status:int

var COLLECTION_ID="Alive"



#####=========================
##### 日期相关操作
####==========================
var cal: Calendar = Calendar.new()
func get_current_date()->Date:
	return Date.today()

func time_str_2_date(timeStr:String)->Date:
	var splits = timeStr.split('/')
	return Date.new(int(splits[0]),int(splits[1]),int(splits[2]))

func format_date(date:Date)->String:
	return '%d/%02d/%02d' % [date.year,date.month,date.day]

#####=========================
##### 成就相关操作
####==========================

#####=========================
##### 云同步相关操作
####==========================
# task 对应存储位置

func save_data():
	var auth=Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection=Firebase.Firestore.collection(COLLECTION_ID)
		# data must be dictionary, objects inside change based on detailed conditions
		var data:Dictionary={
			"life": life,
			"mood": mood,
			"iq":iq,
			"achievements":achievements,
			"tasks":tasks
		}
		var task:FirestoreTask=collection.update(auth.localid,data)
		
func load_data():
	var auth=Firebase.Auth.auth
	if auth.localid:
		var collection:FirestoreCollection=Firebase.Firestore.collection(GlobalVariables.COLLECTION_ID)
		var task:FirestoreTask=collection.get_doc(auth.localid)
		var finished_task:FirestoreTask=await task.task_finished
		var document=finished_task.document
		# 由于新用户doc_fields的值为Nil(空的)
		if document && document.doc_fields:
			GlobalVariables.life=document.doc_fields.life
			GlobalVariables.mood=document.doc_fields.mood
			GlobalVariables.iq=document.doc_fields.iq
			GlobalVariables.achievements=document.doc_fields.achivements
			GlobalVariables.tasks=document.doc_fields.tasks
		else:#给默认值，后期再调整
			GlobalVariables.life=100
			GlobalVariables.mood=100
			GlobalVariables.iq=100
			GlobalVariables.achievements=[]
			GlobalVariables.tasks=[]
		
