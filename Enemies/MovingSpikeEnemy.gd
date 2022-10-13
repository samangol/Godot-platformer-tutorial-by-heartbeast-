tool
extends Path2D


enum ANIMATION_TYPE {
	LOOP,
	BOUNCE
}

export(ANIMATION_TYPE) var animationType setget set_animation_type
export(int) var speed = 1 setget set_speed
export var animTime = 4

onready var animPlayer = $AnimationPlayer

func set_speed(value):
	speed = value
	var ap = find_node('AnimationPlayer')
	if ap: ap.playback_speed = speed
	
func set_animation_type(type):
	animationType = type
	var ap = find_node('AnimationPlayer')
	if ap:
		play_updated_animation(ap)
	
func _ready() -> void:
	play_updated_animation(animPlayer)

func play_updated_animation(ap):
	match animationType:
		ANIMATION_TYPE.LOOP:
			ap.play('MovingSpikeLoop')
		ANIMATION_TYPE.BOUNCE:
			ap.play('MovingSpikeBounce')
			
		
