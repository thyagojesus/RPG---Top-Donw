extends CharacterBody2D

var _state_machine
var _is_attacking = false

@export_category("Variables")
@export var _move_speed: float = 64.8

@export var _friction:float = 0.2
@export var _acceleration: float = 0.2

@export_category("Objetos")
@export var _timer: Timer = null
@export var _animation_tree: AnimationTree = null

func _ready() -> void:
	_state_machine = _animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	_move()
	_animate()
	_attack()
	move_and_slide()
	
func _move()-> void:
	var _direction:Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up","move_down")
		)
	
	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction
		_animation_tree["parameters/attack/blend_position"] = _direction
		if _is_attacking == false:
			velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration )
			velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration )
		return
	if _is_attacking == false:
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction )
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction )
	
func _attack() ->void:
	if Input.is_action_just_pressed("attack") && _is_attacking == false:
		_is_attacking = true
		velocity.x = 0
		velocity.y = 0
		_timer.start()
		return
		
func _animate() -> void:
	if _is_attacking:
		_state_machine.travel("attack")
		return
		
	if velocity.length()>10:
		_state_machine.travel("walk")
		return
		
	_state_machine.travel("idle")


func _on_timer_timeout() -> void:
	_is_attacking = false
	return


func _on_attack_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
