extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const GRAVITY = 200.0 
const WALK_SPEED = 80
var enter_player=false
var Player
var Monster={
	"monster0":null,
	"monster1":null,
	"monster2":null,
	"boss":null

}
var Monster_tscn={
	"monster0":null,
	"monster1":null,
	"monster2":null
}
var velocity = Vector2()
var Overall
var auto_act=0
func _ready():
	Overall=get_node("/root/overall")
	var monster=get_node("/root/config").GetConfig("Monsters")
	Player=Overall.GetPlayer()
	Monster.monster0=Overall.GetSetMonster(monster.monster0)
	Monster.monster1=Overall.GetSetMonster(monster.monster1)
	Monster.monster2=Overall.GetSetMonster(monster.monster2)
	Monster.boss=Overall.GetSetMonster(monster.boss)
	# Called every time the node is added to the scene.
	# Initialization here
	#AnimationPlayer.ANIMATION_PROCESS_FIXED=1
	#print(aniStr)
	#connect("input_event",get_node("AnimationPlayer"),start_ani)
	#get_node("AnimationPlayer").connect("",self,"input_event")
	get_tree().call_group(0,"save_control","_on_ready",self.get_name())
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if(event.is_action_pressed("information")):
		get_tree().call_group(0,"information","display")
	pass

func _fixed_process(delta): 
	#velocity.y += delta * GRAVITY
	velocity.x = 0
	velocity.y = 0
	var walk_speed=WALK_SPEED
	var move_act="move"
	if (Input.is_action_pressed("hurt")):
		if(Player.act==0):
			start_ani("ban",Player.direction)
			Overall.MsgSend(self,tr("weak state.can not atk.buy potion"))
		else:
			start_ani("hurt",Player.direction)
	if(Input.is_action_pressed("shift")):
		walk_speed+=walk_speed
		move_act="run"
	if (Input.is_action_pressed("move_left")):
		get_node("body/arm").set_z(-1)
		velocity.x = -walk_speed
		start_ani_move("left",move_act)
	elif (Input.is_action_pressed("move_right")):
		get_node("body/arm").set_z(-1)
		velocity.x =  walk_speed
		start_ani_move("right",move_act)
	elif (Input.is_action_pressed("move_up")):
		get_node("body/arm").set_z(0)
		velocity.y =  -walk_speed
		start_ani_move("up",move_act)
	elif (Input.is_action_pressed("move_down")):
		get_node("body/arm").set_z(-1)
		velocity.y =  walk_speed
		start_ani_move("down",move_act)

	#print(delta)
	var motion = velocity * delta
	move( motion )  
	"""
	var space_state = get_world_2d().get_direct_space_state()
	var pos_be=get_pos()

	#var space_state = get_node("CollisionShape2D").get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray( Vector2(pos_be.x,pos_be.y),Vector2(pos_be.x-1000,pos_be.y) ,[self] )
	if(!result.empty()):
		 get_tree().call_group(0, "text", "text_ture",str(result.position))
	"""
	#animationplayer.play(".:region_recWt")
	#stop()
	#if (is_colliding()):
	    #var n = get_collision_normal()
	    #motion = n.slide( motion ) 
	    #velocity = n.slide( velocity )
	    #move( motion )
	    #get_node("../Label").set_text(str(motion))
	    #get_node("../Label1").set_text(str(velocity))


func property_business(property,data,money=0,monster=0):
	if(Player.money<money):
		Overall.MsgSend(self,tr("not enough money"))
		get_tree().call_group(0,"sound","misc","ban",true)
		if(monster):
			get_tree().call_group(0,"build_monsters","auto_monster_stop")
		return
	Player.money-=money
	var property_translation=get_node("/root/config").GetConfig("Property")
	var monsters=get_node("/root/config").GetConfig("Monsters")
	if(!monster):
		Player[property]+=data
		if(money):
			buy(money,property_translation[property])
		else:
			if(property=="hp"&&data==1):
				Overall.MsgSend(self,tr("seven seconds of hp"))
	else:
		if(money):
			buy(money,monsters[property].name)
	if(property=="lv"):
		Player.lv_up()
		Player.lv-=1
		get_tree().call_group(0,"sound","misc","lv_up")
		Overall.MsgSend(self,tr("lv up_"))
		Overall.MsgSend(self,tr("hp limit increased 3.atk increased 0.5"))
	if(property=="hp"):
		if(Player.hp>=Player.hp_cap):
			Player.hp=Player.hp_cap
		if(Player.hp>0):Player.act=1
	get_tree().call_group(0, "information", "information_update")

