extends Node


remote func synchronize(func_name, state):
	rpc_id(0, func_name, get_tree().get_rpc_sender_id(), state)


remote func synchronize_unreliable(func_name, state):
	rpc_id(0, func_name, get_tree().get_rpc_sender_id(), state)
