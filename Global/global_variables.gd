extends Node

var uuid_util=preload("res://addons/uuid/uuid.gd")

var life:int
var mood:int
var iq:int
var money:float
var achievements:Array
var tasks:Array
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
	var start_date1=time_str_2_date(task1.start_time[0])
	var start_date2=time_str_2_date(task2.start_time[0])
	if start_date1.is_before(start_date2):
		return true
	elif start_date1.is_after(start_date2):
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
		
func save_tasks(tasks_path):
	var tasks_config:ConfigFile
	tasks_config=deal_file_exists(tasks_config,tasks_path)
	tasks_config.clear()
	for task in tasks:
		var task_dic=task.task_to_dic()
		tasks_config.set_value("tasks",task.id,task_dic)
	tasks_config.save(tasks_path)
	
func load_tasks(tasks_path):
	tasks=[]
	var tasks_config: ConfigFile
	tasks_config=deal_file_exists(tasks_config,tasks_path)
	var keys=tasks_config.get_section_keys("tasks")
	for task_dic_id in keys:
		var task_dic=tasks_config.get_value("tasks",task_dic_id)
		var task=dic_to_task(task_dic)
		tasks.append(task)
	pass

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
	achievements_config.save(achievements_path)

	
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
	save_tasks(tasks_path)

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
	player_config.set_value("player","money",money)
	player_config.save(playerData_path)
	
##### 读取文件
func load_user_data(user_id: String):
	load_player_data(player_path)
	load_achievements(achievements_path)
	load_tasks(tasks_path)
	
func load_player_data(playerData_path:String):
	var player_config:ConfigFile
	player_config=deal_file_exists(player_config,playerData_path)
	life = player_config.get_value("player", "life", 80)
	mood = player_config.get_value("player", "mood", 80)
	iq = player_config.get_value("player", "iq", 80)
	money = player_config.get_value("player","money",0)
	
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
	achievement.id=achieve_dic["id"]
	achievement.classification=achieve_dic["classification"]
	achievement.note=achieve_dic["note"]
	# deal Date
	var date_list=achieve_dic["date"]
	achievement.date=Date.new(date_list[0],date_list[1],date_list[2])
	return achievement
	
func dic_to_task(task_dic:Dictionary) -> Task:
	var task=Task.new()
	task.name=task_dic["name"]
	task.id=task_dic["id"]
	task.classification=task_dic["classification"]
	task.description=task_dic["description"]
	task.color=task_dic["color"]
	# deal Date and time
	var date_list=task_dic["ddl"]
	task.ddl=Date.new(date_list[0],date_list[1],date_list[2])
	task.start_time=task_dic["start_time"]
	task.end_time=task_dic["end_time"]
	return task
	

	
#####=========================
##### 云同步相关操作
####==========================
# task 对应存储位置
func save_data_cloud():
	var auth=Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection=Firebase.Firestore.collection(COLLECTION_ID)
		var achievements_dic_array=achievements_to_dic_array()
		var tasks_dic_array=tasks_to_dic_array()
		print(tasks_dic_array)
		# data must be dictionary, objects inside change based on detailed conditions
		var data:Dictionary={
			"life": life,
			"mood": mood,
			"iq":iq,
			"money":money,
			"achievements":achievements_dic_array,
			"tasks":tasks_dic_array
		}
		var task:FirestoreTask=collection.update(auth.localid,data)
		
func achievements_to_dic_array():
	var return_dic_array=[]
	for each_one in achievements:
		return_dic_array.append(each_one.achieve_to_dic())
	return return_dic_array
func tasks_to_dic_array():
	var return_dic_array=[]
	for each_one in tasks:
		var local_task_dic=each_one.task_to_dic()
		var task_color=local_task_dic["color"]
		local_task_dic["color"]=[task_color.r,task_color.b,task_color.g,task_color.a]
		
		#var start_date_array=local_task_dic["start_time"][0]
		#var start_date_date=Date.new(start_date_array[0],start_date_array[1],start_date_array[2])
		#var start_date_str=format_date(start_date_date)
		#start_date_array[0]=start_date_str
		#local_task_dic["start_time"]=start_date_array
		#
		#var end_date_array=local_task_dic["end_time"][0]
		#var end_date_date=Date.new(end_date_array[0],end_date_array[1],end_date_array[2])
		#var end_date_str=format_date(end_date_date)
		#end_date_array[0]=end_date_str
		#local_task_dic["end_time"]=end_date_array
		
		return_dic_array.append(local_task_dic)
	return return_dic_array
		
func load_data_cloud():
	var auth=Firebase.Auth.auth
	if auth.localid:
		var collection:FirestoreCollection=Firebase.Firestore.collection(GlobalVariables.COLLECTION_ID)
		var task:FirestoreTask=collection.get_doc(auth.localid)
		var finished_task:FirestoreTask=await task.task_finished
		var document=finished_task.document
		# 由于新用户doc_fields的值为Nil(空的)
		if document && document.doc_fields:
			life=document.doc_fields.life
			mood=document.doc_fields.mood
			iq=document.doc_fields.iq
			money=document.doc_fields.money
			achievements=deal_cloudsave_achievements(document.doc_fields.achievements)
			tasks=deal_cloudsave_tasks(document.doc_fields.tasks)
		else:#给默认值，后期再调整
			life=80
			mood=80
			iq=80
			money=0
			achievements=[]
			tasks=[]
	
func deal_cloudsave_achievements(cloudsave_dic_array:Array):
	var return_achievements=[]
	for each_cloud_dic in cloudsave_dic_array:
		return_achievements.append(dic_to_achieve(each_cloud_dic))
	print(return_achievements)
	return return_achievements
func deal_cloudsave_tasks(cloudsave_dic_array:Array):
	var return_tasks=[]
	for each_cloud_dic in cloudsave_dic_array:
		var color_list=each_cloud_dic["color"]
		each_cloud_dic["color"]=Color(color_list[0],color_list[1],color_list[2],color_list[3])
		return_tasks.append(dic_to_task(each_cloud_dic))
	return return_tasks
		
func load_localid():
	user_id=Firebase.Auth.auth.localid
	
