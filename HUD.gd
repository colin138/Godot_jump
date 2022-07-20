extends CanvasLayer

var coins = 0

func _ready():
	$Coins.text = String(coins)

func _physics_process(delta):
	if coins == 3:
		get_tree().change_scene("res://Main.tscn")

func _on_coin_collectd():
	coins = coins + 1
	_ready()
