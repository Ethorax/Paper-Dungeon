extends OmniLight3D

@export var noise : NoiseTexture2D
var time_passed = 0.0

func _process(delta):
	time_passed += delta

	var sampled_noise = noise.noise.get_noise_1d(time_passed)
	sampled_noise = abs(sampled_noise)
	#print(sampled_noise)
	light_energy = 1+sampled_noise*10
