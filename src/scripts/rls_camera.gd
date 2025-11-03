extends Camera3D

@onready var viewport := $Viewport
@onready var camera := $Viewport/Camera3D

func _process(_delta):
	var img: Image = viewport.get_texture().get_image()
	img.flip_y() # исправляем переворот
	img.save_png("user://frame.png")
