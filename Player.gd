extends KinematicBody2D

var score : int = 0
var coins = 0
var speed : int = 200
var jumpForce : int = 600
var gravity : int = 800

var vel : Vector2 = Vector2()

onready var sprite : Sprite = get_node("Bloodknight")

func _physics_process(delta):
	
		
	vel.x = 0
	
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
		sprite.flip_h = true
		
	if Input.is_action_pressed("move_right"):
		vel.x += speed
		sprite.flip_h = false
		
	vel = move_and_slide(vel, Vector2.UP)
	
	# gravity
	vel.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y -= jumpForce
		
	vel.x = lerp(vel.x,0,0.2)

	

func _on_Fallzone_body_entered(body):
	get_tree().change_scene("res://Main.tscn")
	

	
	
	
	
	
