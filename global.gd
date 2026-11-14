extends Node

var skin: Texture2D
var music_on := true
var player := AudioStreamPlayer.new()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.stream = load("res://music.mp4")
	player.volume_db = -8.0
	add_child(player)
	player.finished.connect(player.play)
	player.play()

func set_music(on):
	music_on = on
	player.stream_paused = not on
