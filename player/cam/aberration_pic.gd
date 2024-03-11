extends Resource
class_name Aberration_Image

@export var ab_image:Image
var starred:bool # to prevent accidental deletion in game
var to_submit:bool # to mark which ones to submit at end of level

var prev_img:Aberration_Image
var next_img:Aberration_Image

var aberrations_pictured:Array
