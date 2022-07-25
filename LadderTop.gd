extends StaticBody2D

var above_ladder := false

func _physics_process(delta):
	if Input.is_action_pressed("down") and above_ladder:
		$CollisionShape2D.rotation_degrees = 180
		
	else:
		$CollisionShape2D.rotation_degrees = 0

func _on_AboveChecker_body_entered(body):
	above_ladder = true
	print("above ladder")
	

func _on_AboveChecker_body_exited(body):
	above_ladder = false
