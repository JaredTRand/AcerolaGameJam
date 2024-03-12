@tool
extends CharacterBody3D

var BasicFPSPlayerScene : PackedScene = preload("basic_player_head.tscn")
var addedHead = false

@onready var useCast:RayCast3D = $Head/useCast
@onready var playerSounds:AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var footstepTimer:Timer = $footsteptimer
@onready var hand_ui:Sprite3D = $Head/interact_UI2/hand
@onready var leave_ui:Sprite3D = $Head/interact_UI2/leave

@onready var animation_plr:AnimationPlayer = $Head/fadeToBlack/AnimationPlayer
@onready var ambience_plr:AudioStreamPlayer3D = $ambience_player
@onready var fade_in_timer:Timer = $fade_in_timer
@onready var player_death_timer:Timer = $player_death_timer

@onready var resource = load("res://Dialogue/level_one.dialogue")

signal player_left_location
func _enter_tree():
	if find_child("Head"):
		addedHead = true
	
	if Engine.is_editor_hint() && !addedHead:
		var s = BasicFPSPlayerScene.instantiate()
		add_child(s)
		s.owner = get_tree().edited_scene_root
		addedHead = true

## PLAYER MOVMENT SCRIPT ##
###########################

@export_category("Mouse Capture")
@export var CAPTURE_ON_START := true

@export_category("Movement")
@export_subgroup("Settings")
@export var SPEED := 5.0
@export var ACCEL := 50.0
@export var IN_AIR_SPEED := 3.0
@export var IN_AIR_ACCEL := 5.0
@export var JUMP_VELOCITY := 4.5
@export_subgroup("Head Bob")
@export var HEAD_BOB := true
@export var HEAD_BOB_FREQUENCY := 0.3
@export var HEAD_BOB_AMPLITUDE := 0.01
@export_subgroup("Clamp Head Rotation")
@export var CLAMP_HEAD_ROTATION := true
@export var CLAMP_HEAD_ROTATION_MIN := -90.0
@export var CLAMP_HEAD_ROTATION_MAX := 90.0

@export_category("Key Binds")
@export_subgroup("Mouse")
@export var MOUSE_ACCEL := true
@export var KEY_BIND_MOUSE_SENS := 0.005
@export var KEY_BIND_MOUSE_ACCEL := 50
@export_subgroup("Movement")
@export var KEY_BIND_UP := "move_forward"
@export var KEY_BIND_LEFT := "move_left"
@export var KEY_BIND_RIGHT := "move_right"
@export var KEY_BIND_DOWN := "move_backward"
@export var KEY_BIND_JUMP := "jump"

@export_category("Advanced")
@export var UPDATE_PLAYER_ON_PHYS_STEP := true	# When check player is moved and rotated in _physics_process (fixed fps)
												# Otherwise player is updated in _process (uncapped)
												

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# To keep track of current speed and acceleration
var speed = SPEED
var accel = ACCEL

# Used when lerping rotation to reduce stuttering when moving the mouse
var rotation_target_player : float
var rotation_target_head : float

# Used when bobing head
var head_start_pos : Vector3

# Current player tick, used in head bob calculation
var tick = 0

func _ready():
	if Engine.is_editor_hint():
		return

	# Capture mouse if set to true
	if CAPTURE_ON_START:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	head_start_pos = $Head.position
	
	#animation_plr.connect("animation_finished", self, "fade_in_from_black_complete")
	#animation_plr.animation_finished.connect(_on_animation_player_animation_finished)
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	
	
	start_level()

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	# Increment player tick, used in head bob motion
	tick += 1
	
	if UPDATE_PLAYER_ON_PHYS_STEP:
		move_player(delta)
		rotate_player(delta)
	
	if HEAD_BOB:
		# Only move head when on the floor and moving
		if velocity && is_on_floor():
			head_bob_motion()
		reset_head_bob(delta)

func _process(delta):
	if Engine.is_editor_hint():
		return

	if !UPDATE_PLAYER_ON_PHYS_STEP:
		move_player(delta)
		rotate_player(delta)
		
	if useCast.is_colliding():
		var collider = useCast.get_collider()
		if collider.is_in_group("interactable"):
			if collider.is_in_group("car"):
				leave_ui.visible = true
			else:
				hand_ui.visible = true
			if Input.is_action_just_pressed("interact"):
				if collider.is_in_group("interactable") and collider.has_method("use"):
					collider.use()
	elif not useCast.is_colliding() or not useCast.get_collider().is_in_group("interactable"):
		hand_ui.visible = false
		leave_ui.visible = false
	

func _input(event):
	if Engine.is_editor_hint():
		return
		
	# Listen for mouse movement and check if mouse is captured
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		set_rotation_target(event.relative)
		

