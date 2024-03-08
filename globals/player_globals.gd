extends Node

var all_images:Array

var start_time

# dictates how long a player must 
var player_death_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = Time.get_datetime_dict_from_system() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
