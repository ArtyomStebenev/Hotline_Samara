extends CharacterBody2D

const SPEED = 150.0
const RAYCAST_ANGLE := deg_to_rad(360)
const RAYCAST_DELTA := deg_to_rad(10.0)
const RAYCAST_DISTANCE := 200.0

var rays = []

const ROT_MATRIX = Transform2D(PI/2, Vector2.ZERO)

@onready var nav := $NavigationAgent2D
@export var player : CharacterBody2D

var target_position = self.global_position

func _ready() -> void:
	set_raycast()

func _physics_process(delta: float) -> void:	
	if player_is_visible():
		target_position = player.global_position
		move_to()

func move_to() -> void:
	var direction = (nav.get_next_path_position() - self.global_position).normalized()
	velocity = SPEED * direction
	self.look_at(self.global_position + ROT_MATRIX * direction)
	move_and_slide()

func player_is_visible() -> bool:
	for ray in rays:
		if ray.is_colliding() and ray.get_collider().is_in_group('player'):
			return true
	return false

func _on_timer_timeout() -> void:
	nav.target_position = target_position

func set_raycast()->void:
	var count = RAYCAST_ANGLE/RAYCAST_DELTA
	
	for index in count:
		var ray = RayCast2D.new()
		var angle = RAYCAST_DELTA * index - RAYCAST_ANGLE/2
		ray.target_position = Vector2(0, -RAYCAST_DISTANCE)
		ray.rotation = angle
		ray.visible = false
		add_child(ray)
		
		ray.enabled = true
		ray.set_collision_mask_value(5, true) 
		
		rays.push_back(ray)
