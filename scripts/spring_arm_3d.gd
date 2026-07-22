extends SpringArm3D

@export var mouse_sensitibity: float = 0.005
@export var zoom_sensitibity: float = 0.05

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			rotation.y -= event.relative.x * mouse_sensitibity
			rotation.x -= event.relative.y * mouse_sensitibity
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			spring_length -= event.relative.y * zoom_sensitibity
			
