extends KinematicBody2D

const EnemyDeathEffect = preload("res://Action RPG Resources/Effects/EnemyDeathEffect.tscn")

export var ACELLERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var SLOWING_RADIUS = 10

enum {
	IDLE,
	WANDER,
	CHASE
}

onready var Stats = $Stats
onready var PlayerDetection = $PlayerDetection
onready var PlayerFollowRange = $PlayerFollowRange
onready var sprite = $Body
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var healthBar = $TextureProgress

var state = IDLE
var velocity = Vector2.ZERO

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				update_wander()
				
			seek_player()
		
		WANDER:
			arrival_to(wanderController.target_position, delta)
			if wanderController.get_time_left() == 0:
				update_wander()
			
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_wander()
			
			seek_player()
		
		CHASE:
			var player = PlayerFollowRange.player
			if player != null:
				acellerate_towards_point(player.global_position, delta)
			else:
				wanderController.start_wander_timer(rand_range(1, 3))
				state = IDLE

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * 400 * delta 
	velocity = move_and_slide(velocity)

func arrival_to(point, delta):
	var direction = point - global_position
	sprite.flip_h = direction.x < 0
	
	var distance = direction.length()
	var desired_velocity = MAX_SPEED * direction.normalized()
	
	if distance < SLOWING_RADIUS:
		desired_velocity = MAX_SPEED * direction.normalized() * (distance / SLOWING_RADIUS)
	
	velocity = velocity.move_toward(desired_velocity, ACELLERATION * delta)

func acellerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	sprite.flip_h = direction.x < 0
	velocity = velocity.move_toward(direction * MAX_SPEED, ACELLERATION * delta)

func seek_player():
	if PlayerDetection.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	hurtbox.create_hit_effect()
	velocity = area.Knockback_vector * 100
	Stats.health -= area.damage
	healthBar.change_progress((Stats.health/Stats.max_health)*100)
	hurtbox.start_invincibility(0.4)
	
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
