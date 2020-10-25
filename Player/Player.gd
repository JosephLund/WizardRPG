extends KinematicBody2D

const MAX_SPEED = 200
const ACCELERATION = 10000
const FRICTION = 10000

var velocity = Vector2.ZERO

#attaching the animationplayer node in the scene tree to the variable
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
# called when node and children are ready, chilren _readys run first
func _ready():
	print("Hello, world!")

# called every physics tick
func _physics_process(delta):
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
		# sets to run animation
		animationState.travel("Run")
		# delta needs to be applied to anything that shouldnt be frame dependent and should work in real time
		# like player movement
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		# slows the player down to zero speed
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# prevents colission errors in corners
	velocity = move_and_slide(velocity)

