extends Panel
@onready var potion: TextureRect = $GridContainer/PotionBox/potion

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _get_drag_data(_at_position: Vector2) -> Variant:
	if potion.texture == null:
		return
		
	var preview = duplicate()
	set_drag_preview(preview)
	return potion
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
