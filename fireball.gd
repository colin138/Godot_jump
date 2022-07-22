extends KinematicBody2D

var vel = Vector2(0,0)
var direction = 1
const SPEED = 800
const GRAVITY = 22
const BOUNCE = -300

func _ready():
	vel.x = SPEED * direction
	#vel.y = SPEED * direction
	
func _physics_process(delta):
	
	$Sprite.rotation_degrees += 25 * direction
	
	vel.y += GRAVITY
	
	if is_on_floor():
		vel.y += BOUNCE
	
	if is_on_wall():
		queue_free()
	
	vel = move_and_slide(vel, Vector2.UP)





func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Timer_timeout():
	$AudioStreamPlayer.play()
