extends Node2D

export (Vector2) var cut
export (Texture) var image
export (Resource) var Tile

signal finished

var positions = {}
var case = {}
var caseVide 
var caseValide=[]


var win=false
var start=false
var x 
var y

func _ready():
	randomize()
	x=int(cut.x)
	y=int(cut.y)
	for i in range(cut.x * cut.y):
		var instance = Tile.instance()
		instance.image = image
		var sprite = instance.get_node("Sprite") as Sprite
		sprite.hframes = cut.x
		sprite.vframes = cut.y
		sprite.frame = i
		var x = 100 + (i % int(cut.x)) * 65
		var y = 100 + i / int(cut.y) * 65
		instance.position = Vector2(x, y)
		instance.scale = Vector2(float(64)/image.get_width(), float(64)/image.get_height()) * 4
		add_child(instance)
		instance.get_node("Hitbox").shape.extents = sprite.get_rect().size / 2
		instance.connect("TileClicked", self, "on_click")
		positions[instance] = i
		case[i]=instance
		positions
	
	caseVide=x*y-1
	case[caseVide].visible=false
	Validecase()
	print(caseValide)
	melange()
	start=true


func changeFrame(i,n):
	var sprite = case[i].get_node("Sprite") as Sprite
	sprite.hframes = cut.x
	sprite.vframes = cut.y
	sprite.frame=n



func Validecase():
	var l=[]
	if(caseVide>(x-1)):
		l.append(caseVide-x)
	if(caseVide%x!=0):
		l.append(caseVide-1)
	if(caseVide%x!=(x-1)):
		l.append(caseVide+1)
	if(caseVide<y*(x-1)):
		l.append(caseVide+x)
	caseValide=l


func melange():
	for x in range(100):
		actionCase(case[caseValide[rand_range(0,len(caseValide))]])



func actionCase(id):
	if(positions[id] in caseValide):
		print(caseValide)
		case[caseVide].visible=true
		id.visible=false

		changeFrame(caseVide,id.get_node("Sprite").frame)
		caseVide=positions[id]
		Validecase()
		isWin()
#	print(caseValide, " / ", positions[id])


func on_click(id):
	if(win):
		return
	print(positions[id])
	actionCase(id)

func isWin():
	if(start!=true):
		return
	if(caseVide != x*y-1):
#		print("la case vide est ",caseVide)
		return
	for i in range(x*y-1):
		if(case[i].get_node("Sprite").frame!=i):
			print("la case est pas bonne",i)
			return
	case[caseVide].visible=true
	changeFrame(caseVide,x*y-1)
	caseVide=[]
	win=true
	emit_signal("finished")
	
	
