extends Node3D

@export var default_pos:Vector3
@export var default_rot:Quaternion
@export var ads_pos:Vector3
@export var ads_rot:Quaternion

const ADS_LERP:int = 10

@onready var audio_player:AudioStreamPlayer3D = $flashlight/AudioStreamPlayer3D

#@onready var current_rot = Quaternion(transform.basis).normalized()
@onready var smoothrot = default_rot

@onready var turn_flash_timer:Timer = $turn_on_flash
var flashlight_active:bool = false

@onready var bulb:SpotLight3D = $flashlight/SpotLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("flashlight"):
		play_sound([3, 4], [1, 2])
		if flashlight_active:
			flashlight_active = false
			smoothrot = smoothrot.slerp(default_rot, ADS_LERP).normalized()
		else:
			flashlight_active = true
			smoothrot = smoothrot.slerp(ads_rot, ADS_LERP).normalized()
	
	#CHANGE ROTATION
	if flashlight_active and self.quaternion != ads_rot:
		self.quaternion = self.quaternion.slerp(ads_rot, ADS_LERP * delta)
		bulb.light_energy = 2
	elif not flashlight_active and self.quaternion != default_rot:
		self.quaternion = self.quaternion.slerp(default_rot, ADS_LERP * delta)
		bulb.light_energy = 0
		
	#change POSITION
	if flashlight_active and transform.origin != ads_pos:
		transform.origin = transform.origin.lerp(ads_pos, ADS_LERP*delta)
	elif not flashlight_active and transform.origin != default_pos:
		transform.origin = transform.origin.lerp(default_pos, ADS_LERP*delta)
		
		
func play_sound(max_db_rng:Array, pitch_rng:Array, skip_wait_for_done:bool = false):
	if skip_wait_for_done or !audio_player.is_playing(): 
		 #just to give the sound a litte variety
		audio_player.set_max_db(RandomNumberGenerator.new().randf_range(max_db_rng[0], max_db_rng[1]))
		audio_player.set_pitch_scale(RandomNumberGenerator.new().randf_range(pitch_rng[0], pitch_rng[1]))
		audio_player.play()


func break_light():
	bulb.light_energy = 0
	# play sparky 
	#play noise
	#start relight up timer

func _on_relight_timer_timeout():
	bulb.light_energy = 2
