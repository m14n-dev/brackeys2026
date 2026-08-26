@icon("res://port/port.png")
class_name Port
extends Area2D

const PackageScene = preload("res://package/Package.tscn")


signal clicked

@export var online: bool = false:
	set(val):
		online = val
		$Sprite2D.visible = val
		
var server: Server
var connection: Connection
var peer: Port
var path: Path2D
var time_since_last: float = 0

func _ready() -> void:
	$Sprite2D.visible = online
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton 
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit()

func _process(delta) -> void:
	time_since_last += delta
	if online && time_since_last >= connection.interval && server.power >= 1.0:
		try_spawn_package()
		time_since_last = 0

func try_spawn_package():
	if server.lockdown || peer.server.lockdown :
		return
	
	var consume = floor(min(server.power, connection.max_package_size))
	server.power -= consume

	var package: Package = PackageScene.instantiate()
	package.power = consume
	package.color = server.color
	package.speed_px_per_sec = connection.package_speed_px_per_sec
	package.dest = peer.server
	package.player_owned = server.player_owned

	path.add_child(package)
