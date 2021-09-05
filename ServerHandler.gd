extends Node


var network = NetworkedMultiplayerENet.new()
var port = 1909


var max_players = 32
var player_ids = {}
var team_player_counts = [0, 0]


func _ready():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)

	print("Server started")

	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")


func _peer_connected(player_id):
	print(str(player_id) + " connected")

	player_ids[player_id] = int(team_player_counts[0] > team_player_counts[1])
	team_player_counts[player_ids[player_id]] += 1

	rpc_id(0, "return_player_ids", player_ids)


func _peer_disconnected(player_id):
	print(str(player_id) + " disconnected")

	team_player_counts[player_ids[player_id]] -= 1
	player_ids.erase(player_id)

	rpc_id(0, "return_player_ids", player_ids)


remote func synchronize(node_path, func_name, state):
	rpc_id(0, "s_synchronize", node_path, func_name, state)


remote func synchronize_client(node_path, func_name, state):
	rpc_id(0, "s_synchronize_client", node_path, func_name, state, get_tree().get_rpc_sender_id())
