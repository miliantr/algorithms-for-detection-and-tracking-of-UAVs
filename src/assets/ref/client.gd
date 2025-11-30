extends Node

const SERVER_IP = "127.0.0.1" # Replace with your server's IP
const SERVER_PORT = 8888 # Replace with your server's port

@onready var client_socket: StreamPeerTCP = StreamPeerTCP.new()
@onready var error = client_socket.connect_to_host(SERVER_IP, SERVER_PORT)

func _ready():
	pass

func _process(delta):
	var message = "Hello from Godot client!"
	var buffer = message.to_ascii_buffer()
	client_socket.put_data(buffer)
	print("Sent data: ", message)
	
	# Receive data
	client_socket.poll() # Important: Poll to update connection status and receive data
	if client_socket.get_available_bytes() > 0:
		var received_data_array = client_socket.get_data(client_socket.get_available_bytes())
		if received_data_array[0] == OK:
			var received_message = (received_data_array[1] as PackedByteArray).get_string_from_ascii()
			print("Received data: ", received_message)
	pass
