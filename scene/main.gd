extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var Enemy={}
var Enemy_Kine2D
var Enemy_Sprite
var EnemyBlueImg
func _ready():
	EnemyBlueImg = preload("res://assets/monster/blue_slime.png")
	
	# Called every time the node is added to the scene.
	# Initialization here
	CreateEnemy()
	pass
func CreateEnemy():
	#for i in range(9):
	Enemy_Kine2D=KinematicBody2D.new()
	Enemy=Sprite.new()
	Enemy.set_texture(EnemyBlueImg)
	Enemy.set_region(true) 
	Enemy.set_centered(true)
	Enemy.set_region_rect(Rect2(Vector2(0,0),Vector2(36,36))) 
	#Enemy.set_offset(Vector2(-20,-60))
	Enemy.set_global_scale(Vector2(0.25,0.3))
	add_child(Enemy)
