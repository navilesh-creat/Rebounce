extends Area2D

var won := false
var time := 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	if not won:
		time += delta
		get_tree().current_scene.get_node("CanvasLayer/TimeLabel").text = str(snappedf(time, 0.1))

func _on_body_entered(body):
	if body is CharacterBody2D and not won:
		var n = Global.current_level()
		var label = get_tree().current_scene.get_node("CanvasLayer/WinLabel")
		if n < Global.MAX_LEVEL:
			Global.unlocked = max(Global.unlocked, n + 1)
			label.text = "LEVEL " + str(n) + " COMPLETE! Press Enter"
		else:
			label.text = "YOU WIN! Press Enter"
		label.show()
		won = true
		get_tree().paused = true

func _input(event):
	if won and event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		var n = Global.current_level()
		if n < Global.MAX_LEVEL:
			get_tree().change_scene_to_file(Global.level_path(n + 1))
		else:
			get_tree().change_scene_to_file("res://menu.tscn")
