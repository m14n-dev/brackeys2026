extends BasePower

@export var duration: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.server_clicked.connect(on_server_clicked)

func on_server_clicked(source: Server):
	if(currently_selected):
		source.lockdown = true
		source.lockdown_duration = duration
		unselect()
