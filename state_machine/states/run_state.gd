class_name RunState
extends State

@export var fall_state: State
@export var idle_state: State
@export var walk_state: State
@export var jump_flip_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		var movement = Input.get_axis('move_left', 'move_right') * move_speed
		if movement != 0:
			return jump_flip_state
	if not Input.is_action_pressed('run') and parent.is_on_floor() and parent.velocity.x != 0:
		return walk_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement == 0:
		return idle_state
	
	parent.sprite.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
