extends VisibleOnScreenNotifier3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	print_debug("block is visible on screen:: " + str(self.is_on_screen()))
