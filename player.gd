extends CharacterBody2D

const GRAVITY = 1200.0
const JUMP = -650.0
const SPEED = 250.0
const BOUNCINESS = 0.5
const MIN_BOUNCE = 150.0
const BOOST_TIME = 6.0
const PAD = preload("res://pad.tscn")

var fall_speed = 0.0
var spawn_pos: Vector2
var deaths := 0
var speed_time := 0.0
var jump_time := 0.0
var speed_label: Label
var jump_label: Label

@onready var sprite = $Sprite2D

func _ready():
	add_keys("left", [KEY_A, KEY_LEFT])
	add_keys("right", [KEY_D, KEY_RIGHT])
	add_keys("jump", [KEY_W, KEY_UP, KEY_SPACE])
	spawn_pos = global_position
	if Global.skin:
		sprite.texture = Global.skin
		var img = Global.skin.get_image()
		var r = img.get_used_rect()
		sprite.offset = Vector2(img.get_size()) / 2.0 - Vector2(r.get_center())
		sprite.scale = Vector2.ONE * (60.0 / r.size.x) / scale.x
	make_boost_hud()

func make_boost_hud():
	var layer = CanvasLayer.new()
	add_child(layer)
	speed_label = Label.new()
	jump_label = Label.new()
	style_label(speed_label, Vector2(20, 130), Color(0.4, 0.75, 1.0))
	style_label(jump_label, Vector2(20, 170), Color(1.0, 0.9, 0.3))
	layer.add_child(speed_label)
	layer.add_child(jump_label)

func style_label(l: Label, pos: Vector2, col: Color):
	l.position = pos
	l.add_theme_font_size_override("font_size", 28)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	l.add_theme_constant_override("outline_size", 6)

func add_keys(action, keys):
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var e = InputEventKey.new()
		e.physical_keycode = k
		InputMap.action_add_event(action, e)

func give_boost(kind):
	if kind == "speed":
		speed_time = BOOST_TIME
	else:
		jump_time = BOOST_TIME

func _physics_process(delta):
	speed_time = max(speed_time - delta, 0.0)
	jump_time = max(jump_time - delta, 0.0)
	var sm = 1.6 if speed_time > 0.0 else 1.0
	var jm = 1.3 if jump_time > 0.0 else 1.0

	velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP * jm
	velocity.x = Input.get_axis("left", "right") * SPEED * sm
	fall_speed = velocity.y
	move_and_slide()
	if is_on_floor() and fall_speed > MIN_BOUNCE:
		velocity.y = -fall_speed * BOUNCINESS
	sprite.rotation += velocity.x * delta / 28.0

	if speed_time > 0.0 and jump_time > 0.0:
		sprite.modulate = Color(0.6, 1.0, 0.6)
	elif speed_time > 0.0:
		sprite.modulate = Color(0.5, 0.75, 1.0)
	elif jump_time > 0.0:
		sprite.modulate = Color(1.0, 0.95, 0.5)
	else:
		sprite.modulate = Color.WHITE

	if speed_time > 0.0:
		speed_label.text = "SPEED BOOST  " + str(snappedf(speed_time, 0.1)) + "s"
	else:
		speed_label.text = ""
	if jump_time > 0.0:
		jump_label.text = "JUMP BOOST  " + str(snappedf(jump_time, 0.1)) + "s"
	else:
		jump_label.text = ""

func die():
	deaths += 1
	get_tree().current_scene.get_node("CanvasLayer/DeathLabel").text = "Deaths: " + str(deaths)
	speed_time = 0.0
	jump_time = 0.0
	global_position = spawn_pos
	velocity = Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		die()
