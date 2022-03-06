extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var path1 = "/Users/zaph/foo/bar/baz/chonkster/nickle/diamond/fwoop/"
	var path2 = "/Users/foo"
	print("rel is ", get_rel_path(path1, path2))
	pass # Replace with function body.

func get_rel_path(basepath: String, divpath: String):
	if basepath.ends_with("/"):
		basepath = basepath.substr(0, basepath.length()-1)
	if divpath.ends_with("/"):
		divpath = divpath.substr(0, divpath.length()-1)
	print(basepath)
	var basesplit: PoolStringArray = basepath.split("/")
	var divsplit: PoolStringArray = divpath.split("/")
	var back_count = 0
	var common_count = 0
	for ind in range(basesplit.size()):
		var n = basesplit[ind]
		if back_count == 0:
			var m = divsplit[ind]
			if n == m:
				common_count += 1
			else:
				back_count += 1
		else: 
			back_count += 1
	var retcont = PoolStringArray()
	for i in range(back_count):
		retcont.append("..")
	for i in range(common_count):
		divsplit.remove(0)
	retcont.append_array(divsplit)
	var ret = retcont.join("/")
	return ret


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
