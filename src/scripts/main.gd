extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Rls.global_position = Vector3(0, $Env/InfiniteTerrain.get_terrain_height(0, 0), 0);
	$Plane.position = Vector3(100, 100, 100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
