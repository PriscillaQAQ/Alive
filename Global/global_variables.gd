extends Node

var uuid_util=preload("res://addons/uuidv5/v5.gd")

var life:int
var mood:int
var iq:int
var user_data:String

var COLLECTION_ID="Alive"


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
