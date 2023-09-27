extends Node

class_name Game

var score = 0
var combo = 0

var rush = false

var max_combo = 0
var hit = 0
var miss = 0

const BASE_STAMINA_SPEED = 1
var current_stamina = 100
const MAX_STAMINA = 100

var bpm = 126

var current_track
var level = 1

var level_ready = false
var truly_ready = false

var game_over = false

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var spawn_beat = 1

var lane = 0
#var rand = 0 I don't think I need a random beat since there's only one lane
var note = load("res://Scenes/note.tscn")
var instance

var current_character = AnimationData.MARIE

var current_normal_anim = "marie_blowjob_normal"
var current_rush_anim = "marie_blowjob_rush"
var current_cum_anim = "marie_blowjob_cum"

var current_anim_frame = 0

signal toggle_game_paused(is_paused : bool)

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _ready():
	randomize()
	
	var random_animation : int
	
	match current_character:
		AnimationData.MARIE:
			random_animation = randi() % AnimationData.marie_animations
	
	current_normal_anim = AnimationData.animations[current_character][random_animation][AnimationData.NORMAL]
	current_rush_anim = AnimationData.animations[current_character][random_animation][AnimationData.RUSH]
	current_cum_anim = AnimationData.animations[current_character][random_animation][AnimationData.CUM]
	
	$FuckAnim.animation = current_normal_anim
	$FuckAnim.frame = current_anim_frame
	$FuckAnim.play()
	
	current_stamina = 100
	$GetReady/AnimationPlayer.play("GetReady_default")
	
	current_track = randi() % MusicTrackData.total_tracks
	bpm = MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_BPM]
	get_node("Conductor").bpm = bpm
	get_node("Grid").bpm = bpm
	
	var audio_track = load(MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_PATH])
	$Conductor.stream = audio_track
	$TrackLabel.text = MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_TITLE] + "\n" + MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_ARTIST]
	
	$LevelLabel.text = "Level " + str(level)
	
	$Conductor._reset_positions()
	$Conductor.play_with_beat_offset(4)
	$FuckAnim.speed_scale = bpm / 100
	$FuckAnim.play()
	$FuckAnim.animation = current_normal_anim
	reset_combo()

func _advance_level():
	level += 1
	current_stamina = 100
	level_ready = true
	
	current_anim_frame = $FuckAnim.frame
	$FuckAnim.animation = current_cum_anim
	$FuckAnim.frame = current_anim_frame
	$FuckAnim.play()
	
	$GetReady/AnimationPlayer.play("GetReady_default")
	
	await $GetReady/AnimationPlayer.animation_finished
	
	#while level_ready:
	#	if !truly_ready:
	#		level_ready = false
	
	randomize()
	
	var random_animation : int
	
	match current_character:
		AnimationData.MARIE:
			random_animation = randi() % AnimationData.marie_animations
	
	current_normal_anim = AnimationData.animations[current_character][random_animation][AnimationData.NORMAL]
	current_rush_anim = AnimationData.animations[current_character][random_animation][AnimationData.RUSH]
	current_cum_anim = AnimationData.animations[current_character][random_animation][AnimationData.CUM]
	
	current_anim_frame = $FuckAnim.frame
	$FuckAnim.animation = current_normal_anim
	$FuckAnim.frame = current_anim_frame
	$FuckAnim.play()
	
	
	current_track = randi() % MusicTrackData.total_tracks
	bpm = MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_BPM]
	get_node("Conductor").bpm = bpm
	get_node("Grid").bpm = bpm
	
	var audio_track = load(MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_PATH])
	$Conductor.stream = audio_track
	$TrackLabel.text = MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_TITLE] + "\n" + MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_ARTIST]
	
	$LevelLabel.text = "Level " + str(level)
	
	$Conductor._reset_positions()
	$Conductor.play_with_beat_offset(4)
	$FuckAnim.speed_scale = bpm / 100
	$FuckAnim.play()
	$FuckAnim.animation = current_normal_anim
	reset_combo()

func _process(delta):
	if !game_paused: # let's not deplete it on the pause menu
		var deplete_speed = min((BASE_STAMINA_SPEED * level), 25) * delta
		
		current_stamina -= deplete_speed # have a speed cap, for Jim Flynn's sake, nobody wants the stamina bar to deplete at the speed of light at some point
		
		#don't you dare go below 0
		current_stamina = max(current_stamina, 0)
		
		#update the stamina bar
		$StaminaMeter.value = current_stamina
		
		if current_stamina <= 0:
			if !game_over:
				_game_over()
	# current_anim_frame = $FuckAnim.frame # Turns out this might be resource intensive
	# print(current_stamina)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var current_value = get_tree().paused
		game_paused = !game_paused
		

func increment_score(by):
	if by > 0:
		combo += 1
	else:
		combo = 0
	
	if by == 1:
		hit += 1
	else:
		miss += 1
	
	score += by * combo
	$ScoreLabel.text = str(score)
	
	current_stamina += 25 * by
	
	# don't surpass the max of 100 stamina
	current_stamina = min(current_stamina, 100)
	
	#update the stamina bar
	$StaminaMeter.value = current_stamina
	
	if combo > 0:
		$ComboLabel.text = "Combo\n" + str(combo)
		if combo > max_combo:
			max_combo = combo
			$RushNotif.visible = true
			current_anim_frame = $FuckAnim.frame
			$FuckAnim.animation = current_rush_anim
			$FuckAnim.frame = current_anim_frame
			$FuckAnim.play()
			$SfxRush.play()
	else:
		$ComboLabel.text = ""
		current_anim_frame = $FuckAnim.frame
		$FuckAnim.animation = current_normal_anim
		$FuckAnim.frame = current_anim_frame
		$FuckAnim.play()
		$RushNotif.visible = false

func reset_combo():
	combo = 0
	$ComboLabel.text = ""
	current_anim_frame = $FuckAnim.frame
	$FuckAnim.animation = current_normal_anim
	$FuckAnim.frame = current_anim_frame
	$FuckAnim.play()
	$RushNotif.visible = false

func _spawn_notes(to_spawn):
	if to_spawn > 0:
		lane = 0
		instance = note.instantiate()
		instance.initialize()
		add_child(instance)



func _on_conductor_current_measure(position):
	_spawn_notes(spawn_beat)


func _on_conductor_beat(position):
	song_position_in_beats = position
	spawn_beat = 1


func _on_video_stream_player_finished():
	$VideoStreamPlayer.play()


func _on_conductor_finished():
	if game_over == false:
		_advance_level()


func _on_animation_player_animation_finished(anim_name):
	truly_ready = false

func _game_over():
	game_over = true
	
	$Conductor.stop()
	$FuckAnim.stop()
	
	$GameOverSFX.play()
	
	$GameOverRect.visible = true
	$GameOverRect/GameOverInfo.text = "Final score: " + str(score) + "\nHighest combo: " + str(max_combo) + "\nLevel: " + str(level)
	$GameOverRect/GameOverAnim.play("GameOver")


func _on_back_to_menu_button_go_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	#Global.load_scene(self, "MainMenu")
