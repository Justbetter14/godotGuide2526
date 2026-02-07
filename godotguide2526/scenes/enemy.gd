extends CharacterBody2D

const SPEED: int = 50
var x_direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("player"):
			collider.die()

	if is_on_wall():
		x_direction *= -1
	
	velocity.x = SPEED * x_direction
	move_and_slide()
