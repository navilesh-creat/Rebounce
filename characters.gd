extends Control

func _ready():
	for b in get_children():
		if b is TextureRect:
			b.mouse_filter = Control.MOUSE_FILTER_STOP
			b.gui_input.connect(func(e):
				if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
					Global.skin = b.texture
					get_tree().change_scene_to_file("res://menu.tscn"))
