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
	if body is CharacterBody2D:
		get_tree().current_scene.get_node("CanvasLayer/WinLabel").show()
		won = true
		get_tree().paused = true

func _input(event):
	if won and event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().reload_current_scene()
