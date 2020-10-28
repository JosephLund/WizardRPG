extends KinematicBody2D

const MAX_SPEED = 200
const ROLL_SPEED = 250
const ACCELERATION = 10000
const FRICTION = 10000
const SHOOT_SPEED = 1;

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

#attaching the animationplayer node in the scene tree to the variable
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox


# called when node and children are ready, chilren _readys run first
func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

# called every tick
func _process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# prevents the character from being faster when running diagnolly
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector 
		# Sets the idle blendspace 2d to match the velocity
		# makes sure the player will be in the correct idle position when they stop moving
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		if state == MOVE:
			animationState.travel("Run")
			# not in attack state because we dont want the player to be able to change direction mid animation
			animationTree.set("parameters/Attack/blend_position", input_vector)
			animationTree.set("parameters/Roll/blend_position", input_vector)
			roll_vector = input_vector
		
		if state != ROLL:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(roll_vector * MAX_SPEED, ACCELERATION * delta)
		# only want to be able to roll while moving
		if Input.is_action_just_pressed("ui_roll"):
			animationState.travel("Roll")
			state = ROLL
	else:
		if state == MOVE:
			animationState.travel("Idle")
		# slows the player down to zero speed
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	# prevents colission errors in corners
	if Input.is_action_just_pressed("ui_fire"):
		if Input.is_action_pressed("ui_spell_modifier_1"):
			shoot_fireball()
		elif Input.is_action_pressed("ui_spell_modifier_2"):
			teleport_player()
		else:
			animationState.travel("Attack")
			state = ATTACK




	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state = MOVE
	
	
func roll_animation_finished():
	state = MOVE
	
	
func roll_state(delta):
	pass

func shoot_fireball():
	var FireballScene = load("res://Spells/Fireball.tscn")
	var fireball = FireballScene.instance()
	var fireball_rotation = self.get_angle_to(get_global_mouse_position())  
	
	var world = get_tree().current_scene
	fireball.global_position = global_position
	fireball.rotation = fireball_rotation
	world.add_child(fireball)
	
	
	fireball.apply_impulse(Vector2(), ( get_global_mouse_position() - global_position ) * SHOOT_SPEED)
	

func teleport_player():
	self.global_position = get_global_mouse_position()
