extends Node

var all_images:Array
var start_time
var cash:int

var aberritions_in_scene:int


# dictates how long a player can be in the danger zone 
@onready var player_death_timer = Timer.new()
signal player_death_timer_timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	set_death_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_death_timer():
	player_death_timer.wait_time = 1.0
	player_death_timer.one_shot = true
	player_death_timer.connect("timeout", self, "_on_player_death_timer_timeout")

func _on_player_death_timer_timeout():
	# emit_signal death signal to player
