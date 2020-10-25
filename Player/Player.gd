extends KinematicBody2D

const MAX_SPEED = 200
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

#attaching the animationplayer node in the scene tree to the variable
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
# called when node and children are ready, chilren _readys run first
func _ready():
	print("Hello, world!")
	animationTree.active = true

# called every tick
func _process(delta):
#	match state:
#		MOVE:
#			move_state(delta)
#		ROLL:
#			pass
#		ATTACK:
#			attack_state(delta)
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# prevents the character from being faster when running diagnolly
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# Sets the idle blendspace 2d to match the velocity
		# makes sure the player will be in the correct idle position when they stop moving
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		# not in attack state because we dont want the player to be able to change direction mid animation
		animationTree.set("parameters/Attack/blend_position", input_vector)

		print(state)
		match state:
			MOVE:
				# sets to run animation
				animationState.travel("Run")
			ROLL:
				pass
			ATTACK:
				animationState.travel("Attack")
		# delta needs to be applied to anything that shouldnt be frame dependent and should work in real time
		# like player movement
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		match state:
			MOVE:
				# sets to run animation
				animationState.travel("Idle")
			ROLL:
				pass
			ATTACK:
				animationState.travel("Attack")
		# slows the player down to zero speed
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# prevents colission errors in corners
	if Input.is_action_just_pressed("ui_fire"):
		animationState.travel("Attack")
		state = ATTACK
		shoot_fireball()
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state = MOVE
	
func shoot_fireball():
	var FireballScene = load("res://World/Fireball.tscn")
	var fireball = FireballScene.instance()
	var fireball_rotation = self.get_angle_to(get_global_mouse_position())  
	
	var world = get_tree().current_scene
	fireball.global_position = global_position
	fireball.rotation = fireball_rotation
	world.add_child(fireball)
	fireball.apply_impulse(Vector2(), ( get_global_mouse_position() - global_position ) * SHOOT_SPEED)
