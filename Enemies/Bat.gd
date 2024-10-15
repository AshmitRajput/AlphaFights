extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_RANGE = 3

enum{
	IDLE
	CHASE
	WANDER
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var sprite = $Sprite
onready var stats = $Stats
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softcollisions = $SoftCollisions
onready var wandercontroller = $WanderController
onready var animationplayer = $AnimationPlayer


func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wandercontroller.get_time_left() == 0:
				update_wander()
		
		WANDER:
			seek_player()
			if wandercontroller.get_time_left() == 0:
				update_wander()
			accelerate_towards(wandercontroller.target_position, delta)
			
			if global_position.distance_to(wandercontroller.target_position) <= WANDER_RANGE:
				update_wander()
		
		CHASE:
			var player = PlayerDetectionZone.player
			if player != null:
				accelerate_towards(player.global_position, delta)
			else:
				state = IDLE
			

	if softcollisions.is_colliding():
		velocity += softcollisions.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func seek_player():
	if PlayerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wandercontroller.start_wander_timer(rand_range(1, 3))

func accelerate_towards(position, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0



func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.show_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	animationplayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animationplayer.play("Stop")
