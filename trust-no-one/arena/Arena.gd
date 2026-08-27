@tool
extends Node2D

var is_game_over: bool = false
var is_game_won: bool = false
var game_over_time: float = 0

var game_over_label_text = "[>] ERROR: 
NO RESPONSE
FROM [::1] 
FOR %d SECONDS"

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
		is_game_over = true
	elif is_all_enemies_gone():
		$GameWonLabel.visible = true
		is_game_won = true
	
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
		
func get_servers_by_faction(id: int) -> Array[Server]:
	var result: Array[Server] = []
	for child in get_parent().get_children():
		if child is Server and (child as Server).faction_id == id:
			result.append(child)
	return result
