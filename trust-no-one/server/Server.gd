@tool
@icon("res://server/sprite.png")
class_name Server
extends Node2D


@export var power: float = 0:
	set(val):
		power = val
		$Label.text = "%.1f" % power
		
@export var growth: float = 0
@export var color: Color = Color.WHITE:
	set(val):
		color = val
		$Sprite.modulate = color
		
@export var player_owned: bool = false

var ports: Array[Port] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		return
	power += growth * delta
	
func add_port(port: Port):
	self.ports.append(port)
	
func recv_package(package: Package):
	if package.color == self.color:
		self.power += package.power
	else:
		self.power -= package.power
		if self.power < 0:
			self.power = -self.power
			self.color = package.color
			self.player_owned = package.player_owned
			for port in self.ports:
				port.online = false
