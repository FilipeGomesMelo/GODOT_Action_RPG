extends KinematicBody2D

const PLAYER_HURT_SOUND = preload("res://Action RPG Resources/Player/PlayerHurtSound.tscn")

export var MAX_SPEED = 100
export var ACELL = 750
export var FRICTION = 750
export var ROLL_SPEED = 120
export var ROLL_COOLDOWN = 0.5
export var ATACK_COOLDOWN = 0.25

enum {
	MOVE,
	ROLL,
	ATACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var SwordHitbox = $HitboxPivot/Sword_Hitbox
onready var hurtbox = $Hurtbox
onready var animationState = animationTree.get("parameters/playback")
onready var blinckAnimationPlayer = $BlinkAnimationPlayer
onready var rollTimer = $RollTimer
onready var atackTimer = $AtackTimer

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	SwordHitbox.Knockback_vector = roll_vector
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta) 
		
		ROLL:
			roll_state(delta)
		
		ATACK:
			atack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		SwordHitbox.Knockback_vector = roll_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Atack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACELL * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	if Input.is_action_just_pressed("Atack") and atackTimer.time_left == 0:
		state = ATACK
	if Input.is_action_just_pressed("Roll") and rollTimer.time_left == 0:
		state = ROLL

func roll_state(_delta):
	animationState.travel("Roll")
	velocity = roll_vector * ROLL_SPEED
	velocity = move_and_slide(velocity)

func atack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Atack")

func roll_animation_finished():
	rollTimer.start(ROLL_COOLDOWN)
	velocity = velocity * 0.5
	state = MOVE

func atack_animation_finished():
	atackTimer.start(ATACK_COOLDOWN)
	state = MOVE

func _on_Hurtbox_area_entered(area):
	if !hurtbox.invincible:
		stats.health -= area.damage
		hurtbox.start_invincibility(0.75)
		hurtbox.create_hit_effect()
		var player_hurt_sound = PLAYER_HURT_SOUND.instance()
		get_tree().current_scene.add_child(player_hurt_sound)

func start_roll_invincibility():
	hurtbox.start_invincibility(0.3)

func _on_Hurtbox_invincibility_started():
	blinckAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinckAnimationPlayer.play("Stop")
