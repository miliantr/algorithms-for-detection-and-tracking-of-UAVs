extends Camera3D

var base_fov = 75.0
var target_fov = base_fov
var fov_speed = 1.0
var max_fov = 5.0

func _ready() -> void:
	fov = base_fov
	#far = 1000.0
	#near = 5.0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_fov = min(base_fov, target_fov + fov_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_fov = max(max_fov, target_fov - fov_speed)
			
	fov = target_fov
