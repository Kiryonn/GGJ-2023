extends Node2D


#export (String) var string
#export (int) var nbCart
export (Array, Texture) var images
export (Texture) var back

signal puzzle

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var dico ={}
var id =0
var pairManquante=[]


func cloneList(list):
	var l=[]
	for carte in list:
		
		var clone = carte.duplicate()
		add_child(clone)
		dico[carte]= id
		dico[clone]= id
		pairManquante.append(id)
		id+=1
		clone.connect("CarteClicked", self, "_on_Carte_CarteClicked")
		l.append(carte)
		l.append(clone)
	return l




var list
var timer : Timer

func _ready():
	randomize()
	list = []
	for x in images:
		var newCarte = load("res://Prefabs/Carte.tscn")
		var instance = newCarte.instance()
		instance.back = back
		instance.front = x
		instance.connect("CarteClicked", self, "_on_Carte_CarteClicked")
		add_child(instance)
		list.append(instance)

	
	list=cloneList(list)
	
	print(list.size())
	
	shuffle(list)
	
	
	var x = 200
	var y = 150
	var xl=0
	
	var ligne=4
	
	for j in list:
		j.position = Vector2(x, y)
		if(xl<ligne):
			x+=100
			xl+=1
		if(xl==ligne):
			y+=100
			x=200
			xl=0
			



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func shuffle(list):
	for a in range(3):
		for i in range(len(list) - 1, 0, -1):
			var j = int(rand_range(0, i + 1))
			if j == i:
				continue
			var p =list[i]
			list[i]=list[j]
			list[j]=p


var time =0
var appel = []
var premierCart
var deuxiemCart
var antiSpam=false


func isend(list):
	if len(list)>0:
		return
	else:
		emit_signal("puzzle")



func verifPair(id):
	if(premierCart!= null):
		
		if(dico[id]==dico[premierCart]):
			id.found_pair=true
			premierCart.found_pair=true
			pairManquante.erase(dico[id])
			id=null
			premierCart=id
			isend(pairManquante)
			antiSpam=false
		else:
			deuxiemCart=id
			appel = [premierCart, deuxiemCart]
			premierCart=null
			deuxiemCart=null
			time=0
			
	else:
		premierCart=id
		antiSpam=false

func _on_Carte_CarteClicked(id):
	if(antiSpam):
		id.revert()
		return
	antiSpam = true
	verifPair(id)

func _physics_process(delta):
	if appel != []:
		time += delta
		if(time>0.5):
			appel[0].revert()
			appel[1].revert()
			appel = []
			antiSpam=false
