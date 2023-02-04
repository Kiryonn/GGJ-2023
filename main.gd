extends Node2D


export (Array, Resource) var scenes
var index = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = scenes[index].instance()
	add_child(instance)
	instance.connect("puzzle", self, "asEnd")

func instantiate():
	var instance

func asEnd():
	pass
