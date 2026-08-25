extends Area2D

@export var point_a: Server
@export var point_b: Server
@export var interval: float = 1
@export var max_package_size: int = 1
@export var package_speed_px_per_sec: float = 100

const PackageScene = preload("res://package/Package.tscn")


enum State {
	PASSIVE,
	A_TO_B,
	B_TO_A
}

var state: State = State.PASSIVE
var time_since_last: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last += delta
	if time_since_last >= interval and state != State.PASSIVE:
		try_spawn_package()
		
func source() -> Server:
	match state:
		State.A_TO_B: return point_a
		State.B_TO_A: return point_b
		_: return null

func sink() -> Server:
	match state:
		State.A_TO_B: return point_b
		State.B_TO_A: return point_a
		_: return null
		
func try_spawn_package():
	var source = source()
	if source.power >= 1.0:
		var consume = floor(min(source.power, max_package_size))
		source.power -= consume

		var package: Package = PackageScene.instantiate()
		package.power = consume
		package.color = source.color
		package.speed_px_per_sec = package_speed_px_per_sec
		package.dest = sink()
		package.player_owned = source.player_owned

		$Path2D.add_child(package)

		time_since_last = 0
		
		

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
