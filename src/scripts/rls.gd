extends Node3D

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 8888

var x = 0
var y = 0 
var w = 0
var h = 0
var cx = 0
var cy = 0

var save_interval = 0.03
var time_since_last_save = 0.0

var udp := PacketPeerUDP.new()

func _ready():
	udp.set_dest_address(SERVER_IP, SERVER_PORT)

func _process(delta: float) -> void:
	await RenderingServer.frame_post_draw
	time_since_last_save += delta
	if time_since_last_save >= save_interval:
		send_frame()
		get_msg()
		$Camera3D/ReferenceRect.set_position(Vector2(x, y))
		$Camera3D/ReferenceRect.set_size(Vector2(w, h))
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

func get_msg():
	if udp.get_available_packet_count() > 0:
		var pkt: PackedByteArray = udp.get_packet()
		if pkt.size() == 24:
			x = pkt.decode_u32(0)
			y = pkt.decode_u32(4)
			w = pkt.decode_u32(8)
			h = pkt.decode_u32(12)
			cx = pkt.decode_s32(16)
			cy = pkt.decode_s32(20)
