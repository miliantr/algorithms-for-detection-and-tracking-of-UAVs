extends Node3D

const SERVER_IP = "127.0.0.1" # Replace with your server's IP
const SERVER_PORT = 8888 # Replace with your server's port

@onready var client_socket: StreamPeerTCP = StreamPeerTCP.new()
@onready var error = client_socket.connect_to_host(SERVER_IP, SERVER_PORT)

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
	await RenderingServer.frame_post_draw
	time_since_last_save += delta
	if time_since_last_save >= save_interval:
		var image = $SubViewport.get_texture().get_image()
		var filename = "res://img/image%04d.jpg" % frame_count
		#image.save_jpg(filename)
		var jpg_bytes: PackedByteArray = image.save_jpg_to_buffer()
		client_socket.put_data(jpg_bytes)
		
		frame_count += 1
		time_since_last_save = 0.0
		

func data_resive():
	# Receive data
	client_socket.poll() # Important: Poll to update connection status and receive data
	if client_socket.get_available_bytes() > 0:
		var received_data_array = client_socket.get_data(client_socket.get_available_bytes())
		if received_data_array[0] == OK:
			var received_message = (received_data_array[1] as PackedByteArray).get_string_from_ascii()
			print("Received data: ", received_message)


func _on_area_3d_body_entered(body: Node3D) -> void:
	planeBody = body
	planeIn = 1
	print("detected")


func _on_area_3d_body_exited(body: Node3D) -> void:
	planeIn = 0
	print("undetected")
