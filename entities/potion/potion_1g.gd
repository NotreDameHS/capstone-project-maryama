extends Area2D

var dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	pass

func _process(delta: float) -> void:
	var direction := Vector2(0, 0) 
	direction.x = Input.get_axis("mouse_clicked", "mouse_exit")
	direction.y = Input.get_axis("mouse_exit", "mouse_clicked")
	

var mouse_over := false

func _on_mouse_entered():
	print("mouse entered")
	mouse_over = true
	
func _on_mouse_exited():
	print("mouse exited")
	mouse_over = false


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = global_position - get_global_mouse_position()
			else:
				dragging = false
