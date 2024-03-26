extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_child(0).get_node("Player")
	player.pause.connect(pause_game)
	player.unpause.connect(unpause_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func pause_game():
	print("pause")
	get_tree().paused = true
	
func unpause_game():
	print("unpause")
	get_tree().paused = false
