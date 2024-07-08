extends Node

var uuid_util=preload("res://addons/uuid/uuid.gd")

var alias:String
var life:int
var mood:int
var iq:int
var money:float
var achievements:Array
var tasks:Array
var money_records:Array

#这三啥都还没做
var figure:int
var music:int

var page_status:int		#日程板块区分类别
var update_task:Task	#修改功能确定对象
var update_achievement:Achievement		#修改功能确定对象
var update_money_record:Money
var current_part:int	#反馈板块来源
var current_place:int	#用于说明和设置的返回按钮

var COLLECTION_ID="Alive"
var user_id:String
var player_path : String
var achievements_path : String
var tasks_path : String
var money_records_path:String


#####=========================
##### 偏好相关操作
####==========================
func play_music(ASP:AudioStreamPlayer):
	var m_file_name=str(GlobalVariables.music)+".mp3"
	ASP.stream=load("res://assets/音乐/"+m_file_name)
	ASP.play()
	
func set_figure(S2D:Sprite2D):
	var file_pic_name="figure"+str(GlobalVariables.figure)+'.png'
	var fig_picture=load("res://assets/图片/"+file_pic_name)
	S2D.texture=fig_picture

func set_figure_ogv(VSP:VideoStreamPlayer,action:String):
	var videoname=action+str(GlobalVariables.figure)+".ogv"
	var fig_video=load("res://assets/视频/"+videoname)
	VSP.stream=fig_video
	VSP.loop=true
	VSP.play()
	

#####=========================
##### 节点相关操作
####==========================
func clear_container(vb_container:VBoxContainer):
	var child_nodes=vb_container.get_children()
	for each_child_node in child_nodes:
		vb_container.remove_child(each_child_node)
		each_child_node.queue_free()
	pass
	
func clear_grid_container(g_container:GridContainer):
	var child_nodes=g_container.get_children()
	for each_child_node in child_nodes:
		g_container.remove_child(each_child_node)
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
		

func sort_achievements_by_date():
	achievements.sort_custom(_sort_by_date_asc)
func _sort_by_date_asc(achieve1:Achievement,achieve2:Achievement):
	if achieve1.date.is_before(achieve2.date):
		return true
	else:
		return false
	
		
#####=========================
##### 攒钱相关操作
####==========================
func sort_records_by_date_after():
	money_records.sort_custom(_sort_by_date)
func _sort_by_date(money1:Money,money2:Money):
	if money1.date.is_after(money2.date):
		return true
	else:
		return false
func save_money_records(money_records_path):
	var money_records_config:ConfigFile
	money_records_config=deal_file_exists(money_records_config,money_records_path)
	money_records_config.clear()
	for money_record in money_records:
		var money_record_dic=money_record.money_record_to_dic()
		money_records_config.set_value("money_records",money_record.id,money_record_dic)
	money_records_config.save(money_records_path)

	
func load_money_records(money_records_path):
	money_records=[]
	var money_records_config:ConfigFile
	money_records_config=deal_file_exists(money_records_config,money_records_path)
	var keys=money_records_config.get_section_keys("money_records")
	for money_record_dic_id in keys:
		var money_record_dic=money_records_config.get_value("money_records",money_record_dic_id)
		var money_record=dic_to_money_record(money_record_dic)
		money_records.append(money_record)
	pass
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
	save_money_records(money_records_path)

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
	player_config.set_value("player","alias",alias)
	player_config.set_value("player", "life", life)
	player_config.set_value("player", "mood", mood)
	player_config.set_value("player", "iq", iq)
	player_config.set_value("player","money",money)
	
	player_config.set_value("player", "music", music)
	player_config.set_value("player","figure",figure)
	player_config.save(playerData_path)
	
##### 读取文件
func load_user_data(user_id: String):
	load_player_data(player_path)
	load_achievements(achievements_path)
	load_tasks(tasks_path)
	load_money_records(money_records_path)
	
func load_player_data(playerData_path:String):
	var player_config:ConfigFile
	player_config=deal_file_exists(player_config,playerData_path)
	life = player_config.get_value("player", "life", 80)
	mood = player_config.get_value("player", "mood", 80)
	iq = player_config.get_value("player", "iq", 80)
	money = player_config.get_value("player","money",0)
	alias=player_config.get_value("player","alias","")
	
	music = player_config.get_value("player", "music", 1)
	figure = player_config.get_value("player","figure",1)
	
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
	achievement.photo={"name":achieve_dic["photo_name"],"data":achieve_dic["photo_data"]}
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
	
func dic_to_money_record(money_record_dic:Dictionary) -> Money:
	var money_record=Money.new()
	money_record.id=money_record_dic["id"]
	money_record.note=money_record_dic["note"]
	money_record.money=money_record_dic["money"]
	
	var date_list=money_record_dic["date"]
	money_record.date=Date.new(date_list[0],date_list[1],date_list[2])
	return money_record
	pass


	
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
		var money_records_dic_array=money_records_to_dic_array()
		# data must be dictionary, objects inside change based on detailed conditions
		var data:Dictionary={
			"alias":alias,
			"life": life,
			"mood": mood,
			"iq":iq,
			"money":money,
			"music":music,
			"figure":figure,
			"achievements":achievements_dic_array,
			"tasks":tasks_dic_array,
			"money_records":money_records_dic_array
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
		return_dic_array.append(local_task_dic)
	return return_dic_array
func money_records_to_dic_array():
	var return_dic_array=[]
	for each_one in money_records:
		return_dic_array.append(each_one.money_record_to_dic())
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
			print(1)
			alias=document.doc_fields.alias
			life=document.doc_fields.life
			mood=document.doc_fields.mood
			iq=document.doc_fields.iq
			money=document.doc_fields.money
			music=document.doc_fields.music
			figure=document.doc_fields.figure
			achievements=deal_cloudsave_achievements(document.doc_fields.achievements)
			tasks=deal_cloudsave_tasks(document.doc_fields.tasks)
			money_records=deal_cloudsave_money_records(document.doc_fields.money_records)
			
		else:#给默认值，后期再调整
			print(0)
			alias=''
			life=80
			mood=80
			iq=80
			money=0
			music=1
			figure=1
			achievements=[]
			tasks=[]
			money_records=[]
		print(GlobalVariables.life)
		print(GlobalVariables.mood)
		print(GlobalVariables.iq)
	
func deal_cloudsave_achievements(cloudsave_dic_array:Array):
	var return_achievements=[]
	for each_cloud_dic in cloudsave_dic_array:
		return_achievements.append(dic_to_achieve(each_cloud_dic))
	return return_achievements
func deal_cloudsave_tasks(cloudsave_dic_array:Array):
	var return_tasks=[]
	for each_cloud_dic in cloudsave_dic_array:
		var color_list=each_cloud_dic["color"]
		each_cloud_dic["color"]=Color(color_list[0],color_list[1],color_list[2],color_list[3])
		return_tasks.append(dic_to_task(each_cloud_dic))
	return return_tasks
func deal_cloudsave_money_records(cloudsave_dic_array:Array):
	var return_money_records=[]
	for each_cloud_dic in cloudsave_dic_array:
		return_money_records.append(dic_to_money_record(each_cloud_dic))
	return return_money_records
	
	pass
		
func load_localid():
	user_id=Firebase.Auth.auth.localid
	
