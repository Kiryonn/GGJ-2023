class_name Puzzle3Tile
extends Area2D


signal TileClicked(id)


export (Texture) var image

func _input_event(_viewport, event, _shape_idx):
	if not(event is InputEventMouseButton):
		return
	if not(event.button_index == BUTTON_LEFT):
		return
	if  event.pressed:
		emit_signal("TileClicked", self)
		





func _on_Sprite_ready():
	$Sprite.texture = image
