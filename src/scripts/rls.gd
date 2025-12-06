extends Node3D

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 8888

var planeIn
var planeBody
var rotlock

var x = 0
var y = 0 
var w = 0
var h = 0

var frame_count = 0
var save_interval = 0.1
var time_since_last_save = 0.0

var udp := PacketPeerUDP.new()

func _ready():
	udp.set_dest_address(SERVER_IP, SERVER_PORT)

func _process(delta: float) -> void:
	#if planeIn:
		#look_at(planeBody.global_position, Vector3.UP)
		#$Camera3D.look_at(planeBody.global_position, Vector3.UP)
	#if not planeIn:
		#$SubViewport/Camera3D.rotate(Vector3(0, 1, 0), delta)
		#$Camera3D.rotate(Vector3(0, 1, 0), delta)

	await RenderingServer.frame_post_draw

	time_since_last_save += delta
	if time_since_last_save >= save_interval:
		send_frame()
		$Camera3D/ReferenceRect.set_position(Vector2(x, y))
		$Camera3D/ReferenceRect.set_size(Vector2(w, h))
		frame_count += 1
		time_since_last_save = 0.0


func send_frame():
	var image = $SubViewport.get_texture().get_image()
	var jpg_bytes: PackedByteArray = image.save_jpg_to_buffer()
	var size = jpg_bytes.size()

	if size > 65507 - 4:
		print("Frame too large for UDP, skipping:", size)
		return

	var buffer := StreamPeerBuffer.new()
	buffer.put_32(size) # первые 4 байта = размер
	buffer.put_data(jpg_bytes) # JPEG
	udp.put_packet(buffer.get_data_array())
	
	if udp.get_available_packet_count() > 0:
		var pkt: PackedByteArray = udp.get_packet()
		if pkt.size() == 16:
			x = pkt.decode_u32(0)   # little-endian
			y = pkt.decode_u32(4)
			w = pkt.decode_u32(8)
			h = pkt.decode_u32(12)
			print("Получено:", x, " ", y, " ", w, " ", h)


func _on_area_3d_body_entered(body: Node3D) -> void:
	planeBody = body
	planeIn = 1
	print("detected")


func _on_area_3d_body_exited(body: Node3D) -> void:
	planeIn = 0
	print("undetected")
