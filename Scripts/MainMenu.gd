extends Node2D

signal finished

func _ready():
	pass # Replace with function body.


func _on_Play_pressed():
	emit_signal("finished")


func _on_Exit_pressed():
	get_tree().quit()
