extends Node2D


const PlayerScene = preload('res://Player/Player.tscn')

onready var camera = $Camera2D
onready var player = $Player
onready var timer = $Timer

var playerSpawnLoc = Vector2.ZERO

func _ready() -> void:
	playerSpawnLoc = player.global_position
	VisualServer.set_default_clear_color(Color.lightblue)
	player.connect_camera(camera)
	Events.connect('player_died', self, '_on_player_died')
	Events.connect('hit_checkpoint',self,'_on_hit_checkpoint')
	
func _on_player_died():
	timer.start(1.0)
	yield(timer, 'timeout')
	var player = PlayerScene.instance()
	add_child(player)
	player.global_position = playerSpawnLoc
	player.connect_camera(camera)
	
func _on_hit_checkpoint(checkpoint_pos):
	playerSpawnLoc = checkpoint_pos

