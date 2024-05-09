extends Control

# poke counters
var pokes = 0
var pokesTotal : int = 0
var pps : float = 0.0

# Additional variables
var pokeTime = 5.0
var priceIncrease = 1.15

# Signals
signal update_story(story)

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
	storyCheck()

func recalculatePPS():
	pps = 0
	pps += $ToolsPanel/VBoxContainer/AhogeToucher.amount*(4.0/pokeTime)
	pps += $ToolsPanel/VBoxContainer/AutoPoke.amount*(1.0/pokeTime)

func updateLabels():
	$PokeCounter.text = "Poke: " + str(int(pokes))
	$PPSCounter.text = "per second: " + str(pps)

func storyCheck():
	if(pokes < 50):
		emit_signal("update_story", "Just a normal day in the Candy Kingdom")
	elif(pokes < 100):
		emit_signal("update_story", "The Princess is starting to wonder why you're poking her")

func _on_Luna_clicked():
	Earn(1)
	updateLabels()

func Earn(amount):
	pokes += amount
	pokesTotal += amount

func Spend(amount):
	pokes -= amount

#func _on_upgButton_pressed(button):
#	if(poke >= tools[button]["Price"]):
#		Spend(tools[button]["Price"])
#		tools[button]["Amount"] += 1
#		updateLabels()
#	print(button.name)
#	print(tools[button]["Price"])
#	pass
