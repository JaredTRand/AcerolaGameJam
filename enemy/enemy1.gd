extends CharacterBody3D

@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@export var SPEED:float

func _physics_process(delta):
	var current_loc = global_transform.origin
	var next_loc = nav_agent.get_next_path_position()
	var new_velocity = (next_loc - current_loc).normalized() * SPEED

	velocity = new_velocity
	move_and_slide()
	
func update_target_loc(target_loc):
	nav_agent.target_position = target_loc


# I thnk either no timer, or very short timer. the danger close can kind of "alert" that it's near
#death can be like you drop the cam (maybe) and then get lifted in the air with choking noises. Then black out, respawn outside with fewer pics, and 1 less life (3 maybe)
func _on_enemy_hurt_area_body_entered(body):
	if body.is_in_group("Player"):
		PlayerGlobals.player_death_timer.start()
		body.pass_out()
		print_debug("dying")
