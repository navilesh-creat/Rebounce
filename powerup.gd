@tool
extends Area2D

@export_enum("speed", "jump") var kind: String = "speed"

var t := 0.0

func _ready():
	if Engine.is_editor_hint():
		return
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 24.0
	shape.shape = circle
	add_child(shape)
	body_entered.connect(_on_body_entered)

func _color() -> Color:
	if kind == "speed":
		return Color(0.1, 0.6, 1.0)
	return Color(1.0, 0.8, 0.1)

func _process(delta):
	t += delta
	queue_redraw()

func _draw():
	var c = _color()
	var bob = Vector2(0, sin(t * 2.5) * 5.0)
	var pulse = 1.0 + sin(t * 4.0) * 0.1
	for i in range(7, -1, -1):
		draw_circle(bob, (12.0 + i * 4.0) * pulse, Color(c.r, c.g, c.b, 0.07))
	draw_circle(bob, 13.0, c)
	draw_arc(bob, 13.0, 0.0, TAU, 32, Color(1, 1, 1, 0.9), 2.0)
	draw_circle(bob + Vector2(-4, -4), 4.0, Color(1, 1, 1, 0.85))
	for k in range(3):
		var ang = t * 2.0 + k * TAU / 3.0
		draw_circle(bob + Vector2(cos(ang), sin(ang)) * 24.0 * pulse, 2.5, Color(1, 1, 1, 0.9))

func _on_body_entered(body):
	if body is CharacterBody2D and body.has_method("give_boost"):
		body.give_boost(kind)
		hide()
		set_deferred("monitoring", false)
		await get_tree().create_timer(8.0).timeout
		show()
		monitoring = true
