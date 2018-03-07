extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var direction="default"
var move
var  move_texture={
	"default":null,
	"left":null,
	"right":null,
	"up":null,
	"down":null
}
var press=0
var hurt
var shift
func _ready():
	move=get_node("move")
	move_texture.default=preload("res://assets/img/keyboard/move_default.png")
	move_texture.left=preload("res://assets/img/keyboard/move_left.png")
	move_texture.right=preload("res://assets/img/keyboard/move_right.png")
	move_texture.up=preload("res://assets/img/keyboard/move_up.png")
	move_texture.down=preload("res://assets/img/keyboard/move_down.png")
	
	
	get_node("move/left").connect("mouse_enter",self,"_on_move",["left"])
	get_node("move/right").connect("mouse_enter",self,"_on_move",["right"])
	get_node("move/up").connect("mouse_enter",self,"_on_move",["up"])
	get_node("move/down").connect("mouse_enter",self,"_on_move",["down"])
	"""
	get_node("move/left").connect("mouse_exit",self,"_on_move")
	get_node("move/right").connect("mouse_exit",self,"_on_move")
	get_node("move/up").connect("mouse_exit",self,"_on_move")
	get_node("move/down").connect("mouse_exit",self,"_on_move")
	"""
	

	hurt=get_node("hurt")
	shift=get_node("shift")
	get_node("i").connect("pressed",self,"_on_i_press")
	set_process_input(true)
	set_process(true)
	pass
func get_direction():
	return direction
func _process(delta):
	if(direction!="default"&&press):
		move.set_texture(move_texture[direction])
	if(hurt.is_pressed()):
		hurt_press()
	else:
		hurt_release()
	if(shift.is_pressed()):
		shift_press()
	else:
		shift_release()

	pass
func _input(event):
	
	if(event.type==InputEvent.SCREEN_TOUCH):
		press=1
	if(event.is_action_released("mouse_left")):
		if(direction!="default"):
			action_released()
		press=0
		
	pass
func _on_move(direction="default"):
	if(self.direction!=direction&&press):
		if(self.direction=="default"):
			self.direction=direction
			action_pressed()
		else:
			Input.action_release("move_"+self.direction)
			self.direction=direction
			action_pressed()

func action_pressed():
	move.set_texture(move_texture[direction])
	if(direction!="default"):
		Input.action_press("move_"+direction)

func action_released():
	Input.action_release("move_"+direction)
	direction="default"
	move.set_texture(move_texture[direction])
var shift_pressed=0
func shift_press():
	if(!shift_pressed):
		shift_pressed=1
		Input.action_press("shift")
	pass
func shift_release():
	if(shift_pressed):
		shift_pressed=0
		Input.action_release("shift")
	pass


var hurt_pressed=0
func hurt_press():
	if(!hurt_pressed):
		hurt_pressed=1
		Input.action_press("hurt")
	pass
func hurt_release():
	if(hurt_pressed):
		hurt_pressed=0
		Input.action_release("hurt")
	pass


func _on_i_press():
	var ev = InputEvent()
	ev.set_as_action("information", true)
	Input.parse_input_event(ev)
	get_node("i").set_pressed (0)
	pass


