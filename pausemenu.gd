extends CanvasLayer

@onready var control = $PauseMenu

func _ready():
	control.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()

func pause():
	control.show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume():
	control.hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_button_pressed():
	resume()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
