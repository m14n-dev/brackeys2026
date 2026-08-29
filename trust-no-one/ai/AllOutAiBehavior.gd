# Selects a single target node and builds an as large as possible node tree to support the attack
class_name AllOutAiBehavior
extends AiBehavior

const power_factor = 0.01
var enmity: Dictionary[Color, float] = {}
var power_scaled_enmity: Dictionary[Color, float] = {}

func on_any_package_recv(server: Server, package: Package):
	if server.faction_id == faction.id and package.color != faction.color:
		if package.color not in enmity:
			enmity[package.color] = 0
		enmity[package.color] += package.power
		
func update_from_gamestate(state: GameState):
	for color in state.by_color:
		if color == faction.color:
			continue
		if color not in enmity:
			enmity[color] = 0
		power_scaled_enmity[color] = enmity[color] + (state.by_color[color].total_power * power_factor)

func build_node_tree(target: Server) -> Array[Port]:
	var assigned: Dictionary[Server, bool] = {}
	var closed: Array[Port] = []
	var open: Array[Port] = []
	
	for port in target.ports:
		if port.peer.server.faction_id != faction.id:
			continue
		open.append(port.peer)
		assigned[port.peer.server] = true
		
	while open.size() != 0:
		var current = open.pop_front()
		closed.append(current)
		
		for port in current.server.ports:
			if port.peer.server.faction_id != faction.id:
				continue
			if port.peer.server in assigned:
				continue
			open.append(port.peer)
			assigned[port.peer.server] = true
	
	return closed
	
func colors_by_enmity() -> Array[Color]:
	var colors: Array[Color] = power_scaled_enmity.keys().duplicate()
	var sorter = func (a, b):
		return power_scaled_enmity[a] > power_scaled_enmity[b]
	colors.sort_custom(sorter)
	return colors
	
func get_next_target_server():
	for color in colors_by_enmity():
		for server in arena.get_servers_by_color(color):
			for port in server.ports:
				if port.peer.server.faction_id == faction.id:
					return server
	return null
			 
func get_active_ports() -> Array[Port]:
	var server = get_next_target_server()
	if server == null:
		return []
	return build_node_tree(server)
