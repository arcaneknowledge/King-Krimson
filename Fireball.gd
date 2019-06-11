extends Area2D

const SPEED = 100

var velocity = Vector2()
var direction = 1
var fire_out = false

func _ready():
	pass

func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$FireballAnim.flip_h = true

func _physics_process(delta):
	if fire_out == false:
		velocity.x = SPEED * delta * direction
		translate(velocity)
		$FireballAnim.play('Firing')
	else:
		velocity.x = 0
		translate(velocity)
		$FireballAnim.play("EnemyHit")
		
		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	fire_out = true
	if "Soldiers" in body.name:
		body.dead()
	#if body.is_dead:
	#	body.queue_free()
	$FireballAnim/FireballTime.start()

func _on_FireballTime_timeout():
	queue_free()
