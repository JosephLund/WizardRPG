extends Sprite

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("idle")
	
func _process(_delta):
	var random = randf();
	
	if random < 0.001:
		play_blink()

func play_blink():
	randomize()
	animationPlayer.play("Blink")
	var offset : float = rand_range(0, animationPlayer.current_animation_length - 2)
	print(offset)
	animationPlayer.advance(offset)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Blink":
		animationPlayer.play("idle")
