extends Node3D
@onready var dialogue = load("res://Dialogue/end_level_selectPics.dialogue")
@onready var fadetoblack = $Camera3D/fadeToBlack/AnimationPlayer
@onready var dialoguetimer = $dialogue_start_timer
@onready var endtimer = $sceneendtimer
@onready var ringring = $ringring

func _unhandled_input(event):
	if Input.is_action_just_pressed("submit_pics"):
		PlayerGlobals.calculate_score()
		fadetoblack.play("fade_to_black")

# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
	fadetoblack.play("fade_in")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		dialoguetimer.start()
	elif anim_name == "fade_to_black":
		endtimer.wait_time = dialoguetimer.wait_time
		endtimer.start()

func _on_dialogue_start_timer_timeout():
	ringring.play()
	
func _on_ringring_finished():
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	
#func _on_dialogue_manager_dialogue_ended(resource: DialogueResource):
	#fadetoblack.play("fade_to_black")

func _on_sceneendtimer_timeout():
	get_tree().change_scene_to_file("res://End_Level/end_level_driving.tscn")
