@icon("res://arena_1/connection_1.png")
class_name Connection
extends Node2D

@export var point_a: Server
@export var point_b: Server
@export var interval: float = 1
@export var max_package_size: int = 1
@export var package_speed_px_per_sec: float = 100

@onready var reverse_path: Path2D = mk_reverse_path()

enum State {
	PASSIVE,
	A_TO_B,
	B_TO_A
}

var state: State = State.PASSIVE
var time_since_last: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$PortA.clicked.connect(_try_toggle_a)
	$PortA.server = point_a
	$PortA.connection = self
	$PortA.path = $PathAtoB
	$PortA.peer = $PortB
	point_a.add_port($PortA)
	
	$PortB.clicked.connect(_try_toggle_b)
	$PortB.server = point_b
	$PortB.connection = self
	$PortB.path = reverse_path
	$PortB.peer = $PortA
	point_b.add_port($PortB)	
	
func _try_toggle_a():
	if point_a.player_owned:
		$PortA.online = !$PortA.online
		
func _try_toggle_b():
	if point_b.player_owned:
		$PortB.online = !$PortB.online
		
func mk_reverse_path() -> Path2D:
	var atob_curve: Curve2D = $PathAtoB.curve
	var n = atob_curve.point_count
	
	var path = Path2D.new()
	path.position = $PathAtoB.position + atob_curve.get_point_position(n - 1)
	path.curve = Curve2D.new()
	path.curve.add_point(Vector2(0,0))
	for i in range(n - 1):
		# points constructed in reverse by pointing them backwards from the end point
		var pt = atob_curve.get_point_position(n - i - 2) - atob_curve.get_point_position(n - 1)
		path.curve.add_point(pt)
	
	add_child(path)
	return path
