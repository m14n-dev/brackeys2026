class_name BasePower
extends Node2D

@export var button: Button

var currently_selected: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(on_this_button_pressed)
	SignalBus.button_pressed.connect(on_any_button_pressed)

func on_this_button_pressed():
	SignalBus.button_pressed.emit(self)
	
	if(!currently_selected):
		select()
	else:
		unselect()

func on_any_button_pressed(source):
	if(source != self && currently_selected):
		unselect()

func select():
	currently_selected = true
	#TODO: animation and such feedback stuff

func unselect():
	currently_selected = false
	button.button_pressed = false;
	#TODO: animation and such feedback stuff
