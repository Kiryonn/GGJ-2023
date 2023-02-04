class_name Puzzle2
extends TileMap
# This will be a net puzzle game

export (Vector2) var size

var tilemap: Array
# Vector2 position: Vector3 (flip_h, flip_v, transpose) 
var way: Dictionary


func _ready():
	# instantiate tilemap
	tilemap = []
	for i in range(size.x):
		tilemap.append([])
		for j in range(size.y):
			tilemap[-1].append(-1)
	createPath()


func createPath():
	randomize()
	var first_tile = int(rand_range(0, 3))
	var transpose = first_tile == 0 # first_tile was a straight line
	self.set_cellv(Vector2(0, 0), first_tile, false, false, transpose)
	
#	createTile(Vector2.ZERO)


func createTile(from):
#	tile 0 = straight bar 
#	tile 1 = corner
#	tile 2 = t shape
	if from == size - 1:
		return
	var previous = tilemap[from.x][from.y]
	var positions = []
	match previous:
		0: # straight line
			positions = posFrom0(from)
		1: # corner
			positions = posFrom1(from)
		2: # t
			pass



func posFrom0(from):
	var positions = []
	if is_cell_transposed(from.x, from.y):
		# vertical line
		if from.y != 0: # top bound
			positions.append(Vector2(from.x, from.y-1))
		if from.y != size.y - 1: # bot bound
			positions.appen(Vector2(from.x, from.y+1))
	else:
		# horizontal line
		if from.x != 0: # left bound
			positions.append(Vector2(from.x-1, from.y))
		if from.x != size.x - 1: # right bound:
			positions.append(Vector2(from.x+1, from.y))
	return positions

func posFrom1(from):
	var positions = []
	if is_cell_x_flipped(from.x, from.y): # -90°
		positions.append()


func _input(event):
	if not(event is InputEventMouseButton) or \
	not (event.button_index == BUTTON_LEFT) or \
	not (event.pressed):
		return
	var pos = world_to_map(event.position)
	print(pos, ": ", get_cell(pos.x, pos.y))
