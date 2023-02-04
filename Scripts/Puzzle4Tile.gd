extends Area2D

export (Texture) var image

signal TileClicked(id)


func _ready():
	pass


func _on_Sprite_ready():
	$Sprite.texture = image
	var scale = 300 / image.get_height()
	$Sprite.scale = Vector2(scale, scale)
	$Hitbox.shape.extents = $Sprite.get_rect().size * scale / 2


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("TileClicked", self)
