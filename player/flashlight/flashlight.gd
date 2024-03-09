extends Node3D

@export var default_pos:Vector3
@export var ads_pos:Vector3
const ADS_LERP:int = 10

@onready var turn_flash_timer:Timer = $turn_on_flash

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("flashlight"):
		print_debug("falshlight")
		#if transform.origin == default_pos:
		transform.origin = transform.origin.lerp(ads_pos, ADS_LERP*delta)
		
		#elif transform.origin == ads_pos:
			#transform.origin = transform.origin.lerp(default_pos, ADS_LERP*delta)
