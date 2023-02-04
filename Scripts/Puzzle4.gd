class_name Puzzle4
extends Node2D
# this will be an hanoi tower

signal puzzle

export (Texture) var image
export (int) var nb_disks = 7


func _ready():
	for i in range(nb_disks):
		var sprite = Sprite.new()
		sprite.texture = image
		sprite.vframes = nb_disks
		sprite.frame = i
		sprite.position = Vector2()
		
		add_child(sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
