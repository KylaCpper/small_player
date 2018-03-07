extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func open():
	get_node("door/door ani").play("open")
func close():
	get_node("door/door ani").play("close")