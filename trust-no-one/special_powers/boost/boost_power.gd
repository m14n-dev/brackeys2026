extends BasePower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.server_clicked.connect(on_server_clicked)

func on_server_clicked(source: Server):
	if(currently_selected):
		activate()
		source.production_increase = true
		source.production_increase_duration = duration
		unselect()
