extends Area2D

onready var animation = $AnimationPlayer
signal coin_collected

# warning-ignore:unused_argument
func _on_Coin_body_entered(body):
	animation.play("Bounce")
	emit_signal("coin_collected")
	set_collision_mask_bit(0,false)

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

