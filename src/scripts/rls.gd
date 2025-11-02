extends Node3D

var planeIn
var planeBody
var rotlock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if planeIn:
		look_at(planeBody.global_position, Vector3.UP)
	if not planeIn:
		rotate(Vector3(0, 1, 0), delta)
		pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	planeBody = body
	planeIn = 1
	print("detected")


func _on_area_3d_body_exited(body: Node3D) -> void:
	planeIn = 0
	print("undetected")
