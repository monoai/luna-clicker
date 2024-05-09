extends Panel

onready var optionsBtn = $"../OptionsBtn"
onready var game = get_node("/root/Main")

signal manual_save
signal delete_save

func _on_CloseOptionsBtn_pressed():
	optionsBtn.disabled = false
	self.hide()
	pass # Replace with function body.

func _on_Save_pressed():
	emit_signal("manual_save")
	pass # Replace with function body.

func _on_DeleteSave_pressed():
	emit_signal("delete_save")
	pass # Replace with function body.
