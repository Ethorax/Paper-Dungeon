extends CharacterBody3D
#
#
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
		
var shotgun_damage = 20
var shotgun_spread = 100

var pistol_damage = 20
var pistol_spread = 30

var knife_damage = 50
var knife_spread = 0



var health = 100
var shotgun_ammo = 10
var pistol_ammo = 50
var MG_ammo = 75


var speed = 10
@export var mouse_sensititivty = 0.05
var h_acceleration = 6
var gravity = 12.8
var jump = 7
var full_contact = false
var air_acceleration = 1
var normal_acceleration = 6

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

var weapon_sel = 0

@onready var shake_cam = $Head/shakeable_camera

#@onready var anim_player = $AnimationPlayer
#@onready var knife_cast = $Head/shakeable_camera/Camera/KnifeCast
@onready var head =$Head
@onready var ground_check = $GroundCheck

#@onready var pistol_cast = $Head/shakeable_camera/Camera/PistolCast

#@onready var shotgun = $CanvasLayer/ShotgunControl/Shotgun
#@onready var pistol = $CanvasLayer/PistolControl/Pistol
#@onready var melee = $CanvasLayer/MeleeControl/Melee
#@onready var machinegun = $CanvasLayer/MGControl/MG

@onready var ray_container = $Head/shakeable_camera/Camera/Raycontainer

#@onready var shotgun_trauma = $trauma_causer


func _ready():
	randomize()
	#for r in ray_container.get_children():
		#r.cast_to.x = rand_range(shotgun_spread, -shotgun_spread)
		#r.cast_to.y = rand_range(shotgun_spread, -shotgun_spread)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensititivty))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensititivty))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

#func _process(delta):
	#fire_shotgun()

func _physics_process(delta):
	direction = Vector3()
	
	if ground_check.is_colliding():
		full_contact = true
	
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration  = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration  = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration  = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
			
	#if Input.is_action_just_pressed("weapon_sel_up") or Input.is_action_just_pressed("weapon_sel_down"):
		#if Input.is_action_just_pressed("weapon_sel_up"):
			#weapon_sel+=1
			#if weapon_sel > 4:
				#weapon_sel = 1
		#if Input.is_action_just_pressed("weapon_sel_down"):
			#weapon_sel-=1
			#print(weapon_sel)
			#if weapon_sel < 1:
				#weapon_sel = 4
		#if weapon_sel == 1:
			#print("Knife is out.")
			#melee.show()
			#pistol.hide()
		#if weapon_sel == 2: 
			#print("Pistol is out.")
			#shotgun.hide()
			#melee.hide()
			#pistol.show()
		#if weapon_sel == 3:
			#print("Shotgun is out.")
			#shotgun.show()
			#pistol.hide()
			#melee.hide()
		#if weapon_sel == 4: 
			#print("MG is out.")
			#shotgun.hide()
	
	
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	direction = direction.normalized()
	h_velocity = h_velocity.lerp(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	velocity = movement
	
	move_and_slide()
	

		#
	#
	#if Input.is_action_pressed("shoot") and !anim_player.is_playing():
		#if melee.is_visible():
			#anim_player.play("Melee_Shoot")
			#shake_cam.add_trauma(0.5)
			#fire_knife()
		#if pistol.is_visible() and pistol_ammo>0:
			#anim_player.play("Pistol_shoot")
			#shake_cam.add_trauma(0.6)
			#fire_pistol()
		#if shotgun.is_visible() and shotgun_ammo>0:
			#anim_player.play("Shotgun_Shoot")
			#fire_shotgun()
			#shake_cam.add_trauma(5.0)
			#var shellinstance = shell_effect.instance()
			#shellinstance.transform.origin = head.transform.origin
			#shake_cam.add_child(shellinstance)
			
		
		#if raycast.is_colliding() and coll.has_method("kill"):
		#		coll.kill()
		#print(coll)
		#print(raycast.get_collision_point())
		
		#
#func fire_shotgun():
	##if Input.is_action_just_pressed("fire"):
	#if(shotgun_ammo>0):
		#shotgun_ammo -= 1
		#$GUI/Shotgun_ammo.text = " "+str(shotgun_ammo)
		#for r in ray_container.get_children():
			#var bulletInstance = bullet_impact.instance()
			#if (r.get_collider() != null):
				#r.get_collider().add_child(bulletInstance)
				#bulletInstance.global_transform.origin = r.get_collision_point() 
				#bulletInstance.look_at(r.get_collision_point()+r.get_collision_normal(), Vector3.UP)
				#r.cast_to.x = rand_range(shotgun_spread, -shotgun_spread)
				#r.cast_to.y = rand_range(shotgun_spread, -shotgun_spread)
				#
				#if r.get_collider().is_in_group("Enemy"):
					#r.get_collider().take_damage(shotgun_damage)
					#print(r.get_collider().health)
				
#func fire_pistol():
	#var bulletInstance = bullet_impact.instance()
	#if (pistol_cast.get_collider()!=null):
		#pistol_cast.get_collider().add_child(bulletInstance)
		#bulletInstance.global_transform.origin = pistol_cast.get_collision_point() 
		#bulletInstance.look_at(pistol_cast.get_collision_point()+pistol_cast.get_collision_normal(), Vector3.UP)
		#pistol_cast.cast_to.x = rand_range(pistol_spread, -pistol_spread)
		#pistol_cast.cast_to.y = rand_range(pistol_spread, -pistol_spread)
		#pistol_ammo -= 1
		#$GUI/Pistol_ammo.text = " "+str(pistol_ammo)
		#if pistol_cast.get_collider().is_in_group("Enemy"):
			#pistol_cast.get_collider().take_damage(pistol_damage)
#func fire_knife():
	#var bulletInstance = bullet_impact.instance()
	#if (knife_cast.get_collider() != null):
		#knife_cast.get_collider().add_child(bulletInstance)
		#bulletInstance.global_transform.origin = knife_cast.get_collision_point() 
		#bulletInstance.look_at(knife_cast.get_collision_point()+knife_cast.get_collision_normal(), Vector3.UP)
		##knife_cast.cast_to.x = rand_range(spread, -spread)
		##knife_cast.cast_to.y = rand_range(spread, -spread)
		#if knife_cast.get_collider().is_in_group("Enemy"):
			#knife_cast.get_collider().take_damage(knife_damage)


func take_damage(damage):
	health -= damage
	$GUI/Health.text = " "+health+" %"
	
func add_pistol_ammo(ammo):
	pistol_ammo += ammo
	$GUI/Pistol_ammo.text = " "+str(pistol_ammo)
	
func add_shotgun_ammo(ammo):
	shotgun_ammo += ammo
	$GUI/Shotgun_ammo.text = " "+str(shotgun_ammo) 
	
func add_MG_ammo(ammo):
	MG_ammo += ammo
	$GUI/MG_ammo.text = " "+str(MG_ammo) 
	
func add_health(hp):
	health += hp
	$GUI/Health.text = " "+str(health)+" %"
