extends AnimatedSprite



func _ready():
	self.frame = 0
	self.play("default")


func _on_AnimatedSprite_animation_finished():
	queue_free()
