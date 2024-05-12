extends Control

# poke counters
var pokes = 0
var pokesTotal = 0
var pps : float = 0.0 # Pokes per Second
var ppc : float = 1.0 # Pokes per Click

# Additional variables
var pokeTime = 5.0
var priceIncrease = 1.15
var ticks = 0
var gameVersion = "0.4.0"

# Signals
signal update_story(story)
signal read_completed

# Tools
onready var tools = {
	"AutoPoke" : $ToolsPanel/ScrollContainer/VBoxContainer/AutoPoke,
	"AhogeToucher" : $ToolsPanel/ScrollContainer/VBoxContainer/AhogeToucher
}

# Effects
var pathand = load("res://assets/objects/patHand.tscn")
var patHandArr : Array

# Saving
var save_file = "user://save.knight"
onready var versionTxt = $Version
var js_callback
var js_interface

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# signal connections
	setupSignals()
	
	# check if save exists
	var file = File.new()
	var err = file.open(save_file, File.READ)
	if err == OK:
		loadGame(file)
	else:
		file.close()
		saveGame()
	
	checkVersion()
	
	main()

func setupSignals():
	var err = self.connect("update_story", $Story, "_on_update_story")
	if(err):
		$Story.text = "[ERROR] - Story not connected to game"
	err = $OptionsMenu.connect("manual_save", self, "saveGame")
	err = $OptionsMenu.connect("delete_save", self, "deleteSave")
	err = $OptionsMenu.connect("import_save", self, "importSave")
	err = $OptionsMenu.connect("export_save", self, "exportSave")

func checkVersion():
	var file = File.new()
	file.open("res://version.tres", File.READ)
	if file.file_exists("res://version.tres"):
		var res = load("res://version.tres")
		print(res.version)
		print(gameVersion)
		if(res.version == gameVersion):
			versionTxt.text = res.version
		else:
			versionTxt.text = "New Version of the game available!"
	else:
		print("[ERROR] - File does not exist...")
		versionTxt.text = "New Version of the game available!"
	file.close()
	

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

func exportSave():
	var file = File.new()
	var err = file.open(save_file, File.READ)
	if(err):
		printerr("[ERROR] Save file does not exist?!")
		return
	var buf = file.get_buffer(file.get_len())
	JavaScript.download_buffer(buf, "save.knight")
	file.close()
	pass

func load_handler(_args):
	#print("TEEEEEEEEEESTTTTTTTTTTTT")
	if(not _args[0] is JavaScriptObject):
		print("Not an object")
		return
	else:
		var fileData = JavaScript.eval("_HTML5FileExchange.result", true) # interface doesn't work as expected for some reason
		print("Datatype: ")
		print(typeof(fileData))
		print(fileData)
		var file = File.new()
		var file_error = file.open(save_file, File.WRITE)
		if(fileData):
			file.store_buffer(fileData)
			file.close()
		
		if file_error != OK:
			print("An error occurred while trying to load the file.")
			return
		
		var err = file.open(save_file, File.READ)
		if err == OK:
			loadGame(file)
		main()
		print("Save Imported")
		

func importSave():
	var js_code = """
		var _HTML5FileExchange = {};
		_HTML5FileExchange.upload = function(gd_callback) {
			var input = document.createElement('INPUT'); 
			input.setAttribute("type", "file");
			input.setAttribute("accept", ".knight");
			input.click();
			input.addEventListener('change', event => {
				// console.log(event.target.files.length);
				if (event.target.files.length == 0) { 
					console.log("Returning as null");
					gd_callback(null) 
				}
				var file = event.target.files[0];
				const reader = new FileReader();
				reader.readAsArrayBuffer(file);
				reader.onload = (evt) => { // Since here's it's arrow function, "this" still refers to _HTML5FileExchange
					if (evt.target.readyState == FileReader.DONE) {
						this.result = evt.target.result;
						console.log("Returning as something");
						gd_callback(this.result); // It's hard to retrieve value from callback argument, so it's just for notification
					}
				}
			  });
		}
	"""
	JavaScript.eval(js_code, true)
	
	js_callback = JavaScript.create_callback(self, "load_handler")
	js_interface = JavaScript.get_interface("_HTML5FileExchange")
	
	print("Importing save")
	js_interface.upload(js_callback)
	pass

func _on_Ticks_timeout():
	main()
	ticks += 1

func main():
	Earn(pps)
	recalculatePPS()
	updateLabels()
	effects()
	storyCheck()
	if(ticks % 30 == 0):
		saveGame()

func recalculatePPS():
	pps = 0
	pps += tools["AhogeToucher"].amount*(4.0/pokeTime)
	pps += tools["AutoPoke"].amount*(1.0/pokeTime)

func effects():
	if(patHandArr.size() < tools["AhogeToucher"].amount):
		while(patHandArr.size() != tools["AhogeToucher"].amount):
			var patHand = pathand.instance()
			$CenterContainer/Luna.add_child(patHand)
			patHand.position = Vector2(rand_range(-184,184),-240)
			patHandArr.append(patHand)
			pass

func updateLabels():
	$PokeCounter.text = "Poke: " + str(int(pokes))
	$PPSCounter.text = "per second: " + str(pps)
	$TotalPokeCounter.text = "Total Pokes: " + str(pokesTotal)

func clickEffects():
	var click = load("res://assets/objects/pokeMsg.tscn")
	var clickInstance = click.instance()
	clickInstance.text = "+" + str(ppc)
	clickInstance.rect_position = get_local_mouse_position()
	add_child(clickInstance)

func storyCheck():
	if(pokesTotal < 50):
		emit_signal("update_story", "Just a normal day in the Candy Kingdom")
	elif(pokesTotal < 500):
		emit_signal("update_story", "The Princess is starting to wonder why you're poking her")
	elif(pokesTotal < 1000):
		emit_signal("update_story", "The Princess is starting to worry... why are you still doing this?")
	elif(pokesTotal < 10000):
		emit_signal("update_story", "You hear mumbling around you. 'Can he actually do that!?' says the others...")
	elif(pokesTotal < 100000):
		emit_signal("update_story", "The other Luknights wants to join you as you see the Princess' face turn red from embarrassment")
	elif(pokesTotal < 1000000):
		emit_signal("update_story", "The Princess should be doing something right now, but you're still alive, maybe you can keep going?")
	elif(pokesTotal < 10000000):
		emit_signal("update_story", "You feel eternal bliss, you think that this is the best day of your life. Finally, freedom to poke cheeks...")
	elif(pokesTotal < 100000000):
		emit_signal("update_story", "The Princess seems to be annoyed a bit, or maybe it's just your imagination?")
	elif(pokesTotal < 1000000000):
		emit_signal("update_story", "No wait... it isn't your imagination, the Princess is slowly getting really REALLY annoyed...")
	else:
		emit_signal("update_story", "You poked too much, the Princess is angry. Someone's going to the Candy Dungeons...")

func _on_Luna_clicked():
	Earn(ppc)
	updateLabels()
	clickEffects()

func Earn(amount):
	pokes += amount
	pokesTotal += amount

func Spend(amount):
	pokes -= amount
