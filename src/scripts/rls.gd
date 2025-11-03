extends Node3D

var planeIn
var planeBody
var rotlock

@onready var viewport := $Viewport
@onready var camera := $Viewport/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var img: Image = viewport.get_texture().get_image()
	#img.flip_y() # исправляем переворот
	#img.save_png("user://frame.png")
	if planeIn:
		look_at(planeBody.global_position, Vector3.UP)
	if not planeIn:
		rotate(Vector3(0, 1, 0), delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	planeBody = body
	planeIn = 1
	print("detected")


func _on_area_3d_body_exited(body: Node3D) -> void:
	planeIn = 0
	print("undetected")
