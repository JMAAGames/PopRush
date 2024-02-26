extends Node

var music_enabled : bool
var fx_enabled : bool

var music_volume : float
var fx_volume : float

var fullscreen : bool

var current_player_name : String

const GAME_SCENES = {
	"ArcadeMode": "res://Scenes/Game.tscn",
	"MainMenu": "res://Scenes/MainMenu.tscn"
}

var loading_screen = preload("res://Scenes/LoadingScreen.tscn")

func _ready():
	SilentWolf.configure({
			"api_key": "WDeq2JRCed2QCfMUPdbvIarjYyMXeWq15kDMdcyk",
			"game_id": "poprush",
			"log_level": 0
		})
	

func load_scene(current_scene, next_scene):
	var loading_screen_instance = loading_screen.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_screen_instance)
	
	var load_path : String
	if GAME_SCENES.has(next_scene):
		load_path = GAME_SCENES[next_scene]
	else:
		load_path = next_scene
	
	var loader_next_scene
	if ResourceLoader.exists(load_path):
		loader_next_scene = ResourceLoader.load_threaded_request(load_path, "", true)
	
	if loader_next_scene == null:
		print("Invalid scene!")
		return
	
	await loading_screen_instance.safe_to_load
	#current_scene.queue_free()
	
	while true:
		var load_progress = []
		var load_status = ResourceLoader.load_threaded_get_status(load_path, load_progress)
		
		if load_status == 3:
			var next_scene_instance = ResourceLoader.load_threaded_get(load_path)
			#get_tree().get_root().call_deferred("add_child", next_scene_instance)
			get_tree().change_scene_to_packed(next_scene_instance)
			
			loading_screen_instance.fade_out_loading_screen()
			return

