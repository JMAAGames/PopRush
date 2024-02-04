extends Node2D

func _on_video_stream_player_finished():
	$VideoStreamPlayer.play()


func _on_arcade_mode_button_pressed():
	#get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	Global.load_scene("MainMenu", "ArcadeMode")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_music_finished():
	$MainMenuMusic.play()
