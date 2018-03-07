extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var Config={
	"Monsters":{
		"monster0":{
			"name":"blue slime",
			"atk":1,
			"hp":5,
			"def":0,
			"expe":10,
			"money":15,
			"texture":"blue_slime"
		},
		"monster0_1":{
			"name":"blue slime(wild)",
			"atk":3,
			"hp":15,
			"def":0,
			"expe":10,
			"money":15,
			"texture":"blue_slime"
		},
		"monster1":{
			"name":"red slime",
			"atk":6,
			"hp":70,
			"def":6,
			"expe":50,
			"money":120,
			"texture":"red_slime"
		},
		"monster1_1":{
			"name":"red slime(wild)",
			"atk":18,
			"hp":210,
			"def":15,
			"expe":50,
			"money":120,
			"texture":"red_slime"
		},
		"monster2":{
			"name":"green slime",
			"atk":30,
			"hp":230,
			"def":20,
			"expe":200,
			"money":300,
			"texture":"green_slime"
		},
		"monster2_1":{
			"name":"green slime(wild)",
			"atk":30*3,
			"hp":230*3,
			"def":50,
			"expe":200,
			"money":300,
			"texture":"green_slime"
		},
		"boss":{
			"name":"slime monther",
			"atk":150,
			"hp":2000,
			"def":100,
			"expe":1200,
			"money":1200,
			"texture":"blue_slime"
		}
	},
	"Property":{
		"atk":"atk",
		"def":"def",
		"hp":"hp",
		"hp_cap":"hp limit",
		"lv":"lv",
		"money":"money"
	}
	
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func GetConfig(key):
	return Config[key]


