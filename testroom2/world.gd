extends Node3D

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerGlobals.aberritions_in_scene = get_tree().get_nodes_in_group("Aberration").size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().call_group("enemies", "update_target_loc", player.global_transform.origin)
