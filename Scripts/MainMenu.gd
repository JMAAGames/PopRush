extends Node2D

@export var arcadeModeScene : PackedScene

func _on_video_stream_player_finished():
	$VideoStreamPlayer.play()


func _on_arcade_mode_button_pressed():
	get_tree().change_scene_to_packed(arcadeModeScene)
	#Global.load_scene(self, "ArcadeMode")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_music_finished():
	$MainMenuMusic.play()
