extends StaticBody3D

var door_open:bool = false
var interactable:bool = true
@onready var animation_plr:AnimationPlayer = $"../../AnimationPlayer"

func use():
	if not animation_plr.is_playing():
		door_open = !door_open
		
		if not door_open:
			animation_plr.play("close")
		if door_open:
			animation_plr.play("open")
		
