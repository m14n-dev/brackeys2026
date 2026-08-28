class_name Package
extends PathFollow2D

var power: int = 0
var color: Color = Color.WHITE:
	set(val):
		color = val
		$Sprite2D.modulate = color
var faction: int = 0
var speed_px_per_sec: float = 0
var dest: Server
var player_owned: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("package")
	add_to_group("package_%d")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += speed_px_per_sec * delta;
	if progress_ratio >= 1.0:
		dest.recv_package(self)
		queue_free()
