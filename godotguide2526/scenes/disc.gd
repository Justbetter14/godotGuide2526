extends Area2D

const SPEED: int = 225

var x_direction: int = 1
var y_enable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if y_enable == true:
		position.y -= SPEED * delta
	else:
		position.x += SPEED * x_direction * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.queue_free() # Destroy the enemy
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
