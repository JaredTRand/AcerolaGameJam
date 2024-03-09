extends Node3D

@export var default_pos:Vector3
@export var default_rot:Quaternion
@export var ads_pos:Vector3
@export var ads_rot:Quaternion

const ADS_LERP:int = 10
var smoothrot
@onready var current_rot = Quaternion(transform.basis)

@onready var turn_flash_timer:Timer = $turn_on_flash
var flashlight_active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("flashlight"):
		if flashlight_active:
			flashlight_active = false
			smoothrot = current_rot.slerp(ads_rot, ADS_LERP)
		else:
			flashlight_active = true
			smoothrot = current_rot.slerp(default_rot, ADS_LERP)
			
	#transform.basis = Basis(smoothrot)
	if flashlight_active and transform.origin != ads_pos:
		transform.origin = transform.origin.lerp(ads_pos, ADS_LERP*delta)
	elif not flashlight_active and transform.origin != default_pos:
		transform.origin = transform.origin.lerp(default_pos, ADS_LERP*delta)
