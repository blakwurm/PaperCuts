extends Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name WordList

export(PoolStringArray) var list
export(PoolStringArray) var animals
export(PoolStringArray) var adjectives
var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	pass # Replace with function body.

func get_random_word():
	return list[rand.randi_range(0, list.size())]

func get_random_animal():
	var words: String = adjectives[rand.randi_range(0,adjectives.size())]+" "+animals[rand.randi_range(0,animals.size())]
	words = words.capitalize()
	return words.replace(" ", "_")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
