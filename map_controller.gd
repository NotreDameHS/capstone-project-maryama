extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	# Only respond to left mouse button presses
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		place_potion()
		var mouse_pos = get_global_mouse_position()
		
		# If this is TRUE, there is a turret there. If the selected turret is null, then we need a new UI
		if _has_overlapping_potion(mouse_pos) and GameManager.selected_turret_node == null:	
			var clicked_turret = _find_clicked_potion(mouse_pos)
			GameManager.selected_turret_node = clicked_turret		# Update GameManager
			_show_upgrade_prompt()									# Load the upgrade UI button
		else:
			GameManager.selected_turret_node = null					# Not an active turret
			
			
			
func place_potion() -> void:

	var mouse_world_pos = get_global_mouse_position()	# Get the global mouse position

	# Check if a turret is actually selected
	if GameManager.selected_potion_scene == null:
		return


	# Check 1: Is the spot on the path?
	# If _is_on_path returns True, it's on the path!
	if _is_on_path(mouse_world_pos):
		print("Stop here")
		return
		
	# Check 2: Is it too close to another turret?
	if _has_overlapping_potion(mouse_world_pos):
		print("Cannot place turret too close to another!")
		return
	
	
	# Instantiate the new scene so we can make changes to it
	var new_cannon = GameManager.selected_potion_scene.instantiate()#################################################################

	new_cannon.global_position = mouse_world_pos		# Set its global position to the mouse position
	new_cannon.add_to_group("Turrets") 				# Tag it for future collision checks
	
	

		# Remember calling this method returns TRUE or FALSE and updates cash.
	if GameManager.try_spend_money(GameManager.selected_turret_price):
		print("We have the money!")
		get_tree().current_scene.add_child(new_cannon)	# Add the scene to our scene tree

	else:
		print("Not enough money for this turret!")
	
	
	
	# Deselect after successful placement
	GameManager.clear_selection()
	
	
	
	

	
	
func _is_on_potion(position: Vector2) -> bool:

	# Convert world position to grid/map coordinates
	var map_coords = path_layer.local_to_map(position)
	print(map_coords)

	# Ask the layer if a tile exists at these coordinates
	var source_id = path_layer.get_cell_source_id(map_coords)
	
	# -1 means the cell is empty
	# so return True if the tile is NOT on the path (False if it is)
	return source_id != -1
	
	
	
	
	
func _has_overlapping_potion(position: Vector2) -> bool:

	# Get all nodes we've explicitly tagged as "Turrets"
	var placed_turrets = get_tree().get_nodes_in_group("Potions")

	for turret in placed_turrets:
		# Calculate the straight-line distance between the click and this turret
		var distance = position.distance_to(turret.global_position)
		
		# If distance is less than our threshold, they're too close!
		if distance < min_spacing:
			return true
			
	# If the loop finishes without returning True, the spot is clear
	return false
	
	
	
	
	
func _find_clicked_potion(position: Vector2) -> Node:
	# Get all nodes we've explicitly tagged as "Turrets"
	var placed_turrets = get_tree().get_nodes_in_group("Turrets")
	
	for turret in placed_turrets:
		# Calculate the straight-line distance between the click and this turret
		var distance = position.distance_to(turret.global_position)
		
		# If distance is less than our threshold, they're too close!
		if distance < min_spacing:
			return turret
			
	# If the loop finishes without returning a turret, the spot is clear
	return null
	




func _show_upgrade_prompt() -> void:
	
	# 1. Check to see if we can still upgrade this turret
	if GameManager.selected_turret_node.is_upgraded:
		return # is_upgraded is True so turret is already upgraded
	
	# 2. Instantiate scene so we can make changes to it
	var prompt = UPGRADE_PROMPT.instantiate()
	
	# 3. Set the upgrade prompt scene's target_turret to the one selected
	prompt.target_potion = GameManager.selected_potion_node

	# 4. Add the upgrade prompt to the scene (this triggers it's _ready() method)
	add_child(prompt)
