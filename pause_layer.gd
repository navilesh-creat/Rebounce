extends CanvasLayer

func _ready():
	visible = false
	$ResumeBtn.pressed.connect(toggle)
	$MusicBtn.pressed.connect(_on_music)
	$MenuBtn.pressed.connect(_on_menu)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().current_scene.get_node("CanvasLayer/WinLabel").visible:
			return
		toggle()

func toggle():
	visible = not visible
	get_tree().paused = visible

func _on_music():
	Global.set_music(not Global.music_on)
	$MusicBtn.text = "Music: On" if Global.music_on else "Music: Off"

func _on_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
