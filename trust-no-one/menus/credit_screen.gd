extends Node2D

const TEXT = "HARDLINK WAS BROUGHT TO YOU BY THE M%dN COLLECTIVE

REPRESENTED BY ALDER AND GLYPH




FONT: SIXTYFOUR BY JENS KUTILEK

SOUNDS: FREESOUND.ORG

MUSIC: PURE ATTITUTDE BY KEVIN MACLEOD


THANK YOU FOR PLAYING!"

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	$Label.text = TEXT % [rng.randi_range(12,15)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menus/TitleScreen.tscn")
