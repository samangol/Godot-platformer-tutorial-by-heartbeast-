extends Node2D

enum {
	HOVER,
	FALL,
	LAND,
	RISE
}

var state = HOVER

export var fallSpeed = 10
export var riseAcceleration = 10
export(float) var landTimer = 1

onready var startPos = global_position
onready var timer = $Timer
onready var raycast = $RayCast2D
onready var animSprite = $AnimatedSprite
onready var particles = $Particles2D

func _ready() -> void:
	particles.emitting = false

func _physics_process(delta: float) -> void:
	match state:
		HOVER: hover_state()
		FALL: fall_state(delta)
		LAND: land_state()
		RISE: rise_state(delta)
		
func hover_state():
	state = FALL
	
func fall_state(delta):
	animSprite.play('Falling')
	position.y += fallSpeed * delta
	if raycast.is_colliding():
		var collisionPoint = raycast.get_collision_point()
		position.y = collisionPoint.y
		state = LAND
		timer.start(landTimer)
		particles.emitting = true

func land_state():
	if timer.time_left == 0:
		particles.emitting = false
		state = RISE
	
func rise_state(delta):
	animSprite.play('Rising')	
	position.y = move_toward(position.y, startPos.y, riseAcceleration * delta)
	if position.y == startPos.y:
		state = HOVER

