extends Sprite
class_name Character

func hurt():
	$AnimationPlayer.play("hurt")

func die():
	$AnimationPlayer.play("die")

func jump():
	$AnimationPlayer.play("jump")
