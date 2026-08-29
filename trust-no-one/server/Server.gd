@tool
@icon("res://server/sprite.png")
class_name Server
extends Node2D

signal on_package_recv(Server, Package)

@export var power: float = 0:
	set(val):
		power = val
		$Label.text = "%.1f" % power
		
@export var growth: float = 0

		
@export var faction_id: int:
	set(val):
		var old_id: int = faction_id
		
		remove_from_group("server_%d" % [faction_id])
		add_to_group("server_%d" % [val])
		faction_id = val
		update_faction_color()
		
		if(old_id != faction_id):
			if(old_id == 0):
				audioPlayer.stream = enemy_takeover_sound
			elif(faction_id == 0):
				audioPlayer.stream = player_takeover_sound
		audioPlayer.play()


var color: Color = Color.WHITE:
	set(val):
		color = val
		$Sprite.modulate = color

var player_owned: bool: 
	get: 
		return faction_id == 0

var ports: Array[Port] = []
@export var click_area: Area2D

var lockdown: bool = false: # Powers can lock down servers, preventing them from sending/receiving packages
	set(val):
		lockdown = val
		lockdown_sprite.visible = val
var lockdown_duration: float = 0
@export var lockdown_sprite: Sprite2D

var production_pause: bool = false # Powers can stop production temporarily
var production_increase: bool = false # Powers can boost production temporarily

@export var audioPlayer: AudioStreamPlayer2D
@export var receive_package_sound: AudioStreamMP3
@export var player_takeover_sound: AudioStreamMP3
@export var enemy_takeover_sound: AudioStreamMP3

func _get_configuration_warnings():
	var warnings = []
	if $"../Arena" == null:
		warnings.append("Server needs an instanced Arena node as a sibling")
	elif $"../Arena".get_faction_by_id(faction_id) == null:
		warnings.append("Unknown faction %d" % [faction_id])
	return warnings

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.ready.connect(on_scene_ready)
	click_area.input_event.connect(click_input_event)
	add_to_group("server")
	add_to_group("server_%d" % [faction_id])
	
func on_scene_ready():
	update_faction_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		return
	
	if !production_pause:
		var production_multiplier: float = 2 if production_increase else 1
		power += growth * production_multiplier * delta
	
	if(lockdown):
		lockdown_duration -= delta
		if(lockdown_duration <= 0):
			lockdown = false
	
func update_faction_color():
	var arena = $"../Arena"
	if (arena == null):
		return
	var faction = arena.get_faction_by_id(faction_id)
	if (faction != null):
		color = faction.color
	else:
		color = Color.BLACK	

func add_port(port: Port):
	self.ports.append(port)
	
func recv_package(package: Package):
	on_package_recv.emit(self, package)
	
	if package.faction == self.faction_id:
		self.power += package.power
	else:
		self.power -= package.power
		if self.power < 0:
			self.power = -self.power
			self.faction_id = package.faction
			self.color = package.color
			self.player_owned = package.player_owned
			for port in self.ports:
				port.online = false
	# The lines below made the soundscape too busy (Alder's opinion). Can be reactivated if needed.
	# audioPlayer.stream = receive_package_sound
	# audioPlayer.play()

func click_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton 
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			SignalBus.server_clicked.emit(self)
