extends Node3D

@onready var animation_plr:AnimationPlayer = $"Root Scene/AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_plr.play("mixamo_com")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
