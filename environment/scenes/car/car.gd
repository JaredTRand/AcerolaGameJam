extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func use():
	var start_time = Time.get_unix_time_from_datetime_dict(PlayerGlobals.start_time)
	var end_time   = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
	var total_time = Time.get_datetime_dict_from_unix_time (end_time - start_time)
	
	var count_images = 0
	var images_wo_ab:Array
	var aberrations_pictured:Array
	
	var all_aberrations = get_tree().get_nodes_in_group("Aberration")
	
	for image:Aberration_Image in PlayerGlobals.all_images:
		# only submit starred pics
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
	print_debug("abs Pictured " + str(aberrations_pictured.size()) + " out of total " + str(all_aberrations.size()) )
	print_debug("Time Elapsed: " + str(total_time.get("minute")) + "mins, " + str(total_time.get("second")) + " secs")

	var abs_img_score = 500 * aberrations_pictured.size()
	var miss_abs_penalty = 20 * (all_aberrations.size() - aberrations_pictured.size())
	var blank_img_penalty = 10 * images_wo_ab.size()
	var time_bonus = 1000 - ( (total_time.get("minute") * 60) + total_time.get("second") )
	
	var total_score = abs_img_score - miss_abs_penalty - blank_img_penalty
	
	
	print_debug("you got $" + str(total_score))
	
	if miss_abs_penalty == 0:
		var total_score_w_bonus = total_score + time_bonus
		print_debug("bonus of $" + str(time_bonus))
