extends RigidBody2D

onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var hitbox = $FireballHitBox/CollisionShape2D
var hit = false


func _ready():
	self.set_gravity_scale(0)
	collisionShape.disabled = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("ui_fire"):
#		play_fireball_effect()




func play_fireball_effect():
	sprite.visible = false
	var FireballEffectScene = load("res://Spells/Fireball/FireballEffect.tscn")
	var fireballEffect = FireballEffectScene.instance()
	
	var world = get_tree().current_scene
	fireballEffect.global_position = global_position
	world.add_child(fireballEffect)
	queue_free()


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_FireballHitBox_area_entered(_area):
	play_fireball_effect()
