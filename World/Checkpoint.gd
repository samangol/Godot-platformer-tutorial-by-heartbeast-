extends Area2D

onready var animSprite = $AnimatedSprite

var active = true

func _on_Checkpoint_body_entered(body: Node) -> void:
	if not body is Player: return
	if not active: return
	animSprite.play('Checked')
	active = false
	Events.emit_signal('hit_checkpoint', position)
	
