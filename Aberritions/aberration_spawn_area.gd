extends Node3D

var will_spawn:bool = false
var ab_to_spawn
@onready var spawn_point:Node3D = $Area3D/SpawnPoint

@export var aberration_list:Array[PackedScene]
@export var chance:Array = [1,3]

# Will run the chances of this area spawning an aberrition or not. Defaults to 33% chance
# if it will spawn, it picks a random ab from the list.
func _ready():
	will_spawn = get_chance(chance, 1)
	if will_spawn:
		spawn_ab()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_chance(chance_rng:Array, chance_num:int):
	return RandomNumberGenerator.new().randi_range(chance_rng[0], chance_rng[1])  == chance_num

#TODO: CONNECT SIGNAL
func _on_body_entered(body):
	if body.is_in_group("Player"):
		print_debug("entered")
		ab_to_spawn.fade_up_noise()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		print_debug("exited")
		ab_to_spawn.fade_up_noise()

func spawn_ab():
	ab_to_spawn = aberration_list.pick_random()
	spawn_point.add_child(ab_to_spawn.instantiate())
