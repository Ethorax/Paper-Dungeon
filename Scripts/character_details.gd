extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	hide()



func populate(character : CharacterData):
	$VBoxContainer/Name.text =  character.name
	$VBoxContainer/Class.text = character.class_title
	$VBoxContainer/TextureRect.texture = character.portrait
	$VBoxContainer/Health.text = "Health: "+str(character.health)+ " / " + str(character.max_health)
	$VBoxContainer/Mana.text = "Mana: "+str(character.mana)+ " / " + str(character.max_mana)
	$VBoxContainer/XP.text = "XP: " + str(character.xp)+ " / " + str(character.xp_to_level)
	$VBoxContainer/Speed.text = "Speed: "+str(character.speed)
	$VBoxContainer/Attack.text = "Attack: "+ str(character.attack)
	$VBoxContainer/Defense.text = "Defense: "+str(character.defence)
	
