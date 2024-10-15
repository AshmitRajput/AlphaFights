extends Timer

var stats = PlayerStats



func _on_Timer_timeout():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://WORLD.tscn")
