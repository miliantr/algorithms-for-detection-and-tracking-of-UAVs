extends Node3D

var rotation_speed = 1.0
var yaw = 0.0
var pitch = 0.0

# Настройки полета
var fly_speed = 10.0
var acceleration = 8.0
var current_velocity = Vector3.ZERO

# Переменные для управления камерой
var is_rotating_camera = false
var last_mouse_pos = Vector2.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	# Начало вращения камеры при нажатии ЛКМ
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Захватываем мышь при нажатии ЛКМ
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				is_rotating_camera = true
				last_mouse_pos = event.position
			else:
				# Освобождаем мышь при отпускании ЛКМ
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				is_rotating_camera = false
	
	# Вращение камеры при удержании ЛКМ
	if event is InputEventMouseMotion and is_rotating_camera:
		var mouse_delta = event.relative
		
		yaw -= mouse_delta.x * rotation_speed * 0.005
		pitch -= mouse_delta.y * rotation_speed * 0.005
		pitch = clamp(pitch, -PI/2, PI/2)
		
		# Применяем вращение
		rotation.y = yaw
		$Camera3D.rotation.x = pitch

func _process(delta):
	# Обработка движения полета
	handle_flight_movement(delta)

func handle_flight_movement(delta):
	var input_dir = Vector3.ZERO
	
	# Движение вперед/назад (W/S)
	if Input.is_action_pressed("move_forward"):
		input_dir -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		input_dir += transform.basis.z
	
	# Движение влево/вправо (A/D)
	if Input.is_action_pressed("move_left"):
		input_dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += transform.basis.x
	
	# Движение вверх/вниз (Space/Ctrl)
	if Input.is_action_pressed("move_up"):
		input_dir += Vector3.UP
	if Input.is_action_pressed("move_down"):
		input_dir += Vector3.DOWN
	
	# Нормализуем вектор направления, если есть ввод
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
		
		# Плавное ускорение
		var target_velocity = input_dir * fly_speed
		current_velocity = current_velocity.lerp(target_velocity, acceleration * delta)
	else:
		# Плавное замедление при отсутствии ввода
		current_velocity = current_velocity.lerp(Vector3.ZERO, acceleration * delta)
	
	# Применяем движение
	position += current_velocity * delta
