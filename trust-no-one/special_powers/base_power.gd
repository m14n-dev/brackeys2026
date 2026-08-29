class_name BasePower
extends Node2D

var current_state: State = State.ready:
	set(val):
		current_state = val
		if(current_state == State.ready):
			progress_bar.value = 100
			button.disabled = false
		else:
			button.disabled = true

var state_remaining_duration: float = 0
var is_usable:
	get: return current_state == State.ready

@export var duration: float = 5

@export var cooldown: float = 5

@export var select_audio: AudioStreamMP3
@export var unselect_audio: AudioStreamMP3

var currently_selected: bool = false;

var button: TextureButton
var progress_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button = $Button
	progress_bar = $Button/ProgressBar
	button.pressed.connect(on_this_button_pressed)
	SignalBus.button_pressed.connect(on_any_button_pressed)
	current_state = State.ready

func _process(delta: float) -> void:
	if(current_state == State.in_use):
		state_remaining_duration -= delta
		progress_bar.value = state_remaining_duration / duration * 100
		if(state_remaining_duration <= 0):
			current_state = State.cooldown
			state_remaining_duration = cooldown
	if(current_state == State.cooldown):
		state_remaining_duration -= delta
		progress_bar.value = (cooldown - state_remaining_duration) / cooldown * 100
		if(state_remaining_duration <= 0):
			current_state = State.ready

func on_this_button_pressed():
	SignalBus.button_pressed.emit(self)
	
	if(!currently_selected):
		if(is_usable):
			select()
			$AudioStreamPlayer2D.stream = select_audio
	else:
		unselect()
		$AudioStreamPlayer2D.stream = unselect_audio
	$AudioStreamPlayer2D.play()

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

func activate():
	state_remaining_duration = duration
	current_state = State.in_use

enum State {
	ready,
	cooldown,
	in_use
}
