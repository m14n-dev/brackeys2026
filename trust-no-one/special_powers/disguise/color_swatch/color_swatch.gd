extends Node2D
class_name  ColorSwatch

signal color_selected(Color)

var color_container: HBoxContainer
var color_prefab: PackedScene = preload("res://special_powers/disguise/color_swatch/color_button.tscn")

func _ready() -> void:
	color_container = $ColorContainer

func display_factions(factions: Array[Faction]):
	for faction in factions:
		var new_color: Button = color_prefab.instantiate()
		$ColorContainer.add_child(new_color)
		var color_display: ColorRect = new_color.get_node("foreground")
		color_display.color = faction.color
		new_color.pressed.connect(func(): click_color(faction.color))

func click_color(color: Color):
	color_selected.emit(color)
