extends Control

@export var game : Game
@export var mainMenuScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	game.connect("toggle_game_paused", on_game_toggle_game_paused)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_game_toggle_game_paused(is_paused : bool):
	if is_paused:
		show()
		$PauseMenuMusic.play()
	else:
		hide()
		$PauseMenuMusic.stop()


func _on_resume_button_pressed():
	game.game_paused = false


func _on_pause_menu_music_finished():
	if game.game_paused:
		$PauseMenuMusic.play() # loop lol


func _on_back_to_menu_button_pause_pressed():
	get_tree().change_scene_to_packed(mainMenuScene)
	#Global.load_scene(self, "MainMenu")
