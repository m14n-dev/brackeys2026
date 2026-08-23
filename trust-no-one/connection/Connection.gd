extends Area2D

@export var point_a: Server
@export var point_b: Server

enum State {
	PASSIVE,
	A_TO_B,
	B_TO_A
}

var state: State = State.PASSIVE
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton 
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggle_state()

func toggle_state():
	match state:
		State.PASSIVE:
			if point_a.player_owned:
				switch_a_to_b()
			elif point_b.player_owned:
				switch_b_to_a()
		State.A_TO_B:
			if point_b.player_owned:
				switch_b_to_a()
			else:
				switch_passive()
		State.B_TO_A:
			switch_passive()

func switch_a_to_b():
	state = State.A_TO_B
	$Sprite2D.modulate = Color.MEDIUM_AQUAMARINE

func switch_b_to_a():
	state = State.B_TO_A
	$Sprite2D.modulate = Color.FIREBRICK

func switch_passive(): 
	state = State.PASSIVE
	$Sprite2D.modulate = Color.WHITE
