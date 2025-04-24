extends Resource
class_name EnemyData


@export var battle_sprite : Texture

@export var name : String

@export var xp : int

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