func _on_monster_init(monster_name,tscn_name,money):
	if(Player.money<money):
		Overall.MsgSend(self,tr("not enough money"))
		get_tree().call_group(0,"sound","misc","ban",true)
		get_tree().call_group(0, "build_monster", "_on_clear_monster",tscn_name)
		get_tree().call_group(0, "build_monster", "auto_monster_stop")
		return
	property_business(monster_name,0,money,1)
	Monster_tscn[tscn_name]=monster_name
	var monsters=get_node("/root/config").GetConfig("Monsters")
	get_tree().call_group(0, "build_monster", "set_monster_hp",tscn_name,monsters[monster_name].hp)
	if(money):
		Overall.MsgSend(self,tr("build")+tr(monsters[monster_name].name))
	Monster[tscn_name].name=monsters[monster_name].name
	Monster[tscn_name].atk=monsters[monster_name].atk
	Monster[tscn_name].def=monsters[monster_name].def
	Monster[tscn_name].hp=monsters[monster_name].hp
	Monster[tscn_name].expe=monsters[monster_name].expe
	Monster[tscn_name].money=monsters[monster_name].money
	pass
func _on_hunt_player(obj,monster_name):
	var monsters=get_node("/root/config").GetConfig("Monsters")
	var player_name=obj.get_name()
	if(player_name=="player"):
		if(Player.hp<=0):
			if(monster_name=="boss"):
				get_tree().call_group(0,"boss","clear_monster_delay")
				return
			else:
				get_tree().call_group(0,"monsters","clear_monster_delay")
				return
		var monster=get_node("/root/config").GetConfig("Monsters")
		hp_sub(monster[monster_name].atk,monster[monster_name].name)
			
	pass
func _on_hunt_monsters(obj):
	var monsters=get_node("/root/config").GetConfig("Monsters")
	var tscn_name=obj.get_name()
	if(tscn_name=="monster"):
		get_tree().call_group(0,"sound","misc","hurt monster")
	if(tscn_name=="boss"):
		get_tree().call_group(0,"sound","misc","hurt monster")
	"""
		var hp_sub=Player.atk-Monster[tscn_name].def
		if(hp_sub<0):hp_sub=0
		Monster[tscn_name].hp-=hp_sub
		get_tree().call_group(0,"boss","set_monster_hp",Monster[tscn_name].hp)
		Overall.MsgSend(self,"对%s造成%s伤害" %[monsters[tscn_name].name,str(hp_sub)])
		#monster die
		if(Monster[tscn_name].hp<=0):
			monster_die(monsters[tscn_name])
			#lv up
			if(Player.expe_current>=Player.expe):
				player_lv_up()
			get_tree().call_group(0, "boss", "clear_monster",1)
	"""
	for key in Monster_tscn:
		if(tscn_name==key):
			get_tree().call_group(0,"sound","misc","hurt monster")
			var name=Monster_tscn[tscn_name]
			var hp_sub=Player.atk-Monster[tscn_name].def
			if(hp_sub<0):hp_sub=0
			Monster[tscn_name].hp-=hp_sub
			get_tree().call_group(0, "build_monster", "set_monster_hp",tscn_name,Monster[tscn_name].hp)
			var str_be=tr("hurt")+tr(monsters[name].name)+tr("hp")+str(hp_sub)
			Overall.MsgSend(self,str_be)
			hp_sub(Monster[tscn_name].atk,monsters[name].name)
			#monster die
			if(Monster[tscn_name].hp<=0):
				monster_die(monsters[name])
				#lv up
				player_lv_up()
				#msg clear monster texture
				get_tree().call_group(0, "build_monster", "_on_clear_monster",tscn_name)
	pass
