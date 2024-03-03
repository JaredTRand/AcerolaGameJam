extends Node3D

@onready var lens = get_node("camera_lens_loc")
@onready var cam_flash:SpotLight3D     = get_node("CameraFLash")
@onready var cam_sprite:Sprite3D = get_node("Sprite3D")
@onready var cam_sprite_Screen:Sprite3D = get_node("spriteScreen")
@onready var cam_follow_movement:Node3D = get_node("SubViewport/ROOT")
@onready var cam_sound_player:AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")

@onready var cam_cooldown_timer:Timer = get_node("timers/cam_cooldown")
@onready var cam_preview_image_cooldown:Timer = get_node("timers/cam_preview_image_cooldown")

const ADS_LERP:int = 20
@export var default_pos:Vector3
@export var ads_pos:Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam_follow_movement.global_transform = lens.global_transform
	
	#bring camera close
	if Input.is_action_pressed("secondary_action"):
		if Input.is_action_just_pressed("secondary_action"):
			cam_sound_player.stream = load("res://player/cam/sounds/camera_going_inv.wav")
			cam_sound_player.set_max_db(RandomNumberGenerator.new().randf_range(-15.0, -13.5))
			cam_sound_player.set_pitch_scale(RandomNumberGenerator.new().randf_range(3, 2))
			cam_sound_player.play()
		transform.origin = transform.origin.lerp(ads_pos, ADS_LERP*delta)
		cam_preview_image_cooldown.start()
	else:
		if Input.is_action_just_released("secondary_action"):
			cam_sound_player.stream = load("res://player/cam/sounds/cam_going_out.wav")
			cam_sound_player.set_max_db(RandomNumberGenerator.new().randf_range(-15.0, -13.5))
			cam_sound_player.set_pitch_scale(2)
			cam_sound_player.play()
		transform.origin = transform.origin.lerp(default_pos, ADS_LERP*delta)
		
	
	
func _input(event):
	if Input.is_action_just_pressed("main_action"):
		if cam_cooldown_timer.is_stopped():
			take_pic()
	

func take_pic():
	cam_cooldown_timer.start()
	cam_flash.light_energy = 4.0
	await get_tree().create_timer(.3).timeout
	cam_flash.light_energy = 0
	await get_tree().create_timer(.2).timeout
	cam_flash.light_energy = 4.0
	
	#wait for flash and take pic, save pic
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	var image:Image = cam_sprite.get_texture().get_image()
	image.flip_x()
	save_img(image)
	
	if !cam_sound_player.is_playing(): 
		 #just to give the sound a litte variety
		cam_sound_player.stream = load("res://player/cam/sounds/camera-shutter.wav")
		cam_sound_player.set_max_db(RandomNumberGenerator.new().randf_range(-3.0, -1.5))
		cam_sound_player.set_pitch_scale(RandomNumberGenerator.new().randf_range(.90, 1.1))
		cam_sound_player.play()
	
	await get_tree().create_timer(.05).timeout
	cam_flash.light_energy = 0
	
	var imagetex = ImageTexture.create_from_image(image)
	set_cam_screen(imagetex)

	
func save_img(cam_img:Image):
	cam_img.save_png("user://imagetest.png") #C:\Users\jared\AppData\Roaming\Godot\app_userdata\Acerola Game Jam
	
func set_cam_screen(cam_img_tex:ImageTexture):
	var og_material = cam_sprite_Screen.get_texture()
	
	cam_sprite_Screen.set_texture(cam_img_tex)
	cam_sprite_Screen.get_window()
	cam_preview_image_cooldown.start()
	

func _on_cam_preview_image_cooldown_timeout():
	cam_sprite_Screen.set_texture(ImageTexture.create_from_image(load("res://player/cam/black.png")))
