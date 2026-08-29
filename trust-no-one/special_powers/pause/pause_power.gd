extends BasePower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.server_clicked.connect(on_server_clicked)

func on_server_clicked(source: Server):
	if(currently_selected):
		activate()
		source.production_pause = true
		source.production_pause_duration = duration
		unselect()

func get_eligible_servers() -> Array[Server]:
	var res: Array[Server]
	res.assign(get_tree().get_nodes_in_group("server"))
	return res
