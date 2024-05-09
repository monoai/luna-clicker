extends Control

# poke counters
var poke = 0
var pokeTotal : int = 0
var pps : float = 0.0

# Additional variables
var pokeTime = 5.0

# Tools
onready var tools = {
	$ToolsPanel/VBoxContainer/AutoPoke : { 
		"Name" : "AutoPoke",
		"Price" : 50,
		"Amount" : 0
	},
	$ToolsPanel/VBoxContainer/AhogeToucher : { 
		"Name" : "AhogeToucher",
		"Price" : 200,
		"Amount" : 0
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	main()

#func _process(delta):
#	pass

func _on_Ticks_timeout():
	main()

func main():
	Earn(pps)
	recalculatePPS()
	updateLabels()

func recalculatePPS():
	pps = 0
	pps += tools[$ToolsPanel/VBoxContainer/AhogeToucher]["Amount"]*(4.0/pokeTime)
	pps += tools[$ToolsPanel/VBoxContainer/AutoPoke]["Amount"]*(1.0/pokeTime)

func updateLabels():
	$PokeCounter.text = "Poke: " + str(int(poke))
	$PPSCounter.text = "per second: " + str(pps)

func _on_Luna_clicked():
	Earn(1)
	updateLabels()

func Earn(amount):
	poke += amount
	pokeTotal += amount

func Spend(amount):
	poke -= amount

func _on_upgButton_pressed(button):
	if(poke >= tools[button]["Price"]):
		Spend(tools[button]["Price"])
		tools[button]["Amount"] += 1
		updateLabels()
	print(button.name)
	print(tools[button]["Price"])
	pass
