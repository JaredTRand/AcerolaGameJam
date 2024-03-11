extends Node3D

var noise_fading_in = false 

@export ab_noise

func _ready():
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#is there a good way to determine if this can be skipped so it doesnt do this tween every frame? or is it necessary rn
	if noise_fading_in:
		pass #tween audio louder
	else:
		pass #tween audio quieter

func fade_up_noise():
	noise_fading_in = true

func fade_out_noise():
	noise_fading_in = false
