extends CanvasLayer

onready var animationPlayer: AnimationPlayer = $AnimationPlayer

signal transition_completed
signal restartScene

func play_exit_transition():
	animationPlayer.play('ExitLevel')
	
func play_enter_transition():
	animationPlayer.play('EnterLevel')

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal('transition_completed')


