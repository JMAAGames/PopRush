extends AnimatedSprite2D

var action = false
var done = false
var current_note = null

signal action_now(status)
signal done_now(status)
signal current_note_now(note)

func _on_action_area_area_entered(area):
	if area.is_in_group("note"):
		action = true
		done = false
		current_note = area
		frame = 1
		emit_signal("action_now", action)
		var bottles = get_parent().get_node("Grid").get_children()
		for bottle in bottles:
			if bottle is Node2D:
				bottle.dance_up()




func _on_done_area_area_entered(area):
	if area.is_in_group("note"):
		done = true
		action = false
		current_note.get_parent().destroy()
		current_note = null
		frame = 0
		emit_signal("done_now", done)
		var bottles = get_parent().get_node("Grid").get_children()
		for bottle in bottles:
			if bottle is Node2D:
				bottle.dance_down()


func _on_push_timer_timeout():
	frame = 0

func _reset():
	current_note = null
	done = false
	action = false

func _update_status():
	emit_signal("action_now", action)
	emit_signal("done_now", done)
	emit_signal("current_note_now", current_note)

func _action_status():
	return action

func _done_status():
	return done

func _current_note_status():
	return current_note

