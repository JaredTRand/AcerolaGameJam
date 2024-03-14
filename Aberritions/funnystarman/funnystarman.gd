extends StaticBody3D
@export var ab_id = "funnystarman"
@onready var animation_plr:AnimationPlayer = $funnystarman/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_plr.play("Armature|Armature|ArmatureAction")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
