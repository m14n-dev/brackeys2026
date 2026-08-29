# Prioritizes defending own servers, then attacking strong and fast-growing factions,
# but only with the necessary amount of support
class_name SmartAiBehavior
extends AiBehavior

const power_factor = 0.05
const growth_factor = 1
var enmity: Dictionary[Color, float] = {}
var power_scaled_enmity: Dictionary[Color, float] = {}

func on_any_package_recv(server: Server, package: Package):
	if server.color == faction.color and package.color != faction.color:
		if package.color not in enmity:
			enmity[package.color] = 0
		enmity[package.color] += package.power
		
func update_from_gamestate(state: GameState):
	for color in state.by_color:
		if color == faction.color:
			continue
		if color not in enmity:
			enmity[color] = 0
		var total_power = state.by_color[color].total_power
		var total_growth = 0
		for server in state.by_color[color].servers:
			total_growth += server.growth
		power_scaled_enmity[color] = enmity[color] + (total_power * power_factor) + (total_growth * growth_factor)

func get_load_on_link(port: Port, seen: Dictionary[Server, bool]) -> float:
	var load = port.server.growth
	var num_active_outgoing = 0
	
	seen[port.server] = true
	for other_port in port.server.ports:
		if other_port.online:
			num_active_outgoing += 1
		if other_port.peer.server.color == port.server.color and other_port.peer.server not in seen and other_port.peer.online:
			load += get_load_on_link(other_port.peer, seen)
	
	var per_link_load = load / max(num_active_outgoing, 1)
	return min(per_link_load, port.connection.max_package_size / port.connection.interval)
	
func get_capacity_of_server(server: Server) -> float:
	var capacity = server.growth
	
	for port in server.ports:
		if port.peer.server.color == server.color and port.peer.online:
			capacity += get_load_on_link(port.peer, {})
	return capacity

func servers_under_attack() -> Dictionary[Server, float]:
	var result: Dictionary[Server, float] = {}
	for server in arena.get_servers_by_color(faction.color):
		for port in server.ports:
			if port.peer.online and port.peer.server.color != faction.color:
				if server not in result:
					result[server] = 0
				result[server] += get_load_on_link(port.peer, {})
				break
	return result

class NodeTree:
	var capacity: float
	var ports: Array[Port]
	var assigned_servers: Dictionary[Server, bool]
	
	static func from(capacity: float, ports: Array[Port], assigned_servers: Dictionary[Server, bool]) -> NodeTree:
		var result = NodeTree.new()
		result.capacity = capacity
		result.ports = ports
		result.assigned_servers = assigned_servers
		return result

# This has a bunch of issues, like not observing link limits and not supporting split routing,
# but it'll do
func build_node_tree(target: Server, to_capacity: float, assigned: Dictionary[Server, bool]) -> NodeTree:
	var newly_assigned: Dictionary[Server, bool]
	var closed: Array[Port] = []
	var open: Array[Port] = []
	var capacity = 0
	
	for port in target.ports:
		if port.peer.server.faction_id != faction.id:
			continue
		if port.peer.server in assigned or port.peer.server in newly_assigned:
			continue
		open.append(port.peer)
		
	while open.size() != 0 and to_capacity > capacity:
		var current = open.pop_front()
		if current.server in assigned or current.server in newly_assigned:
			continue
			
		closed.append(current)
		newly_assigned[current.server] = true
		capacity += current.server.growth
		
		for port in current.server.ports:
			if port.peer.server.faction_id != faction.id:
				continue
			if port.peer.server in assigned or port.peer.server in newly_assigned:
				continue
			open.append(port.peer)
	
	return NodeTree.from(capacity, closed, newly_assigned)

	
func ranked_enemy_servers() -> Array[Server]:
	var sorter = func(server_a, server_b):
		return power_scaled_enmity[server_a.color] > power_scaled_enmity[server_b.color]
	var servers: Array[Server] = []
	for node in arena.get_tree().get_nodes_in_group("server"):
		if node is not Server:
			continue
		var server = node as Server
		if server.color == faction.color:
			continue
		for port in server.ports:
			if port.peer.server.faction_id == faction.id:
				servers.append(server)
				break
	servers.sort_custom(sorter)
	return servers
			 
func get_active_ports() -> Array[Port]:
	var assignments: Dictionary[Server, bool] = {}
	var ports: Array[Port] = []
	
	print("----- ", faction.id, " -----")
	var under_attack = servers_under_attack()
	for server in under_attack:
		print("Server under attack: ", server)
		var node_tree = build_node_tree(server, under_attack[server], assignments)
		if node_tree.capacity >= under_attack[server]:
			assignments.merge(node_tree.assigned_servers)
			ports.append_array(node_tree.ports)
			
	for server in ranked_enemy_servers():
		print("Targetting server: ", server)
		var target_cap = get_capacity_of_server(server) + 1
		var node_tree = build_node_tree(server, target_cap, assignments)
		if node_tree.capacity >= target_cap:
			print("Target capacity ", target_cap, " reached with ", node_tree.assigned_servers)
			assignments.merge(node_tree.assigned_servers)
			ports.append_array(node_tree.ports)
		else:
			print("Target capacity not reached")
	
	return ports
