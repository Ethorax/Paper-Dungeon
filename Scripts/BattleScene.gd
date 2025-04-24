extends Node3D

var just_entered : bool = true

var cam_move : bool = true
var contingents = []
var party = preload("res://Objects/Party/Test_Party.tres")
 
@onready var active_character = 0
@onready var spot_light = $SpotLight3D
@onready var cam = $Path3D/PathFollow3D/Camera3D

var all_fighters = []
var enemy_line = []
var hero_line = []
var battle_ended = false


var damage_number = preload("res://Objects/damage_number.tscn")
@onready var enemy_list := load("res://Objects/Between Scenes/EnemyParties.tres") as EnemyGroupData

var picking : bool = false
var active_char = 0
var turn_state

enum hero_turn {
	move_select,
	target_select
}
enum enemy_turn {
	move_select,
	target_select
}
var enemy_state = enemy_turn.move_select
var hero_state = hero_turn.move_select
var target = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("battle started")
	#enemy_list.shuffle()
	#var chosen_enemy_group = enemy_list
	#print(chosen_enemy_group)
	for character in party.character_datas:
		contingents.append(character)
	for character in enemy_list.enemy_datas:
		contingents.append(character)
	print(contingents)
	var hero_index = 0
	for i in party.character_datas:
		if(i != null):
			var hero_inst = i.battle_version.instantiate()
			hero_inst.scale = hero_inst.scale * 5
			$Heroes.get_children()[hero_index].add_child(hero_inst)
			hero_line.append($Heroes.get_children()[hero_index])
			hero_index += 1
		
		
	var slot_index = 4
	var monster_index = 0
	for i in enemy_list.enemy_datas:
		var enemy_inst = preload("res://Objects/enemy_in_battle.tscn").instantiate()
		enemy_inst.scale = enemy_inst.scale * 6
		#contingents[slot_index].add_child(enemy_inst)
		$Enemies.get_children()[monster_index].add_child(enemy_inst)
		enemy_line.append($Enemies.get_children()[monster_index])
		slot_index += 1
		monster_index +=1
		#monster_index += 1 
	monster_index=0
	for i in $Enemies.get_children():
		if(i.get_child_count()>0):
			enemy_line.append(contingents[monster_index])
			monster_index+=1
		

	var groups = []
	for i in $Heroes.get_children():
		if i.get_children().size() > 0:
			groups.append(i)
	contingents = groups
	groups = []
	for i in $Enemies.get_children():
		if i.get_children().size() > 0:
			groups.append(i)
	contingents.append_array(groups)		
							
	#Sort all the contingents by speed
	var battle_order
	var min
	#for i in contingents.size()-1:
		#min = i	
		#for j in range(i+1,contingents.size()-1):
			#print(contingents[j].get_child(0).get_node("Stats").speed, contingents[min].get_child(0).get_node("Stats").speed)
			#if contingents[j].get_child(0).get_node("Stats").speed < contingents[min].get_child(0).get_node("Stats").speed:
				#min = j
		#var swap1 = contingents[i]
		#var swap2 = contingents[min]
		#contingents[i] = swap2
		#contingents[min] = swap1
	all_fighters.append_array(party.character_datas)
	all_fighters.append_array(enemy_list.enemy_datas)
	
	
	for i in all_fighters.size()-2:
		for j in all_fighters.size()-2:
			if (all_fighters[j].speed > all_fighters[j+1].speed):
				var temp = all_fighters[j]
				all_fighters[j] = all_fighters[j+1]
				all_fighters[j+1] = temp
	
	all_fighters.insert(0,all_fighters.pop_at(-1))
	all_fighters.reverse()
	
	
	
		
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(cam_move):
		cam.get_parent().progress_ratio += 0.01
		if(cam.get_parent().progress_ratio >= 0.99):
			cam_move = false
	
			
	update_contingents()
	#print(enemy_line)
	if(battle_ended):
		
		for i in hero_line.size():
			party.character_datas[i] = $Heroes.get_child(i).get_child(0).get_node("Stats").stats
			
		
		ResourceSaver.save(party,"res://Objects/Party/Test_Party.tres")
		get_tree().change_scene_to_file("res://Objects/entrance.tscn")
		
	if(active_char>=contingents.size()-1):
		active_char = 0
		
	if(contingents[active_char].get_child(0).is_in_group("Enemy") and !battle_ended):	
		#print("Enemy Turn")
		
		#active_char += 1
		
		
		highlight(contingents[active_char])
		
		match enemy_state:
			enemy_turn.move_select:
				var tween = create_tween()
				tween.tween_property(cam, "position", Vector3(contingents[active_char].position.z,cam.position.y,cam.position.z), 0.5)
				enemy_state = enemy_turn.target_select
			
			
			
			
			enemy_turn.target_select:
				
				hero_line.shuffle()
				hero_line[0].get_node("Stats").stats.take_damage(1)
				spawn_damage(1,hero_line[0].global_position)
				hero_line[0].get_node("Stats").update_bar()
				enemy_state = enemy_turn.move_select
				
				active_char+=1
		
		
		
		
		
		
	elif(contingents[active_char].get_child(0).is_in_group("Hero") and !battle_ended):
		#print("Hero Turn")
		
		highlight(contingents[active_char])
		
		
		match hero_state:
			hero_turn.move_select:
				var tween = create_tween()
				tween.tween_property(cam, "position", Vector3(contingents[active_char].position.z,cam.position.y,cam.position.z), 0.5)
				contingents[active_char].get_child(0).get_node("Selector").visible = true
				if Input.is_action_just_pressed("ui_accept"):
					print("Selected "+ str(contingents[active_char].get_child(0).get_node("Selector").selected))
					contingents[active_char].get_child(0).get_node("Selector").visible = false
					hero_state = hero_turn.target_select
					
					
			hero_turn.target_select:
				#cam = cam.get_parent()
				var tween = create_tween()
				tween.tween_property(cam, "position", Vector3(10,cam.position.y,cam.position.z), 0.5)
				highlight(enemy_line[target])
				if(Input.is_action_just_pressed("move_left")):
					unhighlight(enemy_line[target])
					target -=1
					if(target < 0):
						target = enemy_line.size()-1
				if(Input.is_action_just_pressed("move_right")):
					unhighlight(enemy_line[target])
					target +=1
					if(target > enemy_line.size()-1):
						target = 0
				if(Input.is_action_just_pressed("ui_accept")):
					match contingents[active_char].get_child(0).get_node("Selector").selected:
						0:
							var attack = contingents[active_char].attack
							var attack_target = enemy_line[target]
							print(contingents[active_char].get_child(0).name,"attack",attack_target.get_child(0).name)
							unhighlight(enemy_line[target])
							spawn_damage(attack,attack_target.position)
							damage(enemy_line[target], attack)
						1:
							print("defend")
						2:
							print("item")
						3:
							print("skill")
							
							 
					unhighlight(contingents[active_char])
					active_char += 1
					hero_state = hero_turn.move_select
				if(Input.is_action_just_pressed("ui_cancel")):
					unhighlight(enemy_line[target])
					hero_state = hero_turn.move_select
				
	

		

func spawn_damage(amount : int, location : Vector3):
	var num_object = damage_number.instantiate()
	num_object.position = location
	num_object.get_child(1).get_child(0).text = str(amount)
	get_tree().root.add_child(num_object)
	
func highlight(slot):
	slot = slot as Node3D
	if(slot.get_children().size()>0):
		slot.get_child(0).get_node("Light").visible = true

func unhighlight(slot):
	slot = slot as Node3D
	slot.get_child(0).get_node("Light").visible = false

func damage(entity_slot : Node, damage : int):
	entity_slot.get_child(0).get_node("Stats").take_damage(damage)
	
	
func update_contingents():
	
	if(enemy_line.size() >1):
		for i in enemy_line.size()-1:
			if(enemy_line[i].get_children().size()<=0):
				enemy_line.pop_at(i)
	else:
		if enemy_line[0].get_children().size()<=0:
			enemy_line.pop_at(0)
	for i in contingents.size()-1:
		if(contingents[i].get_children().size()<=0):
			contingents.pop_at(i)
	if(enemy_line.is_empty()):
		battle_ended = true
