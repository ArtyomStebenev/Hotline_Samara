extends Node2D


func _ready() -> void:
	pass 

func _process(delta):
	var cursor_pos = get_global_mouse_position()
	position = cursor_pos
	pass
