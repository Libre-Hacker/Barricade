extends Node


const DEFAULT_PORT = 4242
const MAX_CLIENTS = 3

var peer = null

var IP_ADDRESS = ""

func _ready():
	for ip in IP.get_local_addresses():
		if(ip.begins_with("192.168.") and ip.ends_with(".1") == false):
			IP_ADDRESS = ip
	
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")


func create_server():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(peer)


func join_server(IPAddress):
	print("attempting to join server " + IPAddress)
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(IP_ADDRESS, DEFAULT_PORT)
	get_tree().set_network_peer(peer)


func _on_player_connected(id):
	print("Player " + str(id) + " has connected.")


func _on_player_disconnected(id):
	print("Player " + str(id) + " has disconnected.")
	if(GameManager.playerManager == null):
		return
	if(GameManager.playerManager.has_node(str(id))):
		GameManager.playerManager.get_node(str(id)).queue_free()


func _on_connected_to_server():
	print("Successfully connected to the server.")


func _on_server_disconnected():
	peer.close_connection()
	peer = null
	print("Disconnected from the server.")
	get_tree().quit()
