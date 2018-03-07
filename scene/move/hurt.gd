extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("input_event",self,"aaa")
	pass

func aaa(event):
	set_text(str(event))