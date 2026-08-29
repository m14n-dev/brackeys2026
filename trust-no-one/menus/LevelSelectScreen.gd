extends Node2D

var mainMenu = load("res://menus/TitleScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_packed(mainMenu)


func _on_lvl_1_button_pressed():
	get_tree().change_scene_to_file("res://arena/arena_1/arena_1.tscn")

func _on_lvl_2_button_pressed():
	get_tree().change_scene_to_file("res://arena/arena_2/arena_2.tscn")

func _on_lvl_3_button_pressed():
	get_tree().change_scene_to_file("res://arena/arena_3/Arena3.tscn")

func _on_lvl_4_button_pressed():
	get_tree().change_scene_to_file("res://arena/arena_4/Arena4.tscn")

func _on_lvl_5_button_pressed():
	get_tree().change_scene_to_file("res://arena/arena_5/Arena5.tscn")


func _on_lvl_1_button_mouse_entered():
	pass # Replace with function body.
