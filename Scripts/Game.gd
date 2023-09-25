extends Node

var score = 0
var combo = 0

var rush = false

var max_combo = 0
var hit = 0
var miss = 0

const BASE_STAMINA_SPEED = 2
var current_stamina = 100
const MAX_STAMINA = 100

var bpm = 126

var current_track
var level = 1

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var spawn_beat = 1

var lane = 0
#var rand = 0 I don't think I need a random beat since there's only one lane
var note = load("res://Scenes/note.tscn")
var instance

var current_normal_anim = "marie_blowjob_normal"
var current_rush_anim = "marie_blowjob_rush"
var current_cum_anim = "marie_blowjob_cum"

var current_anim_frame = 0

func _ready():
	
	current_stamina = 100
	randomize()
	current_track = randi() % MusicTrackData.total_tracks
	bpm = MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_BPM]
	get_node("Conductor").bpm = bpm
	get_node("Grid").bpm = bpm
	
	var audio_track = load(MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_PATH])
	$Conductor.stream = audio_track
	$TrackLabel.text = MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_TITLE] + "\n" + MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_ARTIST]
	
	$LevelLabel.text = "Level " + str(level)
	
	$Conductor._reset_positions()
	$Conductor.play_from_beat(0, 4)
	$FuckAnim.speed_scale = bpm / 100
	$FuckAnim.play()
	$FuckAnim.animation = current_normal_anim
	reset_combo()

func _advance_level():
	level += 1
	current_stamina = 100
	randomize()
	current_track = randi() % MusicTrackData.total_tracks
	bpm = MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_BPM]
	get_node("Conductor").bpm = bpm
	get_node("Grid").bpm = bpm
	
	var audio_track = load(MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_PATH])
	$Conductor.stream = audio_track
	$TrackLabel.text = MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_TITLE] + "\n" + MusicTrackData.music_track_data[current_track][MusicTrackData.KEY_ARTIST]
	
	$LevelLabel.text = "Level " + str(level)
	
	$Conductor._reset_positions()
	$Conductor.play_from_beat(0, 4)
	$FuckAnim.speed_scale = bpm / 100
	$FuckAnim.play()
	$FuckAnim.animation = current_normal_anim
	reset_combo()

func _process(delta):
	current_stamina -= (BASE_STAMINA_SPEED * level) * delta
	
	#don't you dare go below 0
	current_stamina = max(current_stamina, 0)
	
	#update the stamina bar
	$StaminaMeter.value = current_stamina
	
	# current_anim_frame = $FuckAnim.frame # Turns out this might be resource intensive
	# print(current_stamina)

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
	_advance_level()
