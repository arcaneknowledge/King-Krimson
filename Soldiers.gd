extends KinematicBody2D

export(int) var speed = 22
export(int) var hp = 2
const GRAVITY = 10
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1
var is_dead = false

func dead():
	hp -= 1
	if hp <= 0:
		is_dead = true
		$CollisionShape2D.call_deferred('set_disabled', true)
		velocity = Vector2(0, 0)
		$AnimatedSprite.play('Dead')
		$Timer.start()

func _physics_process(delta):

	if is_dead == false:
		if direction == -1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		velocity.x =100 * delta * speed * direction
		$AnimatedSprite.play('Walking')
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Player" in get_slide_collision(i).collider.name:
				get_slide_collision(i).collider.die()

func _on_Timer_timeout():
	queue_free()
