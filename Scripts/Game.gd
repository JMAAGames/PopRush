extends Node

var score = 0
var combo = 0

var rush = false

var max_combo = 0
var hit = 0
var miss = 0

var bpm = 126

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var spawn_beat = 1

var lane = 0
#var rand = 0 I don't think I need a random beat since there's only one lane
var note = load("res://Scenes/note.tscn")
var instance


func _ready():
	$Conductor.play_with_beat_offset(4)
	reset_combo()

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
	if combo > 0:
		$ComboLabel.text = "Combo\n" + str(combo)
		if combo > max_combo:
			max_combo = combo
			$RushNotif.visible = true
	else:
		$ComboLabel.text = ""

func reset_combo():
	combo = 0
	$ComboLabel.text = ""
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
