extends StaticBody3D

var door_open:bool = false
var interactable:bool = true
@onready var animation_plr:AnimationPlayer = $"../../AnimationPlayer"
@onready var audio_player:AudioStreamPlayer3D = $AudioStreamPlayer3D
func use():
	if not animation_plr.is_playing():
		door_open = !door_open
		
		if not door_open:
			animation_plr.play("close")
			play_sound(load("res://environment/scenes/door/closing.wav"), [0, 1], [1,3])
		if door_open:
			animation_plr.play("open")
			play_sound(load("res://environment/scenes/door/opening.wav"), [0, 1], [1,3])
		
func play_sound(sound, max_db_rng:Array, pitch_rng:Array, skip_wait_for_done:bool = false):
	if skip_wait_for_done or !audio_player.is_playing(): 
		 #just to give the sound a litte variety
		audio_player.stream = sound
		audio_player.set_max_db(RandomNumberGenerator.new().randf_range(max_db_rng[0], max_db_rng[1]))
		audio_player.set_pitch_scale(RandomNumberGenerator.new().randf_range(pitch_rng[0], pitch_rng[1]))
		audio_player.play()
		
