extends KinematicBody2D
class_name Player

#with this line we can use custom resources and autocomplete methods
export(Resource) var moveData = preload('res://Player/MovementData/FastPlayerMovementData.tres') as PlayerMovementData

var velocity = Vector2.ZERO
var doubleJump = 1
var bufferedJump = false
var cayoteJump = false

onready var animSprite: = $AnimatedSprite
onready var ladderCheck: = $LadderCheck
onready var fast_fell = false
onready var jumpBufferTimer = $JumpBufferTimer
onready var cayoteJumpTimer = $CayoteJumpTimer
onready var remoteTransform = $RemoteTransform2D
onready var runTrail = $RunTrailParticles
onready var die_particle: Particles2D = $DieParticle

#this is state machines first two components
enum {
	MOVE,
	CLIMB
}

var state = MOVE


func _ready() -> void:
	runTrail.emitting = false
	doubleJump = moveData.doubleJump
	pass

func _physics_process(delta: float) -> void:
	restart_scene()
	#match is used to transition between states
	match state:
		MOVE:
			moveState(get_input_move(), delta)
		CLIMB:
			climbState(get_input_move(), delta)
			

func get_input_move():
	var input = Vector2.ZERO
	input.x = Input.get_axis('moveleft','moveright')
	input.y = Input.get_axis('moveup','movedown')
	return input
	
func moveState(input, delta):
	#this is where we check if raycast found ladder to climb
	if is_on_ladder() and Input.is_action_pressed('moveup'):
		state = CLIMB
		
	apply_gravity(delta)
	
	#fliping animation based on direction
	if input.x < 0:
		animSprite.flip_h = false
	elif input.x > 0:
		animSprite.flip_h = true
		
	# BASE MOVEMENT CODE
	if input.x == 0:
		runTrail.emitting = false
		apply_friction(delta)
		animSprite.play('Idle')
	else:
		runTrail.emitting = true
		apply_acceleration(input.x,delta)
		animSprite.play('Run')
		
	# BASE JUMP FUNC
	jump(delta)
	
	# THIS IS TO HAVE A BOOLEAN TO PASS ON TO JUST LEFT GROUND
	var was_on_floor = is_on_floor()
	
	# ITS IMPORTANT TO MOVE CODES THAT NEED MODED VELOCITY TO AFTER MOVE METHOD CAUSE VELOCITY IS RETURNED AFTER MOVE
	move()
	
	# ------------------  CAYOTE JUMP -------------
	
	#its important to put cayote jump check after move() because it will get the real velocity.y value to check on. 
	var just_left_ground = not is_on_floor() and was_on_floor
	#
	if just_left_ground and velocity.y >= 0:
		cayoteJump = true
		cayoteJumpTimer.start()
	
	
func jump(delta):
	# checks if is on the ground and if cayote is true
	if is_on_floor() or cayoteJump:
		doubleJump = moveData.doubleJump
		if Input.is_action_just_pressed('jump') or bufferedJump:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = moveData.jumpSpeed
			bufferedJump = false
	#THIS IS WHEN THE PLAYER HAVE JUMPED AND IS ON THE AIR
	else:
		runTrail.emitting = false
		animSprite.play('Jump')
		
		#BASE JUMP RELEASE CODE
		if Input.is_action_just_released('jump') and velocity.y < moveData.jumpSpeed / moveData.jumpCut:
			velocity.y = moveData.jumpSpeed / moveData.jumpCut
		
		#BASE DOUBLE JUMP
		if Input.is_action_just_pressed('jump') and doubleJump > 0:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = moveData.jumpSpeed
			doubleJump -= 1
		#BASE BUFFER JUMP
		if Input.is_action_just_pressed('jump'):
			bufferedJump = true
			jumpBufferTimer.start()
		
		#FASTER FALL AFTER AIR TIME
		if velocity.y > 5 and not fast_fell:
			velocity.y += moveData.gravity_m * delta
			
			
#CLIMB STATE CODE
func climbState(input, delta):
	if not is_on_ladder():
		state = MOVE
	if input.length() != 0:
		animSprite.animation = 'Run'
	else:
		animSprite.animation = 'Idle'
	
	if input.x < 0:
		animSprite.flip_h = false
	elif input.x > 0:
		animSprite.flip_h = true
	
	velocity = input * moveData.climbSpeed
	
	move()
	
	pass
	
func player_die():
	Events.emit_signal('player_died')
	queue_free()
	SoundPlayer.play_sound(SoundPlayer.HURT)
	
func connect_camera(camera):
	var cameraPath = camera.get_path()
	remoteTransform.remote_path = cameraPath
	
func apply_gravity(delta):
	if moveData == null:
		moveData = load('res://Player/MovementData/DefaultPlayerMovementData.tres')
	velocity.y += moveData.gravity_m * delta
	velocity.y = min(velocity.y, 300)
	

func move():
	velocity = move_and_slide(velocity, Vector2.UP)
	
func apply_acceleration(val, delta):

	velocity.x = move_toward(velocity.x, moveData.max_speed * val, moveData.acceleration_m * delta)
	pass
	
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, moveData.friction_m * delta)
	pass
	
func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true

func _on_JumpBufferTimer_timeout() -> void:
	bufferedJump = false


func _on_CayoteJumpTimer_timeout() -> void:
	cayoteJump = false

func restart_scene():
	if Input.is_action_just_pressed('reloadscene'):
		print('reload')
		get_tree().reload_current_scene()
