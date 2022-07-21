extends KinematicBody2D


signal life_lost
signal coin_collected

var score : int = 0
var coins = 0
var speed : int = 200
var jumpForce : int = 650
var gravity : int = 850

var lives : int = 3

var vel : Vector2 = Vector2()


onready var sprite : Sprite = get_node("Bloodknight")

func _physics_process(delta):	
		
	
	
	if Input.is_action_pressed("move_left"):
		vel.x = -speed
		sprite.flip_h = true
		
	if Input.is_action_pressed("move_right"):
		vel.x = speed
		sprite.flip_h = false
		
	vel = move_and_slide(vel, Vector2.UP)
	
	# gravity
	vel.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y -= jumpForce
		
	vel.x = lerp(vel.x,0,0.2)

	

func _on_Fallzone_body_entered(body):
	get_tree().change_scene("res://Main.tscn")
	

func bounce():
	vel.y -= jumpForce * 0.65
	
func add_coin():
	coins = coins + 1
	emit_signal("coin_collected")
	
func ouch(var posx):
	
	lives = lives - 1
	print("lives left: " + String(lives))
	emit_signal("life_lost")
	
	if lives == 0:
		get_tree().change_scene("res://Main.tscn")
	
	set_modulate(Color(1, 0.3, 0.3, 0.5))
	vel.y -= jumpForce * 0.4
	
	if position.x < posx:
		vel.x = -800
	elif position.x > posx:
		vel.x = 800
		
	Input.action_release("move_left")
	Input.action_release("move_right")
	
	$Timer.start()
	
	
	


func _on_Timer_timeout():
	set_modulate(Color(1, 1, 1, 1))
