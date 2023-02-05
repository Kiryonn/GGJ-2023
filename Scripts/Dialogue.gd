class_name Dialogue
extends Node2D

signal finished

export (Resource) var Character
export (Array, Resource) var actions = []
var index = 0
var is_waiting_for_click = false
var is_waiting_for_time = false
var showed = {}
var entered = {}


func _ready():
	$Timer.connect("timeout", self, "stopWaiting")


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
			enter(data.name, data.image, data.scale, data.pos, data.is_flipped)
		"leave":
			leave(data.name)
		"show":
			showImage(data.name, data.image, data.scale, data.pos, data.is_flipped)
		"hide":
			hideImage(data["name"])
		"wait":
			waitForTime(data.time)
		"anim":
			match data.animation:
				"hurt": entered[data].hurt()
				"jump": entered[data].jump()
				"die": entered[data].die()

func talk(name: String, message: String):
	$ColorRect/Text.text = "[b]{name}[/b]\n\t{message}".format(name, message)
	is_waiting_for_click = true

func enter(name: String, image: Texture, imageScale: Vector2, imagePos: Vector2, is_flipped: bool):
	var character = Character.instance()
	character.name = name
	character.texture = image
	character.scale = imageScale
	character.position = imagePos
	character.flip_h = is_flipped
	add_child(character)
	move_child(character, $ColorRect.get_index())
	entered[name] = character

func leave(name: String):
	if entered.has(name):
		entered[name].queue_free()
		entered.erase(name)

func showImage(name: String, image: Texture, imageScale: Vector2, imagePos: Vector2, is_flipped: bool):
	var sprite = Sprite.new()
	sprite.name = name
	sprite.texture = image
	sprite.scale = imageScale
	sprite.position = imagePos
	sprite.flip_h = is_flipped
	add_child(sprite)
	move_child(sprite, $ColorRect.get_index())
	showed[name] = sprite

func hideImage(name: String):
	if showed.has(name):
		showed[name].queue_free()
		showed.erase(name)

func waitForTime(time):
	is_waiting_for_time = true
	$Timer.set_wait_time(3)
	$Timer.set_one_shot(true)
	$Timer.start()

func stopWaiting():
	is_waiting_for_time = false
