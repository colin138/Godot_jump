extends KinematicBody2D

enum States{AIR = 1, FLOOR, LADDER, WALL}
var state = States.AIR

signal life_lost
signal coin_collected

var score : int = 0
var coins = 0
const speed : int = 230
const RUNSPEED : int = 450
const jumpForce : int = -1100
const gravity : int = 35
const FIREBALL = preload("res://fireball.tscn")

var lives : int = 3

var vel : Vector2 = Vector2(0,0)


onready var sprite : Sprite = get_node("Bloodknight")

func _physics_process(delta):	
	
	#print(state)
	match state:
		States.AIR:
			
			if is_on_floor():
				state = States.FLOOR
				continue
							
			if Input.is_action_pressed("move_left"):
				vel.x = lerp(vel.x,-speed,0.1) if vel.x > speed else lerp(vel.x,-speed,0.03)
				sprite.flip_h = true
		
			elif Input.is_action_pressed("move_right"):
				vel.x = lerp(vel.x,speed,0.1) if vel.x < speed else lerp(vel.x,speed,0.03)
				sprite.flip_h = false
			else:
				vel.x = lerp(vel.x,0,0.2)
			
			move_and_fall()
			fire()
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				
			if Input.is_action_pressed("move_left"):
				if Input.is_action_pressed("run"):
					vel.x = lerp(vel.x, -RUNSPEED, 0.1)
				else:
					vel.x = lerp(vel.x, -speed, 0.1)
				sprite.flip_h = true
		
			elif Input.is_action_pressed("move_right"):
				if Input.is_action_pressed("run"):
					vel.x = lerp(vel.x,RUNSPEED,0.1)
				else:
					vel.x = lerp(vel.x,speed,0.1)
				
				sprite.flip_h = false
			else:
				vel.x = lerp(vel.x,0,0.2)
			
			if Input.is_action_just_pressed("jump") and is_on_floor():
				vel.y = jumpForce
				$Sound_Jump.play()
				state = States.AIR
				
			move_and_fall()
			fire()
	
func fire():
	if Input.is_action_just_pressed("fireball"):
		var direction = 1 if not sprite.flip_h else -1 
		var f = FIREBALL.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position.y
		f.position.x = position.x + 25 * direction
	
func move_and_fall():
	# gravity	
	print(vel.x)
	vel.y = vel.y + gravity
	vel = move_and_slide(vel, Vector2.UP)
	
	

func _on_Fallzone_body_entered(body):
	get_tree().change_scene("res://Main.tscn")
	

func bounce():
	vel.y += jumpForce * 0.65
	
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
		
	#Input.action_release("move_left")
	#Input.action_release("move_right")
	
	$Timer.start()
	
	
	


func _on_Timer_timeout():
	set_modulate(Color(1, 1, 1, 1))
