extends Node


var network = NetworkedMultiplayerENet.new()
var port = 1909


var max_players = 100
var player_ids = []


func _ready():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)

	print("Server started")

	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")


func _peer_connected(player_id):
	print(str(player_id) + " connected")

	player_ids.append(player_id)

	rpc_id(0, "return_connected_player", player_id)
	rpc_id(player_id, "return_connected_players", player_ids)


func _peer_disconnected(player_id):
	print(str(player_id) + " disconnected")

	player_ids.erase(player_id)

	rpc_id(0, "return_disconnected_player", player_id)


remote func synchronize(node_path, func_name, state):
	rpc_id(0, "s_synchronize", node_path, func_name, state)


remote func synchronize_client(node_path, func_name, state):
	rpc_id(0, "s_synchronize_client", node_path, func_name, state, get_tree().get_rpc_sender_id())
