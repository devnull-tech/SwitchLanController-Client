extends Control

const server_url = "ws://192.168.1.238:8765"
var _client = WebSocketClient.new()
var request: Dictionary = {
	"action": "",
	"is_pressed": false,
	"analog_value": 0.0
}

func _ready():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	var err = _client.connect_to_url(server_url)
	if err != OK:
		set_process(false)

func _closed(was_clean = false):
	if not was_clean:
		$log.text += "[!] Connection closed\n"
	set_process(false)

func _connected(_proto = ""):
	$log.text += "[+] Connected\n"

func _on_data():
	$log.text += "[*] Server said something \n"

func _process(_delta):
	_client.poll()

func send_request():
	var json_string: String = JSON.print(request)
	$log.text += "[*] Sended "+json_string+"\n"
	_client.get_peer(1).put_packet(json_string.to_utf8())

func _input(event):
	var is_valid = false
	if event is InputEventJoypadMotion:
		request.action = "axis"+str(event.axis)
		request.analog_value = event.axis_value
		is_valid = true
	if event.is_action_pressed("a") or event.is_action_released("a"):
		request.action = "a"
		is_valid = true
	if event.is_action_pressed("b") or event.is_action_released("b"):
		request.action = "b"
		is_valid = true
	if event.is_action_pressed("x") or event.is_action_released("x"):
		request.action = "x"
		is_valid = true
	if event.is_action_pressed("y") or event.is_action_released("y"):
		request.action = "y"
		is_valid = true
	if event.is_action_pressed("digital_u") or event.is_action_released("digital_u"):
		request.action = "du"
		is_valid = true
	if event.is_action_pressed("digital_d") or event.is_action_released("digital_d"):
		request.action = "dd"
		is_valid = true
	if event.is_action_pressed("digital_l") or event.is_action_released("digital_l"):
		request.action = "dl"
		is_valid = true
	if event.is_action_pressed("digital_r") or event.is_action_released("digital_r"):
		request.action = "dr"
		is_valid = true
	if event.is_action_pressed("l") or event.is_action_released("l"):
		request.action = "l"
		is_valid = true
	if event.is_action_pressed("r") or event.is_action_released("r"):
		request.action = "r"
		is_valid = true
	if event.is_action_pressed("zl") or event.is_action_released("zl"):
		request.action = "zl"
		is_valid = true
	if event.is_action_pressed("zr") or event.is_action_released("zr"):
		request.action = "zr"
		is_valid = true
	if event.is_action_pressed("l3") or event.is_action_released("l3"):
		request.action = "l3"
		is_valid = true
	if event.is_action_pressed("r3") or event.is_action_released("r3"):
		request.action = "r3"
		is_valid = true
	if event.is_action_pressed("start") or event.is_action_released("start"):
		request.action = "start"
		is_valid = true
	if event.is_action_pressed("select") or event.is_action_released("select"):
		request.action = "select"
		is_valid = true
	if is_valid:
		if not request.action.begins_with("axis"):
			request.is_pressed = event.is_pressed()
		send_request()
