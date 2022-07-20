extends KinematicBody2D

var vel = Vector2()
export var direction = 1
export var detects_cliffs = true

onready var sprite : Sprite = get_node("Sprite/Ghost")

func _ready():	
	if direction == -1:
		sprite.flip_h = true
		
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_cliffs
	

func _physics_process(delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		sprite.flip_h = not sprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	vel.y += 20
	
	vel.x = 50 * direction
	

	
	
	
	vel = move_and_slide(vel, Vector2.UP)
