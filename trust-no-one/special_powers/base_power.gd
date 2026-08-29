class_name BasePower
extends Node2D

@export var button: Button
@export var audio_player: AudioStreamPlayer2D
@export var select_audio: AudioStreamMP3
@export var unselect_audio: AudioStreamMP3

var currently_selected: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(on_this_button_pressed)
	SignalBus.button_pressed.connect(on_any_button_pressed)

func on_this_button_pressed():
	SignalBus.button_pressed.emit(self)
	
	if(!currently_selected):
		select()
		audio_player.stream = select_audio
	else:
		unselect()
		audio_player.stream = unselect_audio
	audio_player.play()

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
