extends CharacterBody2D

const GRAVITY = 1200.0
const JUMP = -650.0
const SPEED = 250.0
const BOUNCINESS = 0.5
const MIN_BOUNCE = 150.0
const PAD = preload("res://pad.tscn")

var fall_speed = 0.0
var spawn_pos: Vector2
var deaths := 0

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

func add_keys(action, keys):
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var e = InputEventKey.new()
		e.physical_keycode = k
		InputMap.action_add_event(action, e)

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
	velocity.x = Input.get_axis("left", "right") * SPEED
	fall_speed = velocity.y
	move_and_slide()
	if is_on_floor() and fall_speed > MIN_BOUNCE:
		velocity.y = -fall_speed * BOUNCINESS
	sprite.rotation += velocity.x * delta / 28.0

func die():
	deaths += 1
	get_tree().current_scene.get_node("CanvasLayer/DeathLabel").text = "Deaths: " + str(deaths)
	global_position = spawn_pos
	velocity = Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		die()
