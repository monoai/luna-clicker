extends Button

export var toolName : String
export var toolDesc : String
onready var price = basePrice
export var basePrice : int
export var amount : int

# Get nodes
onready var game = get_node("/root/Main")
onready var nameTxt = $PanelContainer/HBoxContainer/VBoxContainer/Name
onready var descTxt = $PanelContainer/HBoxContainer/VBoxContainer/Description
onready var priceTxt = $PanelContainer/HBoxContainer/VBoxContainer/Price
onready var amountTxt = $PanelContainer/Amount

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = self.connect("pressed", self, "_on_Button_pressed")
	if(_err):
		push_error("[ERROR] - Button " + self.name + " not connected to a method properly.")
	nameTxt.text = toolName
	descTxt.text = toolDesc
	pass

func updateLabels():
	# print(priceTxt)
	# var priceTxt = $PanelContainer/HBoxContainer/VBoxContainer/Price
	priceTxt.text = str(self.price) + " Pokes"
	amountTxt.text = str(self.amount)

func _on_Button_pressed():
	purchase()

func purchase():
	if(game.pokes >= self.price):
		amount+=1
		game.Spend(price)
		game.updateLabels()
		self.price = recalculatePrice()
		updateLabels()

func recalculatePrice():
	var newPrice = self.basePrice*pow(game.priceIncrease, max(0,self.amount))
	return int(newPrice)

func reset():
	self.price = basePrice
	self.amount = 0
	updateLabels()
