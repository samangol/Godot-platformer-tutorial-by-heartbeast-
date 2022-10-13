extends Area2D


export(String,FILE, '*.tscn') var target_level_path = ''

var overPlayer = false

func go_to_next_room():
	Transitions.play_exit_transition()
	get_tree().paused = true
	yield(Transitions, 'transition_completed')
	Transitions.play_enter_transition()
	get_tree().paused = false
	get_tree().change_scene(target_level_path)

func _process(delta: float) -> void:
	if not overPlayer: return
	if Input.is_action_just_pressed('enter'):
		if target_level_path.empty(): return
		go_to_next_room()

func _on_Door_body_entered(body: Node) -> void:
	if not body is Player: return
	overPlayer = true
	
func _on_Door_body_exited(body: Node) -> void:
	if not body is Player: return
	overPlayer = false
