extends AudioStreamPlayer

@export var bpm : int = 126
@export var measures : int = 1

# Tracking the beat and song position
var song_position : float = 0.0
var song_position_in_beats : int = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal current_measure(position)

func _ready():
	sec_per_beat = 60.0 / bpm

func _process(delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

func _reset_positions():
	sec_per_beat = 60.0 / bpm #surely the bpm has already changed by now...
	
	last_reported_beat = 0
	
	song_position = 0.0
	song_position_in_beats = 1

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("beat", song_position_in_beats)
		emit_signal("current_measure", measure)
		last_reported_beat = song_position_in_beats
		measure += 1

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	#print("Waiting: " + str($StartTimer.wait_time))
	$StartTimer.start()
	#print("I entered")

func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth)
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(beat_real, offset):
	play()
	seek(beat_real * sec_per_beat)
	beats_before_start = offset
	measure = beat_real % measures

func _on_start_timer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		#print("I am playing")
		play()
		$StartTimer.stop()
	_report_beat()
