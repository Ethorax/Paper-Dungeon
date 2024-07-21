extends Node

@export var stats : CharacterData

@onready var bar = get_parent().get_node("Bar")

@export var xp : int
@export var xp_to_level : int

#Manageable stats
@export var max_health : int
@export var health : int
@export var mana : int

#Stat Attributes
@export var strength : int
@export var speed : int
@export var constitution : int
@export var luck : int

#Equipment stats????
@export var attack : int
@export var defence : int


func _ready():
	update_bar()


func take_damage(damage : int):
	health -= damage
	bar.value = health
	if(health <= 0):
		get_parent().queue_free()

func update_bar():
	if(stats != null):
		max_health = stats.max_health
		health = stats.health
		bar.max_value = max_health
		bar.value = health
