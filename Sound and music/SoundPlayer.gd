extends Node

const HURT = preload('res://Sound and music/HurtSound.wav')
const JUMP = preload('res://Sound and music/JumpSound.wav')
const LAND = preload('res://Sound and music/LandingSound.wav')

onready var audioPlayers = $AudioPlayers

func play_sound(sound):
	for audioSPlayer in audioPlayers.get_children():
		if not audioSPlayer.playing:
			audioSPlayer.stream = sound
			audioSPlayer.play()
			break
		pass
