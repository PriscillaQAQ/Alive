extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	pass # Replace with function body.


func _on_娱乐按钮_pressed():
	
	#get_tree().change_scene_to_file()
	pass # Replace with function body.


func _on_学习按钮_pressed():
	pass # Replace with function body.


func _on_攒钱_pressed():
	pass # Replace with function body.


func _on_成就_pressed():
	pass # Replace with function body.
	
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
			GlobalVariables.iq=document.doc_fields.IQ
		else:#给默认值，后期再调整
			GlobalVariables.life=100
			GlobalVariables.mood=100
			GlobalVariables.iq=100
			
		
		
