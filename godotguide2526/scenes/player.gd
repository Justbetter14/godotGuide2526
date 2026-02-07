extends CharacterBody2D

const SPEED: int = 50
const JUMP_POW: int = -300
const DELAY_TILL_RESTART: float = 2
const DISC = preload("res://scenes/disc.tscn")
var x_direction: int = 0
var is_dead: bool = false

var dir := "h"

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_dead:
		move_and_slide()
		return
	
	if Input.is_action_pressed("Shoot") and $DiscCooldown.is_stopped(): # Check if player cooldown is over
		$DiscCooldown.start()
		var new_disc: Area2D = DISC.instantiate()
		new_disc.position = position
		
		if dir == "h":
			if $AnimatedSprite2D.flip_h == true: # Check what way the player is facing
				new_disc.x_direction = -1
			else:
				new_disc.x_direction = 1
		elif dir == "v":
			new_disc.y_enable = true
		
		get_tree().current_scene.add_child(new_disc) 
	
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y += JUMP_POW
	
	if Input.is_action_pressed("Left"):
		x_direction = -1
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("Right"):
		x_direction = 1
		$AnimatedSprite2D.flip_h = false
	else:
		x_direction = 0
	
	velocity.x = x_direction * SPEED
	
	if is_on_floor():
		if x_direction != 0:
			$AnimatedSprite2D.play("Run")
		else:
			$AnimatedSprite2D.play("Idle")
	else:
		if velocity.y > 0:
			$AnimatedSprite2D.play("Fall")
		if velocity.y < 0:
			$AnimatedSprite2D.play("Jump")
	
	buttonDectetc()
	
	move_and_slide()

func die() -> void:
	is_dead = true
	set_deferred("velocity", Vector2.ZERO)
	$AnimatedSprite2D.flip_v = true
	$CollisionShape2D.set_deferred("disabled", true)
	
	Engine.time_scale = 0.5
	await get_tree().create_timer(DELAY_TILL_RESTART).timeout
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func buttonDectetc():
	var button1: Button = $"../CanvasLayer/Inventory/GridContainer/Button"
	var button2: Button = $"../CanvasLayer/Inventory/GridContainer/Button2"
	
	if Input.is_action_pressed("Hotkey 1"):
		if button1.text == "  Horizontal  ":
			use(button1)
	
	if Input.is_action_pressed("Hotkey 2"):
		if button2.text == "  Vertical  ":
			use(button2)

func use(button: Button):
	match button.text:
		'  Horizontal  ':
			dir = "h"
		'  Vertical  ':
			dir = "v"
