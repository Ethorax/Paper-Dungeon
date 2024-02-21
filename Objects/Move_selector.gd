extends Node3D

@onready var path = $Path3D

var options
var ratio
var selected

func _ready():
	selected = 0
	options = path.get_children()
	ratio = snapped(1.0 / options.size(),0.01)
	#for option in options:
		#option.set_meta("target_ratio", option.progress_ratio)
	for i in options.size():
		print(i)
		options[i].set_meta("target_ratio", i * ratio)
	
	print(ratio)
	var index = 1
	for pf in path.get_children():
		pf.progress_ratio = ratio * index
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		if Input.is_action_just_pressed("move_right"):
			for pf in path.get_children():
				pf.set_meta("target_ratio",pf.get_meta("target_ratio")+ratio)
				
				#if pf.get_meta("target_ratio")>= 1.0:
					#pf.set_meta("target_ratio",0)
			selected += 1
			if(selected > options.size()-1):
				selected = 0
			
		if Input.is_action_just_pressed("move_left"):
			for pf in path.get_children():
				pf.set_meta("target_ratio",pf.get_meta("target_ratio")-ratio)
				
				#if pf.get_meta("target_ratio")< 0:
					#pf.progress_ratio = 1.0
					#pf.set_meta("target_ratio",ratio*(options.size()-1))

			selected += 1
			if(selected<0):
				selected = options.size() - 1		
			
			
			
		for option in options:
			if(option.get_meta("target_ratio") >= 1):
					option.progress_ratio -=1 
					option.set_meta("target_ratio",option.get_meta("target_ratio")-1)
			if(option.get_meta("target_ratio") < 0):
					option.progress_ratio = option.progress_ratio + 1
					option.set_meta("target_ratio",option.get_meta("target_ratio")+1)
			if(option.progress_ratio != option.get_meta("target_ratio")):
				var tween = create_tween()
				tween.tween_property(option, "progress_ratio", option.get_meta("target_ratio"), 0.5)

	
