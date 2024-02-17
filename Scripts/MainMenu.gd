extends Node2D

signal music_audio_changed
signal fx_audio_changed
signal music_toggled
signal fx_toggled

func _on_video_stream_player_finished():
	$VideoStreamPlayer.play()


func _on_arcade_mode_button_pressed():
	#get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	Global.load_scene("MainMenu", "ArcadeMode")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_music_finished():
	$MainMenuMusic.play()


func _on_settings_button_pressed():
	$MenuContainer/MainMenuContainer.hide()
	$MenuContainer/SettingsMenuContainer.show()


func _on_back_to_menu_button_pressed():
	$MenuContainer/MainMenuContainer.show()
	$MenuContainer/SettingsMenuContainer.hide()


func _on_fullscreen_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
	elif toggled_on == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)
	
	Global.fullscreen = toggled_on


func _on_music_db_value_changed(value):
	Global.music_volume = value
	$MenuContainer/SettingsMenuContainer/Music/MusicDbLabel.text = str(value * 100)
	if value == $MenuContainer/SettingsMenuContainer/Music/MusicDb.min_value:
		Global.music_enabled = false
	else:
		Global.music_enabled = true
	emit_signal("music_audio_changed")


func _on_music_audio_changed():
	var bus_name : String = "Music"
	var bus_index : int
	
	bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(Global.music_volume))


func _on_fx_db_value_changed(value):
	Global.fx_volume = value
	$MenuContainer/SettingsMenuContainer/Music/FXDbLabel.text = str(value * 100)
	if value == $MenuContainer/SettingsMenuContainer/Music/FXDb.min_value:
		Global.fx_enabled = false
	else:
		Global.fx_enabled = true
	emit_signal("fx_audio_changed")


func _on_fx_audio_changed():
	var bus_name : String = "Sfx"
	var bus_index : int
	
	bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(Global.fx_volume))


func _on_music_check_toggled(toggled_on):
	Global.music_enabled = toggled_on
	emit_signal("music_toggled")


func _on_music_toggled():
	var bus_name : String = "Music"
	var bus_index : int
	
	bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus_index, Global.music_enabled)


func _on_fx_check_toggled(toggled_on):
	Global.fx_enabled = toggled_on
	emit_signal("fx_toggled")


func _on_fx_toggled():
	var bus_name : String = "Sfx"
	var bus_index : int
	
	bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus_index, Global.fx_enabled)
