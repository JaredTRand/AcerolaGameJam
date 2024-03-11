extends Node3D

var will_spawn:bool = false
var ab_to_spawn
var spawn_point:Node3D = $SpawnPoint

@export var aberration_list:AberrationList
@export var chance:Array = [1,3]

# Will run the chances of this area spawning an aberrition or not. Defaults to 33% chance
# if it will spawn, it picks a random ab from the list.
func _ready():
	will_spawn = get_chance([chance[0],chance[1], 3)
	if will_spawn:
		ab_to_spawn = aberration_list.pick_random()
		ab_noise = ab_to_spawn.get_noise()
		spawn_point.add_child(ab_to_spawn.instance())
	else:
		self.queue_free() #remove from scene if not being used


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_chance(chance_rng:Array, chance_num:Int):
	return RandomNumberGenerator.new().randf_range(chance_rng[0], change_rng[1]) == chance_num

#TODO: CONNECT SIGNAL
func _on_body_entered(body):
	if body.is_in_group("Player"):
		print_debug("entered")
		ab_to_spawn.fade_up_noise()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		print_debug("exited")
		ab_to_spawn.fade_up_noise()
