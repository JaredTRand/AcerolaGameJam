extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		if visible:
			hide()
		else:
			show()
		

#func _on_button_pressed():
	#hide()
	#get_tree().paused = false
#
#
#
#func _on_button_resume_button_down():
	#hide()
	#get_tree().paused = false
