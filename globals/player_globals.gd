extends Node

var all_images:Array
var start_time
var cash:int
var aberritions_in_scene:int

## level end vars ##
var text_to_display
#####################

# dictates how long a player can be in the danger zone 
#maybe should make actual timer node somewhere?
@onready var player_death_timer = Timer.new()
#signal player_death_timer_timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	set_death_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_death_timer():
	player_death_timer.wait_time = 1.0
	player_death_timer.one_shot = true
	#player_death_timer.connect("timeout", self, "_on_player_death_timer_timeout")

func _on_player_death_timer_timeout():
	pass
	# emit_signal death signal to player
	#maybe instead of the listener here, can connect on the player?

func calculate_score():
	var final_score
	var starting_time = Time.get_unix_time_from_datetime_dict(start_time)
	var end_time   = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
	var total_time = Time.get_datetime_dict_from_unix_time (end_time - start_time)
	
	var count_images = 0
	var images_wo_ab:Array
	var aberrations_pictured:Array
	
	var all_aberrations = get_tree().get_nodes_in_group("Aberration")
	
	for image:Aberration_Image in all_images:
		# only submit starred pics
		if not image.to_submit: continue
		
		count_images += 1
		
		# If image has no aberration, will need to subtract
		if image.aberrations_pictured.size() == 0:
			images_wo_ab.append(image)
			continue
		
		for abberation in image.aberrations_pictured:
			if abberation not in aberrations_pictured:
				aberrations_pictured.append(abberation)
	
	print_debug(str(count_images) + " images submitted")
	print_debug("Images without abs:  " + str(images_wo_ab.size()))
	print_debug("abs Pictured " + str(aberrations_pictured.size()) + " out of total " + str(all_aberrations.size()) )
	print_debug("Time Elapsed: " + str(total_time.get("minute")) + "mins, " + str(total_time.get("second")) + " secs")

	var abs_img_score = 500 * aberrations_pictured.size()
	var missed_abs = (all_aberrations.size() - aberrations_pictured.size())
	var miss_abs_penalty = 20 * missed_abs
	var blank_img_penalty = 10 * images_wo_ab.size()
	var time_bonus = 1000 - ( (total_time.get("minute") * 60) + total_time.get("second") )
	
	final_score = abs_img_score - miss_abs_penalty - blank_img_penalty
	
	if miss_abs_penalty > 0:
		time_bonus = 0
	cash += final_score

	print_debug("bonus of $" + str(time_bonus))
	print_debug("you got $" + str(final_score))

	## set all text to display #################################################################################################################################################
	text_to_display["Aberrations_imaged"] = {"title":"Aberrations Pictured", "amount":aberrations_pictured.size(), "total_abs":all_aberrations.size(), "points":abs_img_score}
	text_to_display["Aberrations_missed"] = {"title":"Aberrations Missed", "amount":missed_abs, "penalty":miss_abs_penalty}
	text_to_display["Blank_images"]	      = {"title":"Images Submitted Without Aberration", "amount":images_wo_ab.size(), "penalty":blank_img_penalty }
	text_to_display["Time_elapsed"]	      = {"title":"Time Elapsed", "minutes":total_time.get("minute"), "seconds":total_time.get("second"), "bonus_gotten":time_bonus > 0, "bonus_amount":time_bonus}
	############################################################################################################################################################################

	return final_score
