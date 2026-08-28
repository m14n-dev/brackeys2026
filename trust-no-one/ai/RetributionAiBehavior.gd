# Does not initiate conflict
# When receiving a hostile package, permanently opens all ports on all servers
# connected to a server of that color
class_name RetributionAiBehavior
extends AiBehavior

# In absence of a set type
var enemy_colors: Dictionary[Color, bool] = {}

func on_any_package_recv(server: Server, package: Package):
	if server.faction_id == faction.id and package.color != faction.color:
		enemy_colors[package.color] = true

func get_active_ports() -> Array[Port]:
	var result: Array[Port] = []
	for port in arena.get_ports_by_faction(faction.id):
		if port.peer.server.color in enemy_colors:
			result.append(port)
	return result
