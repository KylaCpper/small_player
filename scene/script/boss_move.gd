extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const WALK_SPEED = 30
var velocity = Vector2()
var direction="left"
var Monster
var Player
var Overall
func _ready():
	# Called every time the node is added to the scene.
	Overall=get_node("/root/overall")
	Player=Overall.GetPlayer()
	var monster=get_node("/root/config").GetConfig("Monsters")
	Monster=Overall.GetSetMonster(monster.boss)
	get_node("Area2D").connect("area_enter",self,"_on_receive_hurt")
	get_node("arm").connect("body_enter",get_parent().get_parent().get_node("player"),"_on_hunt_player",["boss"])
	set_fixed_process(true)

	pass
var die=0
func _on_receive_hurt(obj):
	if(obj.get_name()=="area2d arm"):
		if(die):return
		var hp_sub=Player.atk-Monster.def
		if(hp_sub<0):hp_sub=0
		Monster.hp-=hp_sub
		var str_be=tr("hurt")+tr(Monster.name)+tr("hp")+str(hp_sub)
		Overall.MsgSend(self,str_be)
		if(Monster.hp<0):
			die=1
			Monster.hp=0
			get_tree().call_group(0,"boss","clear_monster",1)
			get_tree().call_group(0,"player","monster_die",Monster)
			get_tree().call_group(0,"player","player_lv_up")
		get_tree().call_group(0,"boss","set_monster_hp",Monster.hp)

func _fixed_process(delta):
	velocity.x = 0
	velocity.y = 0
	var player_pos=get_parent().get_parent().get_node("player").get_pos()
	var my_pos=get_pos()
	var act=0
	if(player_pos.y<my_pos.y-30):
		velocity.y = -WALK_SPEED
		direction="up"
	elif(player_pos.y>my_pos.y+60):
		velocity.y = WALK_SPEED
		direction="down"
	else:
		act+=1
	if(player_pos.x<my_pos.x-35):
		velocity.x = -WALK_SPEED
		direction="left"
		get_node("body").set_flip_h(true)
	elif(player_pos.x>my_pos.x+60):
		velocity.x = WALK_SPEED
		direction="right"
		get_node("body").set_flip_h(false)
	else:
		act+=1
	if(act==2):
		start_ani()
	var motion = velocity * delta
	move(motion)
	
	
func start_ani():
	if (get_node("hurt").is_playing()):
		return
	get_node("hurt").play("hurt_"+direction)
	pass
