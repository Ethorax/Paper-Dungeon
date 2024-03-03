extends PanelContainer

const Slot = preload("res://Objects/inventory/Slot.tscn")

@onready var item_grid = $HBoxContainer/ScrollContainer/PanelContainer/ItemGrid
@onready var info_window = $HBoxContainer/InventoryInfoUi

var inv_data = preload("res://Objects/inventory/test_inventory.tres")

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
			
		slot.slot_clicked.connect(_on_slot_slot_clicked)
			

func add_item(item : ItemData):
	
	var new_item = SlotData.new()
	
	new_item.item_data = item
	
	for i in inv_data.slot_datas.size()-1:
		if inv_data.slot_datas[i] == null:
			inv_data.slot_datas[i] = new_item
			populate_item_grid(inv_data.slot_datas)
			break


func update_info(slot_data):
	print("info updated")
	


func _on_slot_slot_clicked():
	print("Hello!")
