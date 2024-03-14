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

#@onready var all_cam_raycasts:Node3D = get_node("raycasts")
#@onready var raycast_main:RayCast3D = get_node("RayCast3D_main")

@export var flash_brightness:float
const ADS_LERP:int = 20
@export var default_pos:Vector3
@export var ads_pos:Vector3

var images_array:Array
var current_image:Aberration_Image

func _ready():
	current_image = PlayerGlobals.all_images[PlayerGlobals.all_images.size()-1]
func _process(delta):
	cam_follow_movement.global_transform = camera_loc.global_transform # make handheld_viewport_cam follow with cam mesh	
	
	#bring camera close
	if Input.is_action_pressed("secondary_action"):
		if Input.is_action_just_pressed("secondary_action"):
			play_sound(load("res://player/cam/sounds/camera_going_inv.wav"), [-15.0, -13.5], [3, 2])
			
		transform.origin = transform.origin.lerp(ads_pos, ADS_LERP*delta)
		
		if(current_image != null):
			set_cam_screen_ab(current_image)
				
		cam_preview_image_cooldown.start()
	else:
		if Input.is_action_just_released("secondary_action"):
			play_sound(load("res://player/cam/sounds/cam_going_out.wav"), [-15.0, -13.5], [2,2])
			
		transform.origin = transform.origin.lerp(default_pos, ADS_LERP*delta)
		
	if(PlayerGlobals.all_images.size() > 0):
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
	
	if Input.is_action_just_pressed("cam_favorite_img"):
		if current_image == null or cam_preview_image_cooldown.is_stopped(): return
		if(current_image.starred):
			play_sound(load("res://player/cam/sounds/star_image_remove.wav"), [-9.0, -7.5], [.90, 1.1])
			current_image.starred = false
			starred.visible = false
		else: 
			play_sound(load("res://player/cam/sounds/star_fav.wav"), [-15.0, -13.5], [.90, 1.1])
			current_image.starred = true
			starred.visible = true
	elif Input.is_action_just_pressed("cam_delete_image"):
		delete_image(current_image)
			
	
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
	if(PlayerGlobals.all_images.size() > 0):
		current_image = PlayerGlobals.all_images[PlayerGlobals.all_images.size()-1]
	set_cam_screen(black_screen)
	starred.visible = false

func play_sound(sound, max_db_rng:Array, pitch_rng:Array, skip_wait_for_done:bool = false):
	if skip_wait_for_done or !cam_sound_player.is_playing(): 
		 #just to give the sound a litte variety
		cam_sound_player.stream = sound
		cam_sound_player.set_max_db(RandomNumberGenerator.new().randf_range(max_db_rng[0], max_db_rng[1]))
		cam_sound_player.set_pitch_scale(RandomNumberGenerator.new().randf_range(pitch_rng[0], pitch_rng[1]))
		cam_sound_player.play()
		
func delete_image(image_to_del:Aberration_Image):
		if image_to_del == null or image_to_del.starred: return
		play_sound(load("res://player/cam/sounds/img_delete.wav"), [-15.0, -13.5], [-6, -5], true)
		
		var temp_img:Aberration_Image
		var prev_img:Aberration_Image = image_to_del.prev_img
		var next_img:Aberration_Image = image_to_del.next_img
		
		if next_img != null and prev_img != null: 
			next_img.prev_img = prev_img
			prev_img.next_img = next_img
			temp_img = next_img
		elif next_img != null and prev_img == null:
			next_img.prev_img = null
			temp_img = next_img
		if prev_img != null and next_img == null:
			prev_img.next_img = null
			temp_img = prev_img
			
		PlayerGlobals.all_images.remove_at(PlayerGlobals.all_images.find(image_to_del))
			
		if(temp_img != null):
			current_image = temp_img
			set_cam_screen_ab(temp_img)
		else:
			current_image = null
			set_cam_screen(black_screen)
