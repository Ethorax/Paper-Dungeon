extends Control


@onready var text = $PanelContainer/RichTextLabel as RichTextLabel
@onready var timer = $Timer
@onready var sound = $AudioStreamPlayer

@export var min_pitch = 0.9
@export var max_pitch = 1.1

var text_queue = []
var max_characters = 220

var make_noise = 0

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	#add_text("Hello this is a queued up text")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
		
	if(!visible and !text_queue.is_empty()):
		visible = true
		
		
	
	
	if(visible):
		if(timer.is_stopped()):
			timer.start(0.05)
		if(Input.is_action_just_pressed("ui_accept")):
			submit()


func _on_timer_timeout():
	if(text.visible_characters < len(text.text)):
		text.visible_characters += 1 
		sound.pitch_scale = random.randf_range(min_pitch,max_pitch)
		make_noise += 1
		if(make_noise % 2)==0:
			sound.play()
			
func add_text(added_text : String):
	var temp_string = ""
	var words = added_text.split(" ")	
	
	if(len(added_text) > max_characters):
		for word in words:
			temp_string = temp_string + " " + word
			
			
			
			print(temp_string)
	
	
	
	text_queue.append(added_text)


func submit():
	if(text.visible_characters < len(text.text)):
		text.visible_characters = len(text.text)
	elif(text.visible_characters >= len(text.text)):
		if(text_queue.is_empty()):
			visible = false
			
		else:
			text.text = text_queue.pop_front()
			text.visible_characters = 0


func _on_visibility_changed():
	if(visible ==true):
		get_parent().get_parent().emit_signal("pause")
	else:
		get_parent().get_parent().emit_signal("unpause")
