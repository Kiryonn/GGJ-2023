extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var memorie = load("res://Scenes/Puzzle1.tscn")
	var instance = memorie.instance()
	
	add_child(instance)
	instance.connect("puzzle1",self,"asEnd")



func asEnd():
	print("j'ai compris que ta fini")
