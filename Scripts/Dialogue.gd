extends Node2D

signal finished

export (Array, Resource) var talks = []
var index = 0

func _ready():
	firstLoad(talks[0])

func _input(event):
	if not event is InputEventMouseButton:
		return
	if not event.button_index == BUTTON_LEFT:
		return
	if not event.is_pressed():
		return
	next()


func firstLoad(data: DialogueRes):
	$ColorRect/Name.text = data.name
	$ColorRect/Text.text = data.text
	var sprite = Sprite.new()
	sprite.name = data.name
	sprite.texture = data.image
	add_child_below_node($ColorRect, sprite)
	var action : Action
	for i in range(len(data.actions)):
		action = data.actions[i]

func execAction(action, data):
	match action:
		"show":
			pass
		"come":
			pass
		"leave":
			pass
		"hurt":
			pass
		"jump":
			pass
		"die":
			pass

func next():
	if index >= len(talks):
		emit_signal("finished")
		return
	talks[index]
	
	index += 1
