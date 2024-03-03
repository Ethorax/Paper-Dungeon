extends Control


@onready var buttons_menu = $Panel/HBoxContainer/Menu2

@onready var inventory_window = $InventoryUi

var inventory_button
var euqipment_button
var magic_button
var options_button
var exit_button


# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_button = buttons_menu.get_child(0).get_child(0) as Button
	
	inventory_button.button_up.connect(inventory)
	
	
	
	


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
