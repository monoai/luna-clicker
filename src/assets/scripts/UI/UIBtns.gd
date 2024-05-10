extends Button

onready var optionsMenu = $"../OptionsMenu"
onready var toolsMenu = $"../ToolsPanel"

func _on_OptionsBtn_pressed():
	self.disabled = true
	optionsMenu.show()
	pass # Replace with function body.

func _on_StoreBtn_pressed():
	self.disabled = true
	toolsMenu.show()
	pass # Replace with function body.

func _on_CloseStoreBtn_pressed():
	self.disabled = false
	toolsMenu.hide()
	pass # Replace with function body.
