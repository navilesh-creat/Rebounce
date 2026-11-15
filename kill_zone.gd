extends Area2D

func _ready():
	body_entered.connect(func(body):
		if body is CharacterBody2D:
			body.die())
