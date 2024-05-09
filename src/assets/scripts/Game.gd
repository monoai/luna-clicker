extends Control

# poke counters
var pokes = 0
var pokesTotal : int = 0
var pps : float = 0.0

# Additional variables
var pokeTime = 5.0
var priceIncrease = 1.15
var ticks = 0

# Signals
signal update_story(story)

# Tools
onready var tools = {
	"AutoPoke" : $ToolsPanel/VBoxContainer/AutoPoke,
	"AhogeToucher" : $ToolsPanel/VBoxContainer/AhogeToucher
}

# Saving
var save_file = "user://save.knight"

# Called when the node enters the scene tree for the first time.
func _ready():
	# signal connections
	setupSignals()
	
	# check if save exists
	var file = File.new()
	if file.file_exists(save_file):
		loadGame(file)
	else:
		file.close()
		saveGame()
	
	main()

func setupSignals():
	var err = self.connect("update_story", $Story, "_on_update_story")
	if(err):
		$Story.text = "[ERROR] - Story not connected to game"
	err = $OptionsMenu.connect("manual_save", self, "saveGame")
	err = $OptionsMenu.connect("delete_save", self, "deleteSave")

func saveGame():
	print("saving game")
	var file = File.new()
	file.open(save_file, File.WRITE)
	file.store_var(pokes)
	file.store_var(pokesTotal)
	file.store_var(pps)
	for toolObj in tools.values():
		file.store_var(toolObj.amount)
	file.close()

func loadGame(file):
	print("loading game")
	file.open(save_file, File.READ)
	pokes = file.get_var()
	pokesTotal = file.get_var()
	pps = file.get_var()
	for toolObj in tools.values():
		toolObj.amount = file.get_var()
		toolObj.price = toolObj.recalculatePrice()
		toolObj.updateLabels()
	file.close()

func deleteSave():
	print("deleting game")
	pokes = 0
	pokesTotal = 0
	pps = 0.0
	for toolObj in tools.values():
		toolObj.reset()

#func _process(delta):
#	pass

func _on_Ticks_timeout():
	main()
	ticks += 1

func main():
	Earn(pps)
	recalculatePPS()
	updateLabels()
	storyCheck()
	if(ticks % 30 == 0):
		saveGame()

func recalculatePPS():
	pps = 0
	pps += tools["AhogeToucher"].amount*(4.0/pokeTime)
	pps += tools["AutoPoke"].amount*(1.0/pokeTime)

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
