extends Node3D

#@onready var cam = get_node("player_cam/CameraFLash")
@onready var cam_vp:SubViewport          = get_node("player_cam/SubViewport")
@onready var cam_flash:SpotLight3D     = get_node("player_cam/CameraFLash")
@onready var cam_screen:MeshInstance3D = get_node("player_cam/MeshInstance3D")
@onready var cam_sprite:Sprite3D = get_node("player_cam/Sprite3D")
@onready var cam_sprite_Screen:Sprite3D = get_node("player_cam/spriteScreen")
@onready var cam_follow_movement:Node3D = get_node("player_cam/SubViewport/ROOT")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam_follow_movement.global_transform = global_transform
	
func _input(event):
	if Input.is_action_just_pressed("main_action"):
		take_pic()

func take_pic():
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
	
	await get_tree().create_timer(.05).timeout
	cam_flash.light_energy = 0
	
	var imagetex = ImageTexture.create_from_image(image)
	set_cam_screen(imagetex)

	
func save_img(cam_img:Image):
	cam_img.save_png("user://imagetest.png") #C:\Users\jared\AppData\Roaming\Godot\app_userdata\Acerola Game Jam
	
func set_cam_screen(cam_img_tex:ImageTexture):
	#var og_material = cam_screen.mesh.surface_get_material(0)
	#cam_screen.mesh.surface_set_material(0, cam_img_tex)
	var og_material = cam_sprite_Screen.get_texture()
	cam_sprite_Screen.set_texture(cam_img_tex)
	await get_tree().create_timer(3).timeout
	
	cam_sprite_Screen.set_texture(ImageTexture.create_from_image(load("res://player/black.png")))
