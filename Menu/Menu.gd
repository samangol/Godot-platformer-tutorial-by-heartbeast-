extends Control

func _ready() -> void:
	$VBoxContainer/Start.grab_focus()

func _on_Start_pressed() -> void:
	get_tree().change_scene('res://Levels/Level2.tscn')


func _on_Options_pressed() -> void:
	pass
	

func _on_Quit_pressed() -> void:
	get_tree().quit()
