extends Node2D


export (String) var string
export (int) var nbCart
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
		print(carte)
		dico[carte]= id
		dico[clone]= id
		pairManquante.append(id)
		id+=1
		clone.connect("CarteClicked", self, "_on_Carte_CarteClicked")
		l.append(carte)
		l.append(clone)
	return l


func something():
	pass


var list


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



var premierCart
var deuxiemCart


func isend(list):
	if len(list)>0:
		return
	else:
		print("end")
		emit_signal("puzzle1")

func verifPair(id):
	if(premierCart!= null):
		if(deuxiemCart!= null):
			if(dico[deuxiemCart]==dico[premierCart]):
				deuxiemCart.found_pair=true
				premierCart.found_pair=true
				pairManquante.erase(dico[deuxiemCart])
				deuxiemCart=null
				premierCart=id
				isend(pairManquante)
			else:
				deuxiemCart.revert()
				premierCart.revert()
				
				premierCart=id
				deuxiemCart=null
		else:
			deuxiemCart=id
			if(len(pairManquante)==1):
				verifPair(null)
	else:
		premierCart=id

func _on_Carte_CarteClicked(id):
	verifPair(id)
