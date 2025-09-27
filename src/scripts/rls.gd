extends Node3D

var rotation_speed = 1.0
var yaw = 0.0
var pitch = 0.0

func _ready() -> void:
	$RLS.position = Vector3(0, 1, 0)
	$Camera3D.position = Vector3(0, $RLS.position.y + 0.6, 0)

func _process(delta):
	var horizontal = Input.get_axis("camera_left", "camera_right")
	var vertical = Input.get_axis("camera_down", "camera_up")
	
	
	yaw += horizontal * rotation_speed * delta
	pitch += vertical * rotation_speed * delta
	pitch = clamp(pitch, -PI/2, PI/2)
	
	# Родитель поворачивается по Y (влево-вправо)
	rotation.y = yaw
	# Камера поворачивается по X (вверх-вниз)
	$Camera3D.rotation.x = pitch
