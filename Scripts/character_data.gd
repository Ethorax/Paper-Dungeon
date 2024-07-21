extends Resource
class_name CharacterData


@export var battle_version : PackedScene

@export var portrait : Texture
@export var name : String
@export var class_title : String

@export var xp : int
@export var xp_to_level : int

#Manageable stats
@export var max_health : int
@export var health : int
@export var max_mana : int
@export var mana : int

#Stat Attributes
@export var strength : int
@export var speed : int
@export var constitution : int
@export var luck : int

#Equipment stats????
@export var attack : int
@export var defence : int


func take_damage(damage : int):
	health -= damage
