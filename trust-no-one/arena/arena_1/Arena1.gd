extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Connection/PortA/OnboardingSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_port_a_clicked():
	$Connection/PortA/OnboardingSprite.queue_free()
