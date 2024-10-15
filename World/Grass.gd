extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")


func create_grasseffect():
	var grasseffect = GrassEffect.instance()
	get_parent().add_child(grasseffect)
	grasseffect.global_position = global_position


# warning-ignore:unused_argument
func _on_Hurtbox_area_entered(area):
	create_grasseffect()
	queue_free()
