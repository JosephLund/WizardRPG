extends RigidBody2D

onready var sprite = $Sprite
onready var animatedSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D

func _ready():
	self.set_gravity_scale(0)
	collisionShape.disabled = true;
	animatedSprite.visible = false;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("ui_fire"):
#		play_fireball_effect()




func play_fireball_effect():
	animatedSprite.visible = true
	sprite.visible = false
	animatedSprite.frame = 0
	animatedSprite.play("Animate")


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_Hurtbox_area_entered(area):
	print("entered")
	play_fireball_effect()


func _on_Hurtbox_body_entered(body):
	pass
