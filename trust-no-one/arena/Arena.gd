@tool
class_name Arena
extends Node2D

@export var next_level: PackedScene

var is_game_over: bool = false
var is_game_won: bool = false
var game_over_time: float = 0

var game_over_label_text = "ERROR: 
NO RESPONSE
FROM [::1] 
FOR %d SECONDS"

var victory_sound_player: AudioStreamPlayer2D
var lose_sound_player: AudioStreamPlayer2D

func _ready() -> void:
	victory_sound_player = $Sounds/VictorySoundPlayer
	lose_sound_player = $Sounds/LoseSoundPlayer

func _process(delta):
	if Engine.is_editor_hint():
		return
		
	if is_game_over:
		game_over_time += delta
		$GameOverLabel.text = game_over_label_text % [game_over_time]
	elif is_game_won:
		return
	elif get_servers_by_faction(0).size() == 0:
		$GameOverLabel.visible = true
		$GameOverMenus.visible = true
		is_game_over = true
		lose_sound_player.play()
	elif is_all_enemies_gone():
		$GameWonLabel.visible = true
		$GameWonMenus.visible = true
		is_game_won = true
		victory_sound_player.play()
	
func is_all_enemies_gone():
	for faction in get_all_factions():
		if faction.id == 0:
			continue
		if get_servers_by_faction(faction.id).size() != 0:
			return false
	return true

func get_all_factions() -> Array[Faction]:
	var result: Array[Faction] = []
	for child in get_parent().get_children():
		if child is Faction:
			result.append(child)
	return result

func get_faction_by_id(id: int) -> Faction:
	for child in get_parent().get_children():
		if child is Faction and (child as Faction).id == id:
			return child
	return null
	
func get_faction_by_color(color: Color) -> Faction:
	for child in get_parent().get_children():
		if child is Faction and (child as Faction).color == color:
			return child
	return null
	
func get_servers_by_faction(id: int) -> Array[Server]:
	var result: Array[Server] = []
	for node in get_tree().get_nodes_in_group("server_%d" % [id]):
		if node is Server:
			result.append(node as Server)
	return result

func get_servers_by_color(color: Color) -> Array[Server]:
	var result: Array[Server] = []
	for server in get_tree().get_nodes_in_group("server"):
		if (server as Server).color == color:
			result.append(server as Server)
	return result
	
func get_packages_by_faction(id: int) -> Array[Package]:
	var result: Array[Package] = []
	for node in get_tree().get_nodes_in_group("package_%d" % [id]):
		if node is Package:
			result.append(node as Package)
	return result
	
func get_ports_by_faction(id: int) -> Array[Port]:
	var result: Array[Port] = []
	for port in get_tree().get_nodes_in_group("port"):
		if port is Port and (port as Port).server.faction_id == id:
			result.append(port as Port)
	return result

func collect_game_state() -> GameState:
	var state = GameState.new()
	for node in get_tree().get_nodes_in_group("server"):
		var server: Server = node as Server
		
		if server.color not in state.by_color:
			state.by_color[server.color] = GameStateSummary.new()
		state.by_color[server.color].servers.append(server)
		state.by_color[server.color].total_power += server.power
		
		if server.faction_id not in state.by_id:
			state.by_id[server.faction_id] = GameStateSummary.new()
		state.by_id[server.faction_id].servers.append(server)
		state.by_id[server.faction_id].total_power += server.power
	
	for node in get_tree().get_nodes_in_group("package"):
		var pkg: Package = node as Package
		
		if pkg.color not in state.by_color:
			state.by_color[pkg.color] = GameStateSummary.new()
		state.by_color[pkg.color].packages.append(pkg)
		state.by_color[pkg.color].total_power += pkg.power
		
		if pkg.faction not in state.by_id:
			state.by_id[pkg.faction] = GameStateSummary.new()
		state.by_id[pkg.faction].packages.append(pkg)
		state.by_id[pkg.faction].total_power += pkg.power
		
	return state


func _on_retry_button_pressed():
	get_tree().reload_current_scene()


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://menus/LevelSelectScreen.tscn")


func _on_next_button_pressed():
	if next_level != null:
		get_tree().change_scene_to_packed(next_level)
	else:
		get_tree().change_scene_to_file("res://menus/CreditScreen.tscn")
