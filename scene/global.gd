extends Node

var current_scene = null
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )

func GoTo_Scene(path,Load=-1):
    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:
	if(Load!=-1):
		get_node("/root/overall").Load(Load)

	call_deferred("GoTo_Scene_Deferred",path)


func GoTo_Scene_Deferred(path):

    # Immediately free the current scene,
    # there is no risk here.
    current_scene.free()

    # Load new scene

    var scene_be = ResourceLoader.load(path)

    # Instance the new scene
    current_scene = scene_be.instance()

    # Add it to the active scene, as child of root
    get_tree().get_root().add_child(current_scene)

    # optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene( current_scene )

