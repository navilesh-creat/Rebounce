extends Node

const MAX_LEVEL := 3

var skin: Texture2D
var music_on := true
var player := AudioStreamPlayer.new()
var unlocked := 1

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.stream = load("res://music.mp3")
	player.volume_db = -8.0
	add_child(player)
	player.finished.connect(player.play)
	player.play()

func set_music(on):
	music_on = on
	player.stream_paused = not on

func level_path(n):
	if n <= 1:
		return "res://level.tscn"
	return "res://level" + str(n) + ".tscn"

func current_level():
	var p = get_tree().current_scene.scene_file_path
	if p == "res://level.tscn":
		return 1
	return int(p.get_file().get_basename().trim_prefix("level"))
