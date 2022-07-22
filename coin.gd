extends Area2D

#signal coin_collectd


func _on_coin_body_entered(body):
	#queue_free()
	$AnimationPlayer.play("bounce")
	body.add_coin()
	$Sound_CoinCollected.play()
	#emit_signal("coin_collectd")
	set_collision_mask_bit(0, false)
	

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


