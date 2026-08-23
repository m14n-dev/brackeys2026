@tool
extends Node2D

@export var power: float = 0:
	set(val):
		power = val
		$Label.text = str(floor(power))
		
@export var growth: float = 0
@export var color: Color = Color.WHITE:
	set(val):
		color = val
		$Sprite.modulate = color

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		return
	power += growth * delta
