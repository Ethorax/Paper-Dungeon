extends Node

var transition : float = -0.6

var door_destination : Vector3 = Vector3(-7.6,3.0,0.3)
enum game_state{
	overworld,
	battle
}
var g_state = game_state.overworld

var enemy_group

var party


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





