class_name Puzzle2
extends TileMap
# This will be a net puzzle game

export (Vector2) var size

#var tilemap: Array
# Vector2 position: Vector3 (flip_h, flip_v, transpose) 
var way: Dictionary


func _ready():
	createPath()


func createPath():
	randomize()
	# create the first tile
	var first_tile = int(rand_range(0, 3))
	var transpose = first_tile == 0 # first_tile was a straight line
	self.set_cellv(Vector2.ZERO, first_tile, false, false, transpose)
	# loop until we 
#	createTile(Vector2.ZERO)


func createTile(from) -> void:
#	tile 0 = straight bar 
#	tile 1 = corner
#	tile 2 = t shape
	if from == Vector2(size.x-1, size.y-1):
		return
	# the previous tile
	var previous = get_cellv(from)
	var positions = []
	match previous:
		0: # straight line
			positions = posFrom0(from)
		1: # corner
			positions = posFrom1(from)
		2: # t
			positions = posFrom2(from)
	if positions == []:
		return
	for pos in positions:
		var tiles = Array(range(3))
		tiles.shuffle()
		for tile in tiles:
			createTile(pos)


func get_rotations(from: Vector2, to: Vector2) -> Array:
	var rotations: Array
	match get_cellv(to):
		0:
			var transpose = false
			match get_cellv(from):
				0:
					rotations = [[false, false, transpose]]
				1:
					pass
				2:
					pass
		1:
			pass
		2:
			pass
	return rotations


func posFrom0(from: Vector2) -> Array:
	var positions = []
	if is_cell_transposed(from.x, from.y):
		# vertical line
		var pos1 = Vector2(from.x, from.y-1)
		var pos2 = Vector2(from.x, from.y+1)
		if from.y != 0 and get_cellv(pos1) == -1: # top bound
			positions.append(pos1)
		if from.y != size.y - 1 and get_cellv(pos2) == -1: # bot bound
			positions.append(pos2)
	else:
		# horizontal line
		var pos1 = Vector2(from.x-1, from.y)
		var pos2 = Vector2(from.x+1, from.y)
		if from.x != 0 and get_cellv(pos1): # left bound
			positions.append(pos1)
		if from.x != size.x - 1 and get_cellv(pos2): # right bound:
			positions.append(pos2)
	return positions


func posFrom1(from: Vector2) -> Array:
	var positions = []
	if is_cell_x_flipped(from.x, from.y): # -90°
		positions.append()
	return positions


func posFrom2(from: Vector2) -> Array:
	var positions = []
	return positions

func _input(event):
	if not(event is InputEventMouseButton) or \
	not (event.button_index == BUTTON_LEFT) or \
	not (event.pressed):
		return
	var pos = world_to_map(event.position)
	rotateTile(pos)

func rotateTile(pos: Vector2):
	var x = pos.x
	var y = pos.y
	match get_cellv(pos):
		0:
			set_cellv(pos, 0, false, false, not is_cell_transposed(x, y))
		1:
			var flip_h = is_cell_transposed(x, y)
			var transpose = is_cell_y_flipped(x, y)
			var flip_v = not flip_h and not transpose and not is_cell_x_flipped(x, y)
			set_cellv(pos, 1, flip_h, flip_v, transpose)
		2:
			var flip_v = is_cell_x_flipped(x, y) and is_cell_transposed(x, y)
			var flip_h = not(is_cell_x_flipped(x, y) or is_cell_transposed(x, y) or is_cell_y_flipped(x, y))
			var transpose = is_cell_y_flipped(x, y) or flip_h
			set_cellv(pos, 2, flip_h, flip_v, transpose)

class Tile:
	var start: int
	var end: Array
