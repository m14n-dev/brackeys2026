class_name EnemyAi extends Faction

@export var behavior: AiBehavior = AiBehavior.new()

func collect_game_state() -> Array[FactionGameState]:
	var result: Array[FactionGameState] = []
	var arena: Arena = $"../Arena"
	for faction in arena.get_all_factions():
		var state = FactionGameState.new()
		state.id = faction.id
		var servers = arena.get_servers_by_faction(faction.id)
		state.servers = servers
		var packages = arena.get_packages_by_faction(faction.id)
		state.packages = packages
		for server in servers:
			state.total_power += server.power
		for package in packages:
			state.total_power += package.power
		result.append(state)
	return result


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.ready.connect(on_scene_ready)
	
func on_scene_ready():
	behavior._init_from_gamestate($"../Arena".get_faction_by_id(id), $"../Arena", collect_game_state())
	for server in get_tree().get_nodes_in_group("server"):
		server.on_package_recv.connect(behavior.on_any_package_recv)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	behavior.update_from_gamestate(collect_game_state())
	var active_ports = behavior.get_active_ports()
	for port in get_tree().get_nodes_in_group("port"):
		if (port as Port).server.faction_id == id:	
			if port in active_ports:
				port.online = true
			else:
				port.online = false
