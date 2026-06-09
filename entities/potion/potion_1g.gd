extends Area2D
#This detects when the mouse is clicked on this specific scene and whatever inherits from this scene 
func _unhandled_input(click: InputEvent) -> void:
	if click is InputEventMouseButton and click.button_index == MOUSE_BUTTON_LEFT:
		if click.pressed:
			print("clciked")
		else:
			print("released")

				
				
	
