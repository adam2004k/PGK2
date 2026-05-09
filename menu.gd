extends Control


func _ready():
	$CenterContainer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$CenterContainer/VBoxContainer/OptionsButton.pressed.connect(_on_options_pressed)
	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://node_3d2.tscn")


func _on_options_pressed():
	print("Opcje")


func _on_exit_pressed():
	get_tree().quit()
