extends PanelContainer

const Slot = preload("res://Objects/inventory/Slot.tscn")

@onready var item_grid = $HBoxContainer/ScrollContainer/PanelContainer/ItemGrid
@onready var info_window = $HBoxContainer/VBoxContainer/InventoryInfoUi
@onready var use_button = $HBoxContainer/VBoxContainer/UseButton

var inv_data = preload("res://Objects/inventory/test_inventory.tres")

var selected_item : ItemData

func _ready():
	
	populate_item_grid(inv_data.slot_datas)
	

func populate_item_grid(slot_datas: Array[SlotData]) -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
	for slot_data in slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		if slot_data:
			slot.set_slot_data(slot_data)
			
		slot.slot_clicked.connect(_on_slot_slot_clicked.bind())
			

func add_item(item : ItemData):
	
	var new_item = SlotData.new()
	
	new_item.item_data = item
	
	for i in inv_data.slot_datas.size()-1:
		print(inv_data.slot_datas[i])
		if(inv_data.slot_datas[i].item_data.name == item.name):
			inv_data.slot_datas[i].quantity +=1
			populate_item_grid(inv_data.slot_datas)
			break
		elif inv_data.slot_datas[i] == null:
			inv_data.slot_datas[i] = new_item
			populate_item_grid(inv_data.slot_datas)
			break

func remove_item(item : ItemData):
	var removed_item = SlotData.new()
	
	removed_item.item_data = item
	
	for i in inv_data.slot_datas.size()-1:
		print(inv_data.slot_datas[i])
		if(inv_data.slot_datas[i].item_data.name == item.name):
			inv_data.slot_datas[i].quantity -=1
			populate_item_grid(inv_data.slot_datas)
			break
	
func update_info(slot_data):
	print("info updated")
	


func _on_slot_slot_clicked(item : ItemData):
	print(item.description)
	selected_item = item
	info_window.get_child(0).get_child(0).get_child(4).text = item.description
	info_window.get_child(0).get_child(0).get_child(0).text = item.name
	info_window.get_child(0).get_child(0).get_child(2).texture = item.texture
	use_button.disabled = false




func _on_use_button_button_up():
	use_item(selected_item)
	
	
func use_item(item : ItemData):
	remove_item(item)
	print("you used "+item.name)
