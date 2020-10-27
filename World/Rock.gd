extends StaticBody2D

onready var sprite = $Sprite
onready var animatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.visible = false; # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_area_entered(area):
	breakRock()



func breakRock():
	animatedSprite.visible = true
	sprite.visible = false
	animatedSprite.frame = 0
	animatedSprite.play("Animate")


func _on_AnimatedSprite_animation_finished():
	queue_free()
