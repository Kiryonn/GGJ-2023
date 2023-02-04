class_name Carte
extends Area2D

signal CarteClicked(id)

export (Texture) var back
export (Texture) var front

var is_flipped = false
var found_pair = false


func _input_event(_viewport, event, _shape_idx):
	if not(event is InputEventMouseButton):
		return
	if not(event.button_index == BUTTON_LEFT):
		return
	if event.pressed == true and not found_pair and active:
		flip()
		emit_signal("CarteClicked", self)
		
		

var active=true

func flip():
	active=false
	var sprite = $Sprite
	if is_flipped:
		sprite.texture = back
	else:
		sprite.texture = front
	sprite.scale = Vector2(float(64)/sprite.texture.get_width(), float(64)/sprite.texture.get_height())
	is_flipped = not is_flipped

func revert():
	active=true
	var sprite = $Sprite
	if is_flipped:
		sprite.texture = back
	else:
		sprite.texture = front
	sprite.scale = Vector2(float(64)/sprite.texture.get_width(), float(64)/sprite.texture.get_height())
	is_flipped = not is_flipped

func _on_Sprite_ready():
	$Sprite.texture = back
