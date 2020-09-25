extends Node

func clear_all_children(node):
	for child in node.get_children():
		child.queue_free()
