extends KinematicBody2D

var dir = Vector2.RIGHT
var velocity = Vector2.ZERO
var gravity_m = 6

onready var ledgeCast = $LedgeCheck
onready var animSprite = $AnimatedSprite


func _ready() -> void:
	animSprite.flip_h = true
	ledgeCast.position *= -1


func _physics_process(delta: float) -> void:

	var found_wall = is_on_wall()
	var found_ledge = not ledgeCast.is_colliding()
	
	if found_wall or found_ledge:
		animSprite.flip_h = !animSprite.flip_h 
		dir *= -1
		ledgeCast.position *= -1
	if is_on_floor():
		velocity = dir * 25
		
	velocity = move_and_slide(velocity, Vector2.UP)
	apply_gravity()
	
	
	
func apply_gravity():
	velocity.y += gravity_m
	
