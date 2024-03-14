extends CharacterBody3D

@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@export var SPEED:float
@export var TURN_SPEED:float
@export var activation_timer_time:int = 120
@onready var activation_timer:Timer = $enemy_activated
var is_activated:bool = false
@onready var audio_plr := $AudioStreamPlayer3D
@onready var whispers := $areas/enemy_danger_close/Whispers
@onready var animation_plr := $"Root Scene/AnimationPlayer"
@onready var face_dir:Node3D = $face_dir
var body_entered
var noise_fading_in
signal player_in_hurt_zone
signal player_left_hurt_zone
func _physics_process(delta):
	if is_activated:
		face_dir.look_at(nav_agent.target_position, Vector3.UP)
		rotate_y(deg_to_rad(face_dir.rotation.y * TURN_SPEED))
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

func _on_enemy_danger_close_body_entered(body):
	if body.is_in_group("Flashlight") and is_activated:
		body.break_light()

func _on_enemy_danger_near_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
	
func fade_up_noise():
	noise_fading_in = true

func fade_out_noise():
	noise_fading_in = false

func _on_enemy_activated_timeout():
	is_activated = true
	audio_plr.stream = load("res://enemy/sounds/enemy_activated.ogg")
	audio_plr.volume_db = 6
	audio_plr.max_db = 8
	audio_plr.play()
	
	animation_plr.play("mixamo_com")
	
	whispers.play()


func _on_player_passing_out():
	audio_plr.stream = load("res://enemy/sounds/572618__blandy8521__ghost-scream-ver-3.wav")
	audio_plr.volume_db = .75
	audio_plr.max_db = 2
	audio_plr.play()


func _on_player_player_started_level():
	activation_timer.wait_time = activation_timer_time
	activation_timer.start()
