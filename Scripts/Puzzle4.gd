class_name Puzzle4
extends Node2D
# this will be an hanoi tower

signal puzzle

export (Texture) var image
export (Resource) var Tile
export (int) var nb_disks = 7

var selected = null
var poleSelected = null
var initPosition = Vector2.ZERO
var entered = null
var disks = [[], [], []]

func _ready():
	$Pole1.connect("area_entered", self, "on_area_enter", [$Pole1])
	$Pole2.connect("area_entered", self, "on_area_enter", [$Pole2])
	$Pole3.connect("area_entered", self, "on_area_enter", [$Pole3])
	$Pole1.connect("area_exited", self, "on_area_leave", [$Pole1])
	$Pole2.connect("area_exited", self, "on_area_leave", [$Pole2])
	$Pole3.connect("area_exited", self, "on_area_leave", [$Pole3])
	var x = $Pole1.position.x
	for i in range(nb_disks):
		var tile = Tile.instance()
		tile.image = image
		var sprite = tile.get_node("Sprite")
		sprite.vframes = nb_disks
		sprite.frame = nb_disks - i - 1
		var y = 100 + (nb_disks - i) * 305 / nb_disks
		tile.position = Vector2(x, y)
		add_child(tile)
		disks[0].append(tile)
		tile.connect("TileClicked", self, "on_click")


func on_click(id):
	for pole in disks:
		if len(pole) > 0 and id == pole[-1]:
			selected = id
			initPosition = id.position
			return


func _input(event):
	if not event is InputEventMouseButton:
		return
	if event.is_pressed():
		return
	if selected == null:
		return

	var i = 0
	if entered == null: # reset position
		resetPos()
		return
	else:
		i = entered.get_index()
		if len(disks[i]) > 0:
			if selected == disks[i][-1]:
				resetPos()
				return
			var frame1 = disks[i][-1].get_node("Sprite").frame
			var frame2 = selected.get_node("Sprite").frame
			if frame1 < frame2:
				resetPos()
				return

	# move
	i = entered.get_index()
	var x = entered.position.x
	var y = 100 + (nb_disks - len(disks[i])) * 305 / nb_disks
	selected.position = Vector2(x, y)
	# update
	disks[i].append(disks[poleSelected.get_index()].pop_back())
	# reset
	entered = null
	poleSelected = null
	selected = null
	# victory
	if len(disks[-1]) == nb_disks:
		victory()

func on_area_enter(ent: Area2D, _in: Area2D):
	if ent == selected:
		print("Entered: ", _in)
		entered = _in

func on_area_leave(leaved: Area2D, _out: Area2D):
	if poleSelected == null:
		poleSelected = _out
	if entered == _out:
		print("Left: ", _out)
		entered = null

func _process(delta):
	if selected == null:
		return
	selected.position = get_global_mouse_position()

func resetPos():
	selected.position = initPosition
	entered = null
	poleSelected = null
	selected = null

func victory():
	emit_signal("puzzle")
