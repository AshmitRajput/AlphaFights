extends Node

export var max_health = 1 setget set_max_health
var health = max_health setget set_health
onready var timer = $Timer

signal no_health 
signal health_changed
signal max_health_changed

func _ready():
	self.health = max_health

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		timer.start(2)

func _on_Timer_timeout():
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	self.health = max_health
