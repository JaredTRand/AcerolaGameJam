extends Control
@onready var aberritions_imaged := $HBoxContainer/GridContainer/GridContainer/aberritions_imaged
@onready var amt_and_total := $HBoxContainer/GridContainer/GridContainer/amt_and_total
@onready var points := $HBoxContainer/GridContainer/GridContainer/points

# Called when the node enters the scene tree for the first time.
func _ready():
	aberritions_imaged.text = PlayerGlobals.text_to_display["Aberrations_imaged"]["title"]
	
	var amt = PlayerGlobals.text_to_display["Aberrations_imaged"]["amount"]
	var total = PlayerGlobals.text_to_display["Aberrations_imaged"]["total_abs"]
	amt_and_total.text = str(amt) + "/" + str(total)
	
	points.text =  "$" + str(PlayerGlobals.text_to_display["Aberrations_imaged"]["abs_img_score"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
