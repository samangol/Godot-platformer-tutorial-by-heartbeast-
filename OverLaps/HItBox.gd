extends Area2D

onready var die_particle: Particles2D = $DieParticle

func _on_HItBox_body_entered(body: Node) -> void:
	if body is Player:
		die_particle.emitting = true
		body.player_die()
