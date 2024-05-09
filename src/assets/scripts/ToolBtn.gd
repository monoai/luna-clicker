extends Button

onready var price = basePrice
export var basePrice : int
export var amount : int

# Get nodes
onready var game = get_node("/root/Main")
onready var priceTxt = $HBoxContainer/VBoxContainer/Price

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = self.connect("pressed", self, "_on_Button_pressed")
	if(_err):
		push_error("[ERROR] - Button " + self.name + " not connected to a method properly.")
	# this assumes that the save will properly give the amount for each tool
	recalculatePrice()
	pass

func updateLabels():
	priceTxt.text = str(self.price) + " Pokes"

func _on_Button_pressed():
	purchase()

func purchase():
	if(game.pokes >= self.price):
		amount+=1
		game.Spend(price)
		self.price = recalculatePrice()
		updateLabels()

func recalculatePrice():
	var newPrice = self.basePrice*pow(game.priceIncrease, max(0,self.amount))
	return int(newPrice)

func reset():
	self.price = basePrice
	self.amount = 0
	updateLabels()
