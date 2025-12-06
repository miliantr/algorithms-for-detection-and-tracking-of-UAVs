extends Node3D
var direction: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Rls.global_position = Vector3(0, $Env/InfiniteTerrain.get_terrain_height(0, 0) + 1, 0)
	$Rls.global_position = Vector3(0, 1, 0)
	$Plane.position = Vector3(30, 30, -50)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Plane.position.z += delta * 10
