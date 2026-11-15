extends Control

const SIZE := 200.0
const GAP := 16.0
const COLS := 5

func _ready():
	var vs = get_viewport_rect().size
	var pics = []
	for c in get_children():
		if c is TextureRect:
			pics.append(c)
		elif c is TextureButton:
			c.hide()

	var bg = TextureRect.new()
	bg.texture = load("res://hero-bg.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.size = vs
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	move_child(bg, 0)

	var title = Label.new()
	title.text = "SELECT CHARACTER"
	title.add_theme_font_size_override("font_size", 40)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.size = Vector2(vs.x, 60)
	title.position = Vector2(0, 30)
	add_child(title)

	var back = Button.new()
	back.text = "Back"
	back.position = Vector2(20, 20)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://menu.tscn"))
	add_child(back)

	var n = pics.size()
	var rows = ceili(float(n) / COLS)
	var grid_h = rows * SIZE + (rows - 1) * GAP
	var start_y = 110.0 + (vs.y - 110.0 - grid_h) / 2.0

	for i in n:
		var pic = pics[i]
		var orig = pic.texture

		var img = orig.get_image()
		var at = AtlasTexture.new()
		at.atlas = orig
		at.region = Rect2(img.get_used_rect())
		pic.texture = at

		var row = i / COLS
		var col = i % COLS
		var in_row = min(COLS, n - row * COLS)
		var row_w = in_row * SIZE + (in_row - 1) * GAP
		var start_x = (vs.x - row_w) / 2.0

		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pic.size = Vector2(SIZE, SIZE)
		pic.position = Vector2(start_x + col * (SIZE + GAP), start_y + row * (SIZE + GAP))
		pic.pivot_offset = Vector2(SIZE, SIZE) / 2.0
		pic.mouse_filter = Control.MOUSE_FILTER_STOP
		pic.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		pic.mouse_entered.connect(func(): pic.scale = Vector2(1.1, 1.1))
		pic.mouse_exited.connect(func(): pic.scale = Vector2.ONE)
		pic.gui_input.connect(func(e):
			if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
				Global.skin = orig
				get_tree().change_scene_to_file("res://menu.tscn"))
