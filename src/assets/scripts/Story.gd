extends Label

onready var game = get_node("/root/Main")

# Called when the node enters the scene tree for the first time.
func _ready():
	var err = game.connect("update_story", self, "_on_update_story")
	if(err):
		self.text = "[ERROR] - Story not connected to game"
	pass # Replace with function body.

func _on_update_story(story):
	self.text = story
	pass
