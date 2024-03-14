extends Node3D

@onready var player = $Player
@export var low_limit_abs:int = 4
@onready var resource = load("res://Dialogue/level_one.dialogue")


# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_left_location.connect(next_scene)
	
	## If not enough aberritions, spawn more.
	var total_spawns = get_total_spawns()
	while total_spawns < low_limit_abs:
		total_spawns = get_total_spawns()
		make_spawned_abs_over_limit()
		var unspawned = get_unspawned_spawners()
	
	PlayerGlobals.aberritions_in_scene = get_tree().get_nodes_in_group("Aberration").size()
	PlayerGlobals.all_aberrations = get_tree().get_nodes_in_group("Aberration")
	DialogueManager.show_dialogue_balloon(resource, "start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_tree().call_group("enemies", "update_target_loc", player.global_transform.origin)


func _on_car_2_player_leave_location():
	#PlayerGlobals.calculate_score()
	player.leaving_location()

func next_scene():
	#get_tree().change_scene_to_file("res://End_Level/end_level_driving.tscn")
	PlayerGlobals.calculate_score()
	get_tree().change_scene_to_file("res://End_Level/end_level_driving.tscn")
	
func make_spawned_abs_over_limit():
	var unspawned = get_unspawned_spawners()
	for spawner in unspawned:
		spawner.try_to_spawn()
	
func get_unspawned_spawners():
	var unspawned:Array
	for spawner in get_tree().get_nodes_in_group("spawner"):
		if not spawner.spawned:
			unspawned.append(spawner)
	return unspawned

func get_total_spawns():
	var all_spawners = get_tree().get_nodes_in_group("spawner")
	return all_spawners.size() - get_unspawned_spawners().size()
