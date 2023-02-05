extends Node2D


var niv=1
export (Array, Resource) var scenes
var instance
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	instance = scenes[0].instance()
	index += 1
	
	add_child(instance)
	instance.connect("finished",self,"asEnd")


func asEnd():
	instance.queue_free()
	if index >= len(scenes):
		return
	instance = scenes[index].instance()
	index += 1
	add_child(instance)
	instance.connect("finished",self,"asEnd")
