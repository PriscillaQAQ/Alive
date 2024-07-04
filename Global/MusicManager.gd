extends Node

var music_player : AudioStreamPlayer

# 单例的初始化
func _init():
  music_player = AudioStreamPlayer.new()
  add_child(music_player)

# 设置音乐流
func set_music():
  var m_file_name=str(GlobalVariables.music)+".mp3"
  var stream=load("res://assets/音乐/"+m_file_name)
  music_player.stream = stream
  music_player.stream.loop=true
  music_player.play()

# 停止音乐
func stop_music():
  music_player.stop()

# 暂停音乐
func pause_music():
  music_player.stream_paused=true

# 恢复播放
func resume_music():
  music_player.stream_paused=false
