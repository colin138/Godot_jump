extends KinematicBody2D



var speed = 50
var vel = Vector2()
export var direction = 1
export var detects_cliffs = true

onready var sprite : Sprite = get_node("Sprite/Ghost")

func _ready():	
	if direction == -1:
		sprite.flip_h = true
		
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_cliffs
	
	if detects_cliffs:
		set_modulate(Color(0.6, 0.6, 1, 1))
	

func _physics_process(delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		sprite.flip_h = not sprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	vel.y += 25
	
	vel.x = speed * direction
	

	
	
	
	vel = move_and_slide(vel, Vector2.UP)


func _on_top_checker_body_entered(body):
	#$AnimatedSprite.play("squashed")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0,false)
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_layer_bit(4, false)
	$sides_checker.set_collision_mask_bit(0, false)
	$Timer.start()
	body.bounce()
	
	
	
func _on_sides_checker_body_entered(body):	
	body.ouch(position.x)


func _on_Timer_timeout():
	queue_free()
