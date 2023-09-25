extends Node2D

const TARGET_Y = 1030
const SPAWN_Y = 50
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const LANE_SPAWN = Vector2(1780, SPAWN_Y)

var speed = 0
var hit = false

func _process(delta):
	if !hit:
		position.y += speed * delta
	else:
		$ColorRect.position.y -= speed * delta
		
func initialize():
	position = LANE_SPAWN
	
	speed = DIST_TO_TARGET / 2.0

func destroy():
	#$Timer.start()
	hit = true
	queue_free()



func _on_timer_timeout():
	queue_free()
