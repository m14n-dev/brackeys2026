extends Node2D

var package_creation_cooldown: float = 0

func _process(delta: float) -> void:
	if(package_creation_cooldown > 0):
		package_creation_cooldown -= delta

func try_play_package_creation():
	if(package_creation_cooldown <= 0):
		$PackageCreationPlayer.play()
		package_creation_cooldown = 0.4
