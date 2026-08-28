class_name AiBehavior extends Resource

var faction: Faction
var arena: Arena

func _init_from_gamestate(faction: Faction, arena: Arena, state: Array[FactionGameState]):
	self.faction = faction
	self.arena = arena
	pass

func update_from_gamestate(state: Array[FactionGameState]):
	pass
	
func on_any_package_recv(server: Server, package: Package):
	pass
	
func get_active_ports() -> Array[Port]:
	return []
