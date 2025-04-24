extends CharacterBody3D
class_name Enemy

@export var enemy_groups : Array[EnemyGroupData]
@export var texture : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite3D.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
