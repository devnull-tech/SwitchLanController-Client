extends Control

const server_url = "ws://192.168.1.238:8765"
var _client = WebSocketClient.new()
var request: Dictionary = {
	"action": "",
	"is_pressed": false
}

func _ready():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	
	var err = _client.connect_to_url(server_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	print("Connected")
	_client.get_peer(1).put_packet("\r\nTest packet".to_utf8())

func _on_data():
	var data = _client.get_peer(1).get_packet().get_string_from_utf8()
	$Label2.text = data
	print("Got data from server: ", data)

func _process(delta):
	_client.poll()

func _input(event):
	if event.is_action("ui_accept"):
		$Label.text = "INPUT"
		#var pressed = event.pressed
