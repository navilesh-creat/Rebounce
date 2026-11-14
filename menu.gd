extends Control

func _ready():
	$Button.pressed.connect(func(): get_tree().change_scene_to_file(Global.level_path(Global.unlocked)))
	$Button2.pressed.connect(func(): get_tree().change_scene_to_file("res://characters.tscn"))
