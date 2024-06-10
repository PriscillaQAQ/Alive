extends Node

var uuid_util=preload("res://addons/uuid/uuid.gd")

var life:int
var mood:int
var iq:int
var achievements:Array[Achievement]
var tasks:Array[Task]
var page_status:int

var COLLECTION_ID="Alive"
var user_id:String

var player_path : String
var achievements_path : String
var tasks_path : String

#####=========================
##### 节点相关操作
####==========================
func clear_container(vb_container:VBoxContainer):
	var child_nodes=vb_container.get_children()
	for each_child_node in child_nodes:
		vb_container.remove_child(each_child_node)
		each_child_node.queue_free()
	pass

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
##### 日程相关操作
####==========================
func sort_tasks_by_date():
	tasks.sort_custom(_sort_by_start_time)

func sort_tasks_by_ddl():
	tasks.sort_custom(_sort_by_ddl)
	
func _sort_by_start_time(task1:Task,task2:Task):
	if task1.start_time[0].is_before(task2.start_time[0]):
		return true
	elif task1.start_time[0].is_after(task2.start_time[0]):
		return false
	else:
		if int(task1.start_time[1]) < int(task2.start_time[1]):
			return true
		elif int(task1.start_time[1]) > int(task2.start_time[1]):
			return false
		else:
			if int(task1.start_time[2])<int(task2.start_time[2]):
				return true
			else:
				return false
	pass

func _sort_by_ddl(task1:Task,task2:Task):
	if task1.ddl.is_before(task2.ddl):
		return true
	else:
		return false

#####=========================
##### 成就相关操作
####==========================
func save_achievements(achievements_path):
	var achievements_config:ConfigFile
	achievements_config=deal_file_exists(achievements_config,achievements_path)
	achievements_config.clear()
	for achievement in achievements:
		var achieve_dict=achievement.achieve_to_dic()
		# achievement_id作为键，achievements（dic版本）数据作为data
		achievements_config.set_value("achievements",achievement.id,achieve_dict)
	print(achievements_config.get_section_keys("achievements"))
	print("yes")
	achievements_config.save(achievements_path)
	check_save()

func check_save():
	var achieve_config=ConfigFile.new()
	achieve_config.load(achievements_path)
	print(achieve_config.get_section_keys("achievements"))
	print("no")
	
func load_achievements(achievements_path):
	achievements=[]
	var achievements_config:ConfigFile
	achievements_config=deal_file_exists(achievements_config,achievements_path)
	var keys=achievements_config.get_section_keys("achievements")
	for achieve_dic_id in keys:
		var achieve_dic=achievements_config.get_value("achievements",achieve_dic_id)
		var achievement=dic_to_achieve(achieve_dic)
		achievements.append(achievement)
		
	
		
	
	



#####=========================
##### 本地数据文件相关操作
####==========================

##### 保存文件
# 得到用户文件的存储路径
func get_user_data_path(file_name: String) -> String:
	return "user://%s" % file_name

# 存储用户的所有数据
func save_user_data():

	save_player_data(player_path)
	save_achievements(achievements_path)
	# save_tasks(tasks_path)

# 检查文件是否存在
func file_exists(path: String) -> bool:
	var file = FileAccess.open(path, FileAccess.READ)
	var exists = (file != null)
	if exists:
		file.close()
	return exists
	
func deal_file_exists(config:ConfigFile,path:String):
	if ! file_exists(path):
		config = ConfigFile.new()
	else:
		config = ConfigFile.new()
		config.load(path)
	return config
	
func save_player_data(playerData_path: String):
	var player_config:ConfigFile
	player_config=deal_file_exists(player_config,playerData_path)
	player_config.clear()
	player_config.set_value("player", "life", life)
	player_config.set_value("player", "mood", mood)
	player_config.set_value("player", "iq", iq)
	player_config.save(playerData_path)
	
##### 读取文件
func load_user_data(user_id: String):
	load_player_data(player_path)
	load_achievements(achievements_path)
	# load_tasks(tasks_path)
	
func load_player_data(playerData_path:String):
	var player_config:ConfigFile
	player_config=deal_file_exists(player_config,playerData_path)
	life = player_config.get_value("player", "life", 80)
	mood = player_config.get_value("player", "mood", 80)
	iq = player_config.get_value("player", "iq", 80)
	
# 切换用户账号时，删除前者的数据
func clear_user_data(user_id: String):
	var dir_path = "user://data/%s" % user_id
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.remove(dir_path)
		print("用户文件夹 %s 已删除。" % dir_path)
	else:
		print("用户文件夹 %s 不存在。" % dir_path)
		
func dic_to_achieve(achieve_dic:Dictionary) -> Achievement:
	var achievement=Achievement.new()
	achievement.name=achieve_dic["name"]
	var date_list=achieve_dic["date"]
	achievement.date=Date.new(date_list[0],date_list[1],date_list[2])
	achievement.id=achieve_dic["id"]
	achievement.classification=achieve_dic["classification"]
	achievement.note=achieve_dic["note"]
	return achievement

	
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
			GlobalVariables.life=80
			GlobalVariables.mood=80
			GlobalVariables.iq=80
			GlobalVariables.achievements=[]
			GlobalVariables.tasks=[]
		
func load_localid():
	user_id=Firebase.Auth.auth.localid
	
