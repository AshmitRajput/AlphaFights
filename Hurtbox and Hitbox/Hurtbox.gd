extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincibility = false setget set_invincibility

onready var timer = $Timer
onready var collisionshape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func show_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func set_invincibility(value):
	invincibility = value
	if invincibility == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincibility = true
	timer.start(duration)
	emit_signal("invincibility_started")



func _on_Timer_timeout():
	self.invincibility = false
	emit_signal("invincibility_ended")

func _on_Hurtbox_invincibility_started():
	collisionshape.set_deferred("disabled", true)

func _on_Hurtbox_invincibility_ended():
	collisionshape.disabled = false
