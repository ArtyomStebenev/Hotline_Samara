extends CharacterBody2D
@onready var animation = $"rotation node" #wrapping of $AnimatedSprite2D

#enum INPUT_SCHEMES { KEYBOARD, XBOX_GAMEPAD, NINTENDO_GAMEPAD }

const PUSH_FORCE: float = 11.20
const SPEED:      float = 150.0
const ROT_MATRIX = Transform2D(PI/2, Vector2.ZERO) #just linear algebra


var direction:      Vector2 = Vector2.ZERO
var head_direction: Vector2 = Vector2.ZERO
var time:           float   = 0



func movement() -> void:
	direction = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
						Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
						).limit_length(1.0)
	
	#direction.x = Input.get_axis("ui_left", "ui_right")
	#direction.y = Input.get_axis("ui_up", "ui_down")
	head_direction = self.global_position + Vector2(Input.get_action_strength("look_right") - Input.get_action_strength("look_left"), 
							   Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
							   ).limit_length(1.0)
	
	
	
	if head_direction == self.global_position + Vector2.ZERO: 
		#$AnimatedSprite2D.look_at(get_global_mouse_position())
		head_direction = get_global_mouse_position()
		
	
	
	if direction || head_direction:
		velocity = SPEED * direction
		#print(head_direction)
		
		$"rotation node".look_at(head_direction)
		#if head_direction == Vector2.ZERO: $AnimatedSprite2D.look_at(self.global_position + ROT_MATRIX * direction)
	else: 
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), 
						   move_toward(velocity.y, 0, SPEED))
	
	move_and_slide()


func camera_behavior(delta) -> void:
	const ROT_AMPLITUDE = 0.0005
	
	time += delta
	if(camera_rotation(time, ROT_AMPLITUDE) == ROT_AMPLITUDE): # Reset timer
		time = 0
	
	$Camera2D.rotate(camera_rotation(time, ROT_AMPLITUDE))
	#print(camera_rotation(time), " time: ", time)


func camera_rotation(phi, amplitude) -> float:
	const ROT_SPEED = 0.3
	return amplitude * (cos(ROT_SPEED * PI * phi))


func _physics_process(_delta) -> void:
	
	camera_behavior(_delta)
	movement()
	
	for i: int in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE)
			
	


#func _on_area_2d_area_entered(area: Area2D) -> void:
	#print("nr") 
	#if area.is_in_group("doors"):
		#print("nigger") 
	#


func _on_area_2d_area_entered(_area: Area2D) -> void:
	print("nigger") 
