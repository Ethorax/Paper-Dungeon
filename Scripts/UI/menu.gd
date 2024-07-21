extends Control


@onready var buttons_menu = $Panel/HBoxContainer/Menu2

@onready var inventory_window = $InventoryUi

@export var party_data = preload("res://Objects/Party/Test_Party.tres")

var inventory_button
var euqipment_button
var magic_button
var options_button
var exit_button


# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_button = buttons_menu.get_child(0).get_child(0) as Button
	
	inventory_button.button_up.connect(inventory)
	populate_party()
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		if(!visible):
			visible = true
		else:
			if(inventory_window.visible):
				inventory_window.visible = false
			else:
				visible = false
			


func inventory():
	inventory_window.visible = true


func _on_visibility_changed():
	
	if(visible ==true):
		get_parent().get_parent().emit_signal("pause")
	else:
		get_parent().get_parent().emit_signal("unpause")
		
func populate_party():
	var char_index = 0
	
	for i in party_data.character_datas:
		var character_slot = $Panel/HBoxContainer/Characters.get_children()[char_index]
		character_slot.hide()
		
	char_index = 0
	for i in party_data.character_datas:
		var character_slot = $Panel/HBoxContainer/Characters.get_children()[char_index]
		character_slot.show()
		character_slot.get_node("Portrait").texture = party_data.character_datas[char_index].portrait
		print(character_slot.get_children())
		
		character_slot.get_node("Info").get_child(0).text = party_data.character_datas[char_index].class_title		
		character_slot.get_node("Info").get_child(1).text = party_data.character_datas[char_index].name
	
		character_slot.get_child(1).get_child(0).max_value = party_data.character_datas[char_index].max_health	
		character_slot.get_child(1).get_child(0).value = party_data.character_datas[char_index].health
		character_slot.get_child(1).get_child(0).get_child(0).text = str(party_data.character_datas[char_index].health)
		
		character_slot.get_child(1).get_child(1).max_value = party_data.character_datas[char_index].max_mana	
		character_slot.get_child(1).get_child(1).value = party_data.character_datas[char_index].mana
		character_slot.get_child(1).get_child(1).get_child(0).text = str(party_data.character_datas[char_index].mana)
		
		character_slot.get_child(1).get_child(2).max_value = party_data.character_datas[char_index].xp_to_level	
		character_slot.get_child(1).get_child(2).value = party_data.character_datas[char_index].xp
		character_slot.get_child(1).get_child(2).get_child(0).text = str(party_data.character_datas[char_index].xp)
		
		char_index += 1 


func _on_slot_1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and ((event.button_index == MOUSE_BUTTON_LEFT) or (event.button_index == MOUSE_BUTTON_RIGHT)) and event.is_pressed():
		print("Portrait Clicked")
		print(get_parent())
		get_node("CharacterDetails").populate(party_data.character_datas[0])
		get_node("CharacterDetails").show()


func _on_slot_2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and ((event.button_index == MOUSE_BUTTON_LEFT) or (event.button_index == MOUSE_BUTTON_RIGHT)) and event.is_pressed():
		print("Portrait Clicked")
		print(get_parent())
		get_node("CharacterDetails").populate(party_data.character_datas[1])
		get_node("CharacterDetails").show()


func _on_slot_3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and ((event.button_index == MOUSE_BUTTON_LEFT) or (event.button_index == MOUSE_BUTTON_RIGHT)) and event.is_pressed():
		print("Portrait Clicked")
		print(get_parent())
		get_node("CharacterDetails").populate(party_data.character_datas[2])
		get_node("CharacterDetails").show()


func _on_slot_4_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and ((event.button_index == MOUSE_BUTTON_LEFT) or (event.button_index == MOUSE_BUTTON_RIGHT)) and event.is_pressed():
		print("Portrait Clicked")
		print(get_parent())
		get_node("CharacterDetails").populate(party_data.character_datas[3])
		get_node("CharacterDetails").show()
