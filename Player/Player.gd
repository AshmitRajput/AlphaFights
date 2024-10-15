extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var acceleration = 500
export var maxspeed = 80
export var friction = 500 
export var ROLL_SPEED = 115

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var SwordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkanimationplayer = $BlinkAnimationPlayer
onready var animationstate = animationtree.get("parameters/playback")

enum{
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationtree.active = true
	SwordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	
	


func move_state(delta):
	var inputvector = Vector2.ZERO
	inputvector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputvector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputvector = inputvector.normalized()
	
	if inputvector != Vector2.ZERO:
		SwordHitbox.knockback_vector = inputvector
		roll_vector = inputvector
		animationtree.set("parameters/Idle/blend_position",inputvector)
		animationtree.set("parameters/Run/blend_position",inputvector)
		animationtree.set("parameters/Attack/blend_position",inputvector)
		animationtree.set("parameters/Roll/blend_position",inputvector)
		animationstate.travel("Run")
		velocity = velocity.move_toward(maxspeed * inputvector, acceleration * delta)
	else:
		animationstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,friction * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationstate.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationstate.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func rolling_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(1)
	hurtbox.show_hit_effect()
	var playerhurtsound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerhurtsound)

func _on_Hurtbox_invincibility_started():
	blinkanimationplayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkanimationplayer.play("Stop")


