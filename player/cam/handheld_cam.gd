extends Node3D

@onready var handheld_camera:Camera3D = get_node("SubViewport/ROOT/handheld_viewport_cam")


@onready var cam_flash:SpotLight3D     = get_node("CameraFLash")
@onready var camera_loc:Node3D = get_node("camera_lens_loc")
@onready var cam_follow_movement:Node3D = get_node("SubViewport/ROOT")
@onready var cam_sound_player:AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")

@onready var cam_sprite:Sprite3D = get_node("sprites/Sprite3D")
@onready var cam_sprite_Screen:Sprite3D = get_node("sprites/spriteScreen")
@onready var starred:Sprite3D = get_node("sprites/starred")

@onready var cam_cooldown_timer:Timer = get_node("timers/cam_cooldown")
@onready var cam_preview_image_cooldown:Timer = get_node("timers/cam_preview_image_cooldown")

@onready var black_screen:Image = load("res://player/cam/black2.png").get_image()

@onready var all_cam_raycasts:Node3D = get_node("raycasts")

@export var flash_brightness:float
const ADS_LERP:int = 20
@export var default_pos:Vector3
@export var ads_pos:Vector3

var images_array:Array
var current_image:Aberration_Image

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	# take a pic
	if Input.is_action_pressed("main_action"):
		if cam_cooldown_timer.is_stopped():
			take_pic()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam_follow_movement.global_transform = camera_loc.global_transform # make handheld_viewport_cam follow with cam mesh
	
	#bring camera close
	if Input.is_action_pressed("secondary_action"):
		if Input.is_action_just_pressed("secondary_action"):
			play_sound(load("res://player/cam/sounds/camera_going_inv.wav"), [-15.0, -13.5], [3, 2])
			
		transform.origin = transform.origin.lerp(ads_pos, ADS_LERP*delta)
		
		if(current_image != null):
			set_cam_screen_ab(current_image)
		if(images_array.size() > 0):
			if Input.is_action_just_pressed("cam_prev_image"):
				if(current_image.prev_img != null):
					play_sound(load("res://player/cam/sounds/camera_next_image.wav"), [-10, -7], [1,1], true)
					current_image = current_image.prev_img
					set_cam_screen_ab(current_image)
			elif Input.is_action_just_pressed("cam_next_image"):
				if(current_image.next_img != null):
					play_sound(load("res://player/cam/sounds/camera_next_image.wav"), [-10, -7], [-1,-1], true)
					current_image = current_image.next_img
					set_cam_screen_ab(current_image)
				
		cam_preview_image_cooldown.start()
	else:
		if Input.is_action_just_released("secondary_action"):
			play_sound(load("res://player/cam/sounds/cam_going_out.wav"), [-15.0, -13.5], [2,2])
			
		transform.origin = transform.origin.lerp(default_pos, ADS_LERP*delta)
		
	if Input.is_action_just_pressed("cam_favorite_img"):
		if(current_image.starred):
			current_image.starred = false
			starred.visible = false
		else: 
			current_image.starred = true
			starred.visible = true
	elif Input.is_action_just_pressed("cam_delete_image"):
		var temp_img:Aberration_Image
		
		if(current_image.next_img != null):
			temp_img = current_image.next_img
		elif(current_image.prev_img != null):
			temp_img = current_image.next_img
			
		if(temp_img != null):
			set_cam_screen_ab(temp_img)
		else:
			set_cam_screen(black_screen)
			
		images_array.remove_at(images_array.find(current_image))

func take_pic():
	cam_cooldown_timer.start()
	cam_flash.light_energy = flash_brightness
	await get_tree().create_timer(.3).timeout
	cam_flash.light_energy = 0
	await get_tree().create_timer(.2).timeout
	cam_flash.light_energy = flash_brightness
	
	#wait for flash and take pic, save pic
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	var image:Image = cam_sprite.get_texture().get_image()
	#image.flip_x()
	
	save_img(image)
	cam_flash.light_energy = 0
	
	play_sound(load("res://player/cam/sounds/camera-shutter.wav"), [-3.0, -1.5], [.90, 1.1])
	
	await get_tree().create_timer(.05).timeout
	set_cam_screen(image)

	
func save_img(cam_img:Image):
	var new_ab_img:Aberration_Image = Aberration_Image.new()
	new_ab_img.ab_image = cam_img
	
	# Set next image var for previous image, and prev image var for new img
	if(images_array.size() > 0):
		images_array[images_array.size()-1].next_img = new_ab_img
		new_ab_img.prev_img = images_array[images_array.size()-1]
	
	var aberrations_pictured:Array = raycast_camera(5)
	if aberrations_pictured:
		for abb in raycast_camera(5):
			new_ab_img.aberrations_pictured.append(abb)
	
	current_image = new_ab_img
	images_array.push_back(new_ab_img)
	
func raycast_camera(amount:int):
	var all_collisions:Array
	var unique_collisions:Array
	var return_collisions:Array
	
	for ray_group in all_cam_raycasts.get_children():
		for ray in ray_group.get_children():
			ray.enabled = true
			ray.force_raycast_update()
			var collision = ray.get_collider()
			
			if collision.is_in_group("Aberration"):
				all_collisions.append(collision)
				
				if collision not in unique_collisions:
					unique_collisions.append(collision)
	
	for col in unique_collisions:
		if all_collisions.count(col) > amount:
			return_collisions.append(col)
	return return_collisions

	
func set_cam_screen_ab(cam_img:Aberration_Image):
	if(cam_img.starred):
		starred.visible = true
	else:
		starred.visible = false
	set_cam_screen(cam_img.ab_image)
	
func set_cam_screen(cam_img:Image):
	var imagetex = ImageTexture.create_from_image(cam_img)
	var og_material = cam_sprite_Screen.get_texture()
	
	cam_sprite_Screen.set_texture(imagetex)
	cam_sprite_Screen.get_window()
	cam_preview_image_cooldown.start()

func _on_cam_preview_image_cooldown_timeout():
	if(images_array.size() > 0):
		current_image = images_array[images_array.size()-1]
	set_cam_screen(black_screen)
	starred.visible = false

func play_sound(sound, max_db_rng:Array, pitch_rng:Array, skip_wait_for_done:bool = false):
	if skip_wait_for_done or !cam_sound_player.is_playing(): 
		 #just to give the sound a litte variety
		cam_sound_player.stream = sound
		cam_sound_player.set_max_db(RandomNumberGenerator.new().randf_range(max_db_rng[0], max_db_rng[1]))
		cam_sound_player.set_pitch_scale(RandomNumberGenerator.new().randf_range(pitch_rng[0], pitch_rng[1]))
		cam_sound_player.play()
