extends Node

var all_images:Array
var start_time
var cash:int
var aberritions_in_scene:int

## level end var ##
var text_to_display
#####################
var initial_player_pos
var player_can_move := false
var player_passout_count:int
var save_path = "user://score.save"
var all_aberrations
#var total_aberrations_pictured:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calculate_score():
	var final_score
	var starting_time = Time.get_unix_time_from_datetime_dict(self.start_time)
	var end_time   = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
	var total_time = Time.get_datetime_dict_from_unix_time(end_time - starting_time)
	
	var count_images = 0
	var images_wo_ab:Array
	var aberrations_pictured:Array
	
	
	for image:Aberration_Image in self.all_images:
		# only submit starred pics
		#if not image.to_submit: continue
		if not image.starred: continue
		
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
	print_debug("abs Pictured " + str(aberrations_pictured.size()) + " out of total " + str(self.all_aberrations.size()) )
	print_debug("Time Elapsed: " + str(total_time.get("minute")) + "mins, " + str(total_time.get("second")) + " secs")

	var abs_img_score = 500 * aberrations_pictured.size()
	var missed_abs = (all_aberrations.size() - aberrations_pictured.size())
	var miss_abs_penalty = 200 * missed_abs
	var blank_img_penalty = 100 * images_wo_ab.size()
	var time_bonus = 500 - ( (total_time.get("minute") * 60) + total_time.get("second") )
	var all_abs_picd_bonus = abs_img_score/2



	var abs_picd:float = float(aberrations_pictured.size())
	var abs_all:float = float(all_aberrations.size())
	var perc_of_abs:float = float(abs_picd / abs_all)
	var perc_range:String
	if perc_of_abs < .25:
		perc_range = "LT25"
	elif perc_of_abs == .25:
		perc_range = "EQ25"
	elif perc_of_abs >.25 and perc_of_abs < .5:
		perc_range = "BT25and50"
	elif perc_of_abs == .5:
		perc_range = "EQ50"
	elif perc_of_abs >.5 and perc_of_abs < .75:
		perc_range = "BT50and75"
	elif perc_of_abs == .75:
		perc_range = "EQ75"
	elif perc_of_abs >.75 and perc_of_abs < 1:
		perc_range = "BT75and100"
	elif perc_of_abs == 1:
		perc_range = "EQ100"
		
	if time_bonus < 0 or perc_of_abs < 1:
		time_bonus = 0
		
	final_score = abs_img_score - (miss_abs_penalty - blank_img_penalty) + (time_bonus + all_abs_picd_bonus)
	save_to_bank(final_score) #save cash
	var cash_in_bank = get_from_bank()
	print_debug("bonus of $" + str(time_bonus))
	print_debug("you got $" + str(final_score))
	## set all text to display #################################################################################################################################################
	text_to_display = {
	"Aberrations_imaged":{"title":"Aberrations Pictured", "amount":aberrations_pictured.size(), "total_abs":all_aberrations.size(), "points":abs_img_score
	},
	"Aberrations_missed":{"title":"Aberrations Missed", "amount":missed_abs, "penalty":miss_abs_penalty
	},
	"Images_submitted":{"Title":"Images Submitted", "amount":count_images
	},
	"Percentages":{"perc_of_abs_picd":perc_of_abs, "perc_range":perc_range
	},
	"Score":{"cash_in_bank":cash_in_bank, "final_total":final_score, "time_bonus":time_bonus, "all_abs_picd_bonus":all_abs_picd_bonus, "time_elapsed_min":total_time.get("minute"), "time_elapsed:sec":total_time.get("second")
	},
	"Blank_images":{"title":"Images Submitted Without Aberration", "amount":images_wo_ab.size(), "penalty":blank_img_penalty
	},
	"Time_elapsed":{"title":"Time Elapsed", "minutes":total_time.get("minute"), "seconds":total_time.get("second"), "bonus_gotten":time_bonus > 0, "bonus_amount":time_bonus
	}
	}
	############################################################################################################################################################################

	return final_score
	
func delete_image(image_to_del:Aberration_Image):
		if image_to_del == null: return
		
		var temp_img:Aberration_Image
		var prev_img:Aberration_Image = image_to_del.prev_img
		var next_img:Aberration_Image = image_to_del.next_img
		
		if next_img != null and prev_img != null: 
			next_img.prev_img = prev_img
			prev_img.next_img = next_img
			temp_img = next_img
		elif next_img != null and prev_img == null:
			next_img.prev_img = null
			temp_img = next_img
		if prev_img != null and next_img == null:
			prev_img.next_img = null
			temp_img = prev_img
			
		self.all_images.remove_at(self.all_images.find(image_to_del))

func save_to_bank(amount:int):
	var current_cash = get_from_bank()
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	current_cash += + amount
	file.store_var(current_cash)
	
func get_from_bank():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		return file.get_var()
	else:
		print("file not found")
		return 0

