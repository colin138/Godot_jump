extends CanvasLayer

var lives = 3

func _ready():
	$lives_left.text = String(lives)

func _physics_process(delta):
	if lives == 0:
		get_tree().change_scene("res://Main.tscn")


func _on_Player_life_lost():
	lives = lives - 1
	_ready()
