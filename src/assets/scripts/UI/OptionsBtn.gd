extends Button

onready var optionsMenu = $"../OptionsMenu"

func _on_OptionsBtn_pressed():
	self.disabled = true
	optionsMenu.show()
	pass # Replace with function body.
