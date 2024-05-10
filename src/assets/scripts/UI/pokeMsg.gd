extends Label

var seconds = 1
var speed = 4
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rect_position.y -= speed
	speed -= delta*3
	counter += delta
	if counter >= seconds:
		queue_free()
	pass
