class_name Dialogue
extends Node2D

signal finished

export (Array, Resource) var actions = []
var index = 0
var is_waiting_for_click = false
var is_waiting_for_time = false
var showed = {}
var entered = {}


func _ready():
	set_physics_process(false)
	yield(get_tree().root.get_child(get_tree().root.get_child_count()-1), "ready")

	set_physics_process(true)
	

func _physics_process(_delta):
	if is_waiting_for_time:
		return
	if index < len(actions):
		execAction(actions[index])
		index += 1
	else:
		emit_signal("finished")

func _input(event):
	if not event is InputEventMouseButton:
		return
	if not event.button_index == BUTTON_LEFT:
		return
	if not event.is_pressed():
		return
	is_waiting_for_click = false

func execAction(action_data):
	var action = action_data.type
	var data = action_data.data
	match action:
		"talk":
			talk(data.name, data.message)
		"enter":
			showImage(data.name, data.image, data.scale, data.pos, data.is_flipped)
		"leave":
			leave(data.name)
		"show":
			showImage(data.name, data.image, data.scale, data.pos, data.is_flipped)
		"hide":
			hideImage(data["name"])
		"wait":
			waitForTime(data.time)
		"hurt":
			pass
		"jump":
			pass
		"die":
			pass

func talk(name: String, message: String):
	is_waiting_for_click = true

func enter(name: String, image: Texture, imageScale: Vector2, imagePos: Vector2, is_flipped: bool):
	var sprite = chargeImage(name, image, imageScale, imagePos, is_flipped)
	entered[name] = sprite

func leave(name: String):
	pass

func showImage(name: String, image: Texture, imageScale: Vector2, imagePos: Vector2, is_flipped: bool):
	var sprite = chargeImage(name, image, imageScale, imagePos, is_flipped)
	showed[name] = sprite

func hideImage(name: String):
	get_node(name).text = "mioau"

func waitForTime(time):
	is_waiting_for_time = true
	$Timer

func chargeImage(name: String, image: Texture, imageScale: Vector2, imagePos: Vector2, is_flipped: bool):
	var sprite = Sprite.new()
	sprite.name = name
	sprite.texture = image
	sprite.scale = imageScale
	sprite.position = imagePos
	sprite.flip_h = is_flipped
	add_child(sprite)
	move_child(sprite, $ColorRect.get_index())
	return sprite
