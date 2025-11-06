extends Node3D

var planeIn
var planeBody
var rotlock

var frame_count = 0
var save_interval = 0.5
var time_since_last_save = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if planeIn:
		look_at(planeBody.global_position, Vector3.UP)
	if not planeIn:
		$SubViewport/Camera3D.rotate(Vector3(0, 1, 0), delta)
		$cone.rotate(Vector3(0, 1, 0), delta)
		
	await RenderingServer.frame_post_draw
	
	time_since_last_save += delta
	if time_since_last_save >= save_interval:
		var image = $SubViewport.get_texture().get_image()
		var filename = "res://img/Screenshot_%04d.png" % frame_count
		image.save_png(filename)
		
		frame_count += 1
		time_since_last_save = 0.0


func _on_area_3d_body_entered(body: Node3D) -> void:
	planeBody = body
	planeIn = 1
	print("detected")


func _on_area_3d_body_exited(body: Node3D) -> void:
	planeIn = 0
	print("undetected")
