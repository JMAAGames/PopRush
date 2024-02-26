extends Node2D

signal music_audio_changed
signal fx_audio_changed
signal music_toggled
signal fx_toggled

@export var board_entry_scene : PackedScene

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
	$MenuContainer/LeaderboardsContainer.hide()


func _on_back_to_menu_button_pressed():
	$MenuContainer/MainMenuContainer.show()
	$MenuContainer/SettingsMenuContainer.hide()
	$MenuContainer/LeaderboardsContainer.hide()


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


func _on_leaderboards_button_pressed():
	$MenuContainer/MainMenuContainer.hide()
	$MenuContainer/SettingsMenuContainer.hide()
	$MenuContainer/LeaderboardsContainer.show()
	
	for a in $MenuContainer/LeaderboardsContainer/LeaderboardScroll/LeaderboardScoresContainer.get_children(): #before anything, just clean up everything before adding stuff there
		a.queue_free()
	
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	var scorez = sw_result.scores
	print("Scores: " + str(sw_result.scores))
	print(str(scorez))
	
	#var sw_result2 = await SilentWolf.Scores.get_top_score_by_player(Global.current_player_name).sw_get_player_scores_complete
	#var player_score = sw_result2.score
	
	for score in scorez:
		var entry = board_entry_scene.instantiate()
		entry.player_name = score.player_name
		entry.player_score = str(int(score.score))
		$MenuContainer/LeaderboardsContainer/LeaderboardScroll/LeaderboardScoresContainer.add_child(entry)
	
	#var player_entry = board_entry_scene.instantiate()
	#player_entry.player_name = player_score.player_name
	#player_entry.player_score = str(int(player_score.score))
