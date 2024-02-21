extends Node


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
	bar.max_value = max_health


func take_damage(damage : int):
	health -= damage
	bar.value = health
	if(health <= 0):
		get_parent().queue_free()