func monster_die(monster):
	get_tree().call_group(0,"sound","misc","kill monster money")
	Player.kill_monster(monster.expe)
	Player.money+=monster.money
	Player.num_monster+=1
	Overall.MsgSend(self,tr("kill")+tr(monster.name))
	Overall.MsgSend(self,tr("get money")+str(monster.money))
	Overall.MsgSend(self,tr("get expe")+str(monster.expe))
	get_tree().call_group(0, "information", "information_update")
	pass
func pass_night(money,expe,night):
	get_tree().call_group(0,"sound","misc","kill monster money")
	Player.kill_monster(expe)
	Player.money+=money
	Overall.MsgSend(self,tr("pass the")+str(night)+tr("night"))
	Overall.MsgSend(self,tr("get money")+str(money))
	Overall.MsgSend(self,tr("get expe")+str(expe))
	get_tree().call_group(0, "information", "information_update")
	pass
func player_lv_up():
	if(Player.expe_current<Player.expe):return
	Player.lv_up()
	Overall.MsgSend(self,tr("lv up_"))
	Overall.MsgSend(self,tr("hp limit increased 3.atk increased 0.5"))
	get_tree().call_group(0, "information", "information_update")
	pass
func hp_sub(sub,name):
	sub-=Player.def
	if(sub<=0):
		sub=0
	else:
		get_tree().call_group(0,"sound","misc","uhurt"+str(randi() % 2) )
	
	Player.hp-=sub
	
	Overall.MsgSend(self,tr("received")+tr(name)+str(sub)+tr("hurt"))
	if(Player.hp<=0):
		Player.act=0
		Overall.MsgSend(self,tr("You kneel!"))
	get_tree().call_group(0, "information", "information_update")
	pass
func _on_exit_build_monsters():
	enter_player=false
func _on_finished_hunt_ani():
	start_ani_move(Player.direction)
	if(auto_act):
		if(Player.act==0):
			_on_auto_act()
			return
		start_ani("hurt",Player.direction)

	#stop_ani()
	
func start_ani_move(direction,name="move"):
	
	if (get_node("hurt").is_playing()):
		return
	if (get_node("ban").is_playing()):
		return
	Player.direction=direction
	if (get_node("move").is_playing()): 
		var ani_be=get_node("move").get_current_animation()	
		if (ani_be!="player_"+name+"_"+direction):
			get_node("move").play("player_"+name+"_"+direction)
	else:
		get_node("move").play("player_"+name+"_"+direction)
	
func start_ani(name,direction):
	
	if (get_node(name).is_playing()):
		return
	get_node(name).play("player_"+name+"_"+direction)
func stop_ani(name="move"):
	get_node(name).stop(false)
func buy(money,name):
	var str_be=tr("spend")+str(money)+","+tr("buy")+tr(name)
	Overall.MsgSend(self,str_be)
func _on_auto_act():
	if(auto_act):
		get_parent().get_node("option button/auto act").set_text(tr("auto hurt"))
	else:
		if(Player.act==0):return
		get_parent().get_node("option button/auto act").set_text(tr("cancel")+tr("auto hurt"))
		start_ani("hurt",Player.direction)
	auto_act=!auto_act
func _on_save():
	return {
			"name":Player.name,
			"hp":Player.hp,
			"hp_cap":Player.hp_cap,
			"atk":Player.atk,
			"def":Player.def,
			"lv":Player.lv,
			"expe":Player.expe,
			"expe_current":Player.expe_current,
			"money":Player.money,
			"num_monster":Player.num_monster,
			"num_monster_json":Player.num_monster_json,
			"direction":Player.direction,
			"act":Player.act,
			"pos":{"x":get_pos().x,"y":get_pos().y}
	}
func _on_load(data):
	Player.name=data.name
	Player.hp=data.hp
	Player.hp_cap=data.hp_cap
	Player.atk=data.atk
	Player.def=data.def
	Player.lv=data.lv
	Player.expe=data.expe
	Player.expe_current=data.expe_current
	Player.money=data.money
	Player.num_monster=data.num_monster
	Player.num_monster_json=data.num_monster_json
	Player.direction=data.direction
	Player.act=data.act
	set_pos(Vector2(data.pos.x,data.pos.y))
	Overall.MsgSend(self,tr("welcome back")+Player.name)
	get_tree().call_group(0, "information", "information_update")
	pass
	

func _on_timeout_10():
	property_business("hp",1)
	pass # replace with function body
