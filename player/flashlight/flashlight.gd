extends Node3D

@export var default_pos:Vector3
@export var default_rot:Quaternion
@export var ads_pos:Vector3
@export var ads_rot:Quaternion

const ADS_LERP:int = 10

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
		if flashlight_active:
			flashlight_active = false
			smoothrot = smoothrot.slerp(ads_rot, ADS_LERP).normalized()
		else:
			flashlight_active = true
			smoothrot = smoothrot.slerp(default_rot, ADS_LERP).normalized()
			
	if flashlight_active && self.quaternion != ads_rot:
		self.quaternion = self.quaternion.slerp(ads_rot, ADS_LERP * delta)
		bulb.light_energy = 2
	elif not flashlight_active and self.quaternion!= default_rot:
		self.quaternion = self.quaternion.slerp(default_rot, ADS_LERP * delta)
		bulb.light_energy = 0
		
		
	if flashlight_active and transform.origin != ads_pos:
		transform.origin = transform.origin.lerp(ads_pos, ADS_LERP*delta)
	elif not flashlight_active and transform.origin != default_pos:
		transform.origin = transform.origin.lerp(default_pos, ADS_LERP*delta)
