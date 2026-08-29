extends Node2D

const CREDITS = preload("res://menus/CreditScreen.tscn")
const LEVELS = preload("res://menus/LevelSelectScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_select_button_pressed():
	get_tree().change_scene_to_packed(LEVELS)

func _on_credits_button_pressed():
	get_tree().change_scene_to_packed(CREDITS)


func _on_shut_down_button_pressed():
	get_tree().quit()
