extends Node3D

@onready var player = $Player
var all_spawners:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerGlobals.aberritions_in_scene = get_tree().get_nodes_in_group("Aberration").size()
	player.player_left_location.connect("next_scene")
	#later should add logic to make sure that game definitely has > 2 or 3 abs


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().call_group("enemies", "update_target_loc", player.global_transform.origin)


func _on_car_2_player_leave_location():
	PlayerGlobals.calculate_score()
	player.leaving_location()

func next_scene():
	pass
