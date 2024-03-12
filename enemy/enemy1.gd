extends CharacterBody3D

@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@export var SPEED:float
var is_activated:bool = false

var body_entered
var noise_fading_in
signal player_in_hurt_zone
signal player_left_hurt_zone
func _physics_process(delta):
	if is_activated:
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
	if body.is_in_group("Player") and is_activated:
		body_entered = body
		player_in_hurt_zone.emit()
		fade_up_noise() # fade scary noise in quickly, same amount of time as death timer (can you get that value from a timer? if so, set the tween time to that)

func _on_enemy_hurt_area_body_exited(body):
	if body.is_in_group("Player") and is_activated:
		player_left_hurt_zone.emit()
		fade_out_noise()

func _on_enemy_danger_close_area_body_entered(body):
	if body.is_in_group("Flashlight") and is_activated:
		body.break_light()

func fade_up_noise():
	noise_fading_in = true

func fade_out_noise():
	noise_fading_in = false

func _on_enemy_activated_timer_timeout():
	is_activated = true
