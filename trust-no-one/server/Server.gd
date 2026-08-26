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

var lockdown: bool = false # Powers can lock down servers, preventing them from sending/receiving packages
var production_pause: bool = false # Powers can stop production temporarily
var production_increase: bool = false # Powers can boost production temporarily

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		return
	
	if !production_pause:
		var production_multiplier: float = 2 if production_increase else 1
		power += growth * production_multiplier * delta
	
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
