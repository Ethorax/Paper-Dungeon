extends CharacterBody3D


signal pause()
signal unpause()


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var right : bool = true
var b_started : bool = false
var just_entered : bool = true

@export var party = []

@onready var tright = $TorchRight
@onready var tleft = $Torchleft
@onready var torch = $Torch
@onready var anim = $AnimationPlayer

@onready var inventory = $CanvasLayer/Menu/InventoryUi
@onready var menu = $CanvasLayer/Menu
@onready var textb = $CanvasLayer/Textbox

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	
	torch = torch as OmniLight3D
	position = Global.door_destination

func _physics_process(delta):
	
	
	if(textb.visible or menu.visible):
		emit_signal("pause")
	else:
		emit_signal("unpause")
	
	
	if just_entered:
		Global.transition -= 0.1
		var screen = $CanvasLayer/ColorRect as ColorRect
		screen.material.set_shader_parameter("right", Global.transition)
		print(screen.material.get_shader_parameter("right"))
		if screen.material.get_shader_parameter("right") < -0.8:
			just_entered = false
	
	match Global.g_state:
		Global.game_state.overworld:
	# Add the gravity.
			if not is_on_floor():
				velocity.y -= gravity * delta

			# Handle jump.
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				anim.play("swing")

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var input_dir = Input.get_vector( "ui_down", "ui_up", "ui_left","ui_right")
			var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
				anim.play("walk")
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				if(velocity.z >0):
					right = true
				elif velocity.z < 0:
					right = false
			else:
				if anim.is_playing() and anim.current_animation != "swing":
					anim.play("RESET",-1,3.0)
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
			if right:
				$Hitbox.position.z = 1.3
				torch.position.z = move_toward(torch.position.z, tright.position.z, 0.5)
				$Sprite3D.rotation_degrees.y = move_toward($Sprite3D.rotation_degrees.y, -90, 15)
				$Sprite3D.rotation_degrees.x = move_toward($Sprite3D.rotation_degrees.x,  -4.2, 0.8)
				
			if !right:
				$Hitbox.position.z = -1.3
				torch.position.z = move_toward(torch.position.z, tleft.position.z, 0.5)
				$Sprite3D.rotation_degrees.y = move_toward($Sprite3D.rotation_degrees.y, -270, 15)
				$Sprite3D.rotation_degrees.x = move_toward($Sprite3D.rotation_degrees.x, 7.8, 0.8)
		
			move_and_slide()
			
			if(b_started):
				Global.transition += 0.1
				var screen = $CanvasLayer/ColorRect as ColorRect
				screen.material.set_shader_parameter("right", Global.transition)
				print(screen.material.get_shader_parameter("right"))
				if Global.transition > 3.0:
					get_tree().change_scene_to_file("res://Objects/battle_scene.tscn")
			
			
		Global.game_state.battle:
			pass




func _on_hitbox_body_entered(body):
	print(body.name)
	if(body.is_in_group("Enemy")):
		b_started = true
		Global.enemy_group = body.enemy_arangements
		Global.party = party
		
	
	
func start_battle():
	print("Start Battle")
	while Global.transition < 3.0:
		Global.transition += 0.1
		var screen = $CanvasLayer/ColorRect as ColorRect
		screen.material.set_shader_parameter("Right", Global.transition)
	get_tree().change_scene_to_file("res://Objects/battle_scene.tscn")


func add_item(item : ItemData):
	inventory.add_item(item)
