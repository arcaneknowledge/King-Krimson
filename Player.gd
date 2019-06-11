extends KinematicBody2D


const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

const FIREBALL = preload("res://Fireball.tscn")

var velocity = Vector2()
var deadzone = 0.2

var on_ground = false
var is_attacking = false
var is_dead = false


func die():
	is_dead = true
	velocity = Vector2(0, 0)
	$CollisionShape2D.set_deferred('disabled', true)
	$PlayerAnim.play('Dead')
	$Timer.start()
	

func _physics_process(delta):

	if is_dead == false:
		var xAxis = Input.get_joy_axis(0, 0)
		
		if abs(xAxis) > deadzone:
			if xAxis > 0 :
				if is_attacking == false or is_on_floor() == true:
					velocity.x = 100 * delta * ( SPEED * abs(xAxis))
					if is_attacking == false:
						$PlayerAnim.play('Run')
						$PlayerAnim.flip_h = false
						if sign($Position2D.position.x) == -1:
							$Position2D.position.x *= -1
			elif xAxis < 0 :
				if is_attacking == false or is_on_floor() == true:
					velocity.x = -100 * delta * ( SPEED * abs(xAxis))
					if is_attacking == false:
						$PlayerAnim.play('Run', true)
						$PlayerAnim.flip_h = true
						if sign($Position2D.position.x) == 1:
							$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_right"):
			velocity.x = 100 * delta * SPEED
			if is_attacking == false:
						$PlayerAnim.play('Run')
						$PlayerAnim.flip_h = false
						if sign($Position2D.position.x) == -1:
							$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -100 * delta * SPEED
			if is_attacking == false:
						$PlayerAnim.play('Run')
						$PlayerAnim.flip_h = true
						if sign($Position2D.position.x) == 1:
							$Position2D.position.x *= -1
		else:
			velocity.x = 0
			if on_ground && is_attacking == false:
				$PlayerAnim.play('Idle')
			
				
		if Input.is_action_just_pressed("jump"):
			if on_ground && is_attacking == false:
				velocity.y = JUMP_POWER
				on_ground = false
				
		if Input.is_action_just_pressed("shoot") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			$PlayerAnim.play('Attack')
			var fireball = FIREBALL.instance()
			# Get the fireball's initial position (1 or -1) and use it as a parameter for the fireball's direction
			fireball.set_fireball_direction(sign($Position2D.position.x))
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			
			
			
		velocity.y += GRAVITY
		
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0:
					$PlayerAnim.play('Jump')
				else:
					$PlayerAnim.play('Fall')
		
		velocity = move_and_slide(velocity, FLOOR)
		
		if Input.is_action_just_pressed("RestartLevel"):
			get_tree().change_scene('StageOne.tscn')
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Soldiers" in get_slide_collision(i).collider.name:
					die()

func _on_PlayerAnim_animation_finished():
	is_attacking = false



func _on_Timer_timeout():
	get_tree().change_scene('StageOne.tscn')
