extends Control

# poke counters
var poke : int = 0
var pokeTotal : int = 0
var pps : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func updateLabels():
	$PokeCounter.text = "Poke: " + str(poke)
	$PPSCounter.text = "per second: " + str(pps)

func _on_Luna_clicked():
	Earn(1)
	updateLabels()

func Earn(amount):
	poke += amount
	pokeTotal += amount
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
