extends KinematicBody2D

enum States{AIR = 1, FLOOR, LADDER, WALL}
var state = States.AIR

signal life_lost
signal coin_collected

var score : int = 0
var coins = 0
var direction = 1
var last_direction_jumped = 0
var on_ladder : bool = false
const speed : int = 230
const RUNSPEED : int = 450
const jumpForce : int = -1100
const gravity : int = 35
const FIREBALL = preload("res://fireball.tscn")

var lives : int = 3

var vel : Vector2 = Vector2(0,0)


onready var sprite : Sprite = get_node("Bloodknight")

func _physics_process(delta):	
	
	
	match state:
		States.AIR:
			
			if is_on_floor() and vel.y == 0:
				last_direction_jumped = 0
				state = States.FLOOR
				continue
				
			elif is_near_wall():
				state = States.WALL
				continue
				
			elif should_climb_ladder():
				state = States.LADDER
				continue
				
							
			if Input.is_action_pressed("move_left"):
				vel.x = lerp(vel.x,-speed,0.1) if vel.x > speed else lerp(vel.x,-speed,0.03)
				sprite.flip_h = true
		
			elif Input.is_action_pressed("move_right"):
				vel.x = lerp(vel.x,speed,0.1) if vel.x < speed else lerp(vel.x,speed,0.03)
				sprite.flip_h = false
			else:
				vel.x = lerp(vel.x,0,0.2)
			
			set_direction()
			move_and_fall(false)
			fire()
			
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
				
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
				continue
				
			set_direction()
			move_and_fall(false)
			fire()
			
		States.WALL:				
						
			if is_on_floor():
				last_direction_jumped = 0
				state = States.FLOOR				
				continue
			elif not is_near_wall():
				state = States.AIR
				continue
			
			if direction != last_direction_jumped and Input.is_action_pressed("jump") and 	((Input.is_action_pressed("move_left") and direction == 1) or (Input.is_action_pressed("move_right") and direction == -1)):
					last_direction_jumped = direction
					vel.x = 450 * -direction
					vel.y = jumpForce * 0.7
					$Sound_Jump.play()
					state = States.AIR
			
			
			move_and_fall(true)
			
		
		States.LADDER:
			if not on_ladder:
				state = States.AIR
				continue
			elif is_on_floor() and Input.is_action_pressed("down") and vel.y == 0:
				state = States.FLOOR
				Input.action_release("down")
				Input.action_release("up")
				continue
			elif Input.is_action_just_pressed("jump"):
				Input.action_release("down")
				Input.action_release("up")
				vel.y = jumpForce * 0.7
				state = States.AIR
				continue
			
			#if Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
				
			
			if Input.is_action_pressed("up"):
				vel.y = -speed
			elif Input.is_action_pressed("down"):
				vel.y = speed
			else:
				vel.y = lerp(vel.y, 0, 0.3)
				
				
			if Input.is_action_pressed("move_left"):
				vel.x = -speed/6
			elif Input.is_action_pressed("move_right"):
				vel.x = speed/6
			else:
				vel.x = lerp(vel.x, 0, 0.3)
				
			vel = move_and_slide(vel, Vector2.UP)
	

func should_climb_ladder() -> bool:
	if on_ladder and (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		return true
	else:
		return false

func set_direction():
	
	direction = 1 if not sprite.flip_h else -1
	$WallChecker.rotation_degrees = 90 * -direction

func is_near_wall():
	return $WallChecker.is_colliding() and not $WallChecker.get_collider().is_in_group("one_way")

func fire():
	if Input.is_action_just_pressed("fireball") and not is_near_wall():
		#direction = 1 if not sprite.flip_h else -1
		var f = FIREBALL.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position.y
		f.position.x = position.x + 25 * direction
	
func move_and_fall(slow_fall : bool):
	# gravity
	if slow_fall:
		vel.y = clamp(vel.y, jumpForce, 175)	
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


func _on_LadderChecker_body_entered(body):
	on_ladder = true


func _on_LadderChecker_body_exited(body):
	on_ladder = false
