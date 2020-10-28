extends KinematicBody2D

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)


func _on_Hurtbox_area_entered(area):
	if(area.knockback_vector):
		knockback = area.knockback_vector * 120
	else:
		queue_free()
