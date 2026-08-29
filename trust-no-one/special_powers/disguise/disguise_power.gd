extends BasePower

var color_swatch_prefab: PackedScene = load("res://special_powers/disguise/color_swatch/color_swatch.tscn")
var color_swatch_instance: ColorSwatch  = null

var targeted_server: Server = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.server_clicked.connect(on_server_clicked)

func _process(delta: float) -> void:
	super(delta)
	if(current_state == State.cooldown && targeted_server != null): #We haven't done cleanup yet
		targeted_server.update_faction_color()
		targeted_server = null

func on_server_clicked(source: Server):
	if(currently_selected && source.player_owned):
		targeted_server = source
		
		color_swatch_instance = color_swatch_prefab.instantiate()
		color_swatch_instance.global_position = source.global_position
		
		var arena : Arena = get_tree().current_scene.get_node("Arena")
		arena.add_child(color_swatch_instance)
		color_swatch_instance.display_factions(arena.get_all_factions())
		color_swatch_instance.color_selected.connect(on_color_selected)

func on_color_selected(color:Color):
	activate()
	
	if(color_swatch_instance != null):
		color_swatch_instance.queue_free()
	
	targeted_server.color = color
	
	unselect()

func unselect():
	super()
	#TODO: delete swatch if exists
	

func get_eligible_servers() -> Array[Server]:
	var res: Array[Server]
	res.assign(get_tree().get_nodes_in_group("server_0"))
	return res
