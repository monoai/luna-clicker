extends Button

signal upgrade(button)

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err
	_err = self.connect("pressed", self, "_on_Button_pressed")
	_err = self.connect("upgrade", get_tree().get_root().get_node("Main"), "_on_upgButton_pressed")
	if(_err):
		push_error("[ERROR] - Buttons not connected to a method properly.")
	pass
	
func _on_Button_pressed():
	emit_signal("upgrade", self)
