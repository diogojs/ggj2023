extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func push_item(item: Node2D):
	add_child(item)
	item.position = get_rect().size - item.get_rect().size - Vector2(8, 8)
	item.z_index += 1
	
func pop_item() -> Node2D:
	if has_items():
		var item: Node2D = get_child(0)
		item.z_index -= 1
		remove_child(item)
		return item
	return null
	
func has_items():
	return get_child_count() > 0
