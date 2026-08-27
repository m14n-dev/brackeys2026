extends Node2D

@export var dx: float = 16
@export var dy: float = 8
@export var freq_x: float = 2
@export var freq_y: float = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	var x = dx * sin(time / freq_x)
	var y = dy * sin(time / freq_y)
	self.position = Vector2(x, y)
