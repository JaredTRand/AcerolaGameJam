extends Node3D

@export var speed := .005

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(Vector3(0,1,0).normalized(), speed)
	#self.transform.basis = Basis("y", speed) * self.transform.basis
	#self.quaternion = self.quaternion + driving_speed
