extends Node3D

var d_entered : bool = false
var player
@export var next_scene : PackedScene 
@export var door_w : float
@export var door_l : float

@export var destination : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(d_entered):
		Global.transition += 0.1
		var screen = player.get_node("CanvasLayer").get_child(0) as ColorRect
		screen.material.set_shader_parameter("right", Global.transition)
		print(screen.material.get_shader_parameter("right"))
		if Global.transition > 3.0:
			get_tree().change_scene_to_packed(next_scene)

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		Global.door_destination = destination
		player = body
		d_entered = true
		
