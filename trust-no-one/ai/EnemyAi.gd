class_name EnemyAi extends Faction

@export var behavior: AiBehavior = AiBehavior.new()

# Lockout in seconds at the beginning of a level before starting to run ai behavior, to give players
# some time to orient themselves
@export var levelStartLockout: float = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.ready.connect(on_scene_ready)
	
func on_scene_ready():
	behavior._init_from_gamestate($"../Arena".get_faction_by_id(id), $"../Arena", $"../Arena".collect_game_state())
	for server in get_tree().get_nodes_in_group("server"):
		server.on_package_recv.connect(behavior.on_any_package_recv)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if levelStartLockout > 0:
		levelStartLockout -= delta
		return
		
	behavior.update_from_gamestate($"../Arena".collect_game_state())
	var active_ports = behavior.get_active_ports()
	for port in get_tree().get_nodes_in_group("port"):
		if (port as Port).server.faction_id == id:	
			if port in active_ports:
				port.online = true
			else:
				port.online = false
