extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const WALK_SPEED = 30
var velocity = Vector2()
var direction="left"
var Monster
var Overall
var Player
#Overall.MsgSend(self,"对%s造成%s伤害" %[monsters[tscn_name].name,str(hp_sub)])
var monster_night=["monster0_1","monster1_1","monster2_1"]
func _ready():
	Overall=get_node("/root/overall")
	Player=Overall.GetPlayer()
	var monster=get_node("/root/config").GetConfig("Monsters")
	var night=get_parent().night
	Monster=Overall.GetSetMonster(monster[monster_night[night]])
	var texture=Overall.GetTexture()
	var texture_name=monster[monster_night[night]].texture
	get_node("body").set_texture(texture[texture_name])
	get_node("arm").connect("body_enter",get_parent().get_parent().get_node("player"),"_on_hunt_player",["monster0_1"])
	get_node("area").connect("area_enter",self,"_on_receive_hurt")
	set_fixed_process(true)

	add_to_group("monster")
	set_monster_hp_cap(Monster.hp)
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
			clear_monster()
			get_tree().call_group(0,"player","monster_die",Monster)
			get_tree().call_group(0,"player","player_lv_up")
			get_tree().call_group(0,"monsters","monster_die")
		set_monster_hp(Monster.hp)

func _fixed_process(delta):
	velocity.x = 0
	velocity.y = 0
	var player_pos=get_parent().get_parent().get_node("player").get_pos()
	var my_pos=get_pos()
	var act=0
	if(player_pos.y<my_pos.y-20):
		velocity.y = -WALK_SPEED
		direction="up"
	elif(player_pos.y>my_pos.y+40):
		velocity.y = WALK_SPEED
		direction="down"
	else:
		act+=1
	if(player_pos.x<my_pos.x-20):
		velocity.x = -WALK_SPEED
		direction="left"
		get_node("body").set_flip_h(true)
	elif(player_pos.x>my_pos.x+30):
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

func clear_monster():
	queue_free()
	pass

func set_monster_hp(hp):
	get_node("hp bar").set_value(hp)
	pass
func set_monster_hp_cap(hp_cap):
	get_node("hp bar").set_max(hp_cap)
	set_monster_hp(hp_cap)
	pass

	