func set_rotation_target(mouse_motion : Vector2):
	# Add player target to the mouse -x input
	rotation_target_player += -mouse_motion.x * KEY_BIND_MOUSE_SENS
	# Add head target to the mouse -y input
	rotation_target_head += -mouse_motion.y * KEY_BIND_MOUSE_SENS
	# Clamp rotation
	if CLAMP_HEAD_ROTATION:
		rotation_target_head = clamp(rotation_target_head, deg_to_rad(CLAMP_HEAD_ROTATION_MIN), deg_to_rad(CLAMP_HEAD_ROTATION_MAX))
	
func rotate_player(delta):
	if MOUSE_ACCEL:
		# Shperical lerp between player rotation and target
		quaternion = quaternion.slerp(Quaternion(Vector3.UP, rotation_target_player), KEY_BIND_MOUSE_ACCEL * delta)
		# Same again for head
		$Head.quaternion = $Head.quaternion.slerp(Quaternion(Vector3.RIGHT, rotation_target_head), KEY_BIND_MOUSE_ACCEL * delta)
	else:
		# If mouse accel is turned off, simply set to target
		quaternion = Quaternion(Vector3.UP, rotation_target_player)
		$Head.quaternion = Quaternion(Vector3.RIGHT, rotation_target_head)
	
func move_player(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector(KEY_BIND_LEFT, KEY_BIND_RIGHT, KEY_BIND_UP, KEY_BIND_DOWN)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var currently_moving:bool = input_dir != Vector2(0,0)
	# Check if not on floor
	if not is_on_floor():
		# Reduce speed and accel
		speed = IN_AIR_SPEED
		accel = IN_AIR_ACCEL
		# Add the gravity
		velocity.y -= gravity * delta
	else:
		# Set speed and accel to defualt
		speed = SPEED
		accel = ACCEL
		
		if footstepTimer.is_stopped() and currently_moving:
			play_sound(load("res://player/sounds/627913__mikefozzy98__01-footstep.wav"), [-8.5, -11], [1, 2])
			if Input.is_action_pressed("sprint"):
				footstepTimer.start(.25)
			else:
				footstepTimer.start(.5)

	if Input.is_action_pressed("sprint"):
		speed = SPEED * 2

	# Handle Jump.
	if Input.is_action_just_pressed(KEY_BIND_JUMP) and is_on_floor():
		velocity.y = JUMP_VELOCITY


	
	velocity.x = move_toward(velocity.x, direction.x * speed, accel * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, accel * delta)

	move_and_slide()

func head_bob_motion():
	var pos = Vector3.ZERO
	pos.y += sin(tick * HEAD_BOB_FREQUENCY) * HEAD_BOB_AMPLITUDE
	pos.x += cos(tick * HEAD_BOB_FREQUENCY/2) * HEAD_BOB_AMPLITUDE * 2
	$Head.position += pos

func reset_head_bob(delta):
	# Lerp back to the staring position
	if $Head.position == head_start_pos:
		pass
	$Head.position = lerp($Head.position, head_start_pos, 2 * (1/HEAD_BOB_FREQUENCY) * delta)



func play_sound(sound, max_db_rng:Array = [0,0], pitch_rng:Array = [0,0], skip_wait_for_done:bool = false):
	if skip_wait_for_done or !playerSounds.is_playing(): 
		 #just to give the sound a litte variety
		playerSounds.stream = sound
		playerSounds.set_max_db(RandomNumberGenerator.new().randf_range(max_db_rng[0], max_db_rng[1]))
		playerSounds.set_pitch_scale(RandomNumberGenerator.new().randf_range(pitch_rng[0], pitch_rng[1]))
		
		if pitch_rng[0] == pitch_rng[1]:
			playerSounds.set_pitch_scale(pitch_rng[0])
		if max_db_rng[0] == max_db_rng[1]:
			playerSounds.set_max_db(max_db_rng[0])
		playerSounds.play()


func pass_out():
	animation_plr.play("fade_to_black")

#Show dialogue. when done, start fade in timer. when done, start fading in. when done, start the level timer 
func start_level():
	await get_tree().process_frame
	DialogueManager.show_dialogue_balloon(resource, "start")

func _on_dialogue_manager_dialogue_ended(resource: DialogueResource):
	fade_in_timer.start()
	
func _on_fade_in_timer_timeout():
	animation_plr.play("fade_in")
	
func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "fade_in":
		PlayerGlobals.start_time = Time.get_datetime_dict_from_system()
	elif anim_name == "leave_location":
		#ambience_plr.stop()
		play_sound(load("res://player/sounds/player_leaving.ogg"))
		player_left_location.emit()
	elif anim_name == "pass_out":
		print_debug("passed out")
	
	
func leaving_location():
	animation_plr.play("leave_location")


func _on_player_death_timer_timeout():
	print_debug("passing out!!")
	animation_plr.play("pass_out")


func _on_enemy_player_in_hurt_zone():
	player_death_timer.start()
func _on_enemy_player_left_hurt_zone():
	player_death_timer.stop()
