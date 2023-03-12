extends CharacterBody3D

@onready var camera = $Camera3D;
@onready var anim_player = $AnimationPlayer;
@onready var muzzle_flash = $Camera3D/GUN/MuzzleFlash;

const SPEED = 6.0
const JUMP_VELOCITY = 6.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _unhandled_input(event):
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.005);
			camera.rotate_x(-event.relative.y * 0.005);
			camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2);
		if Input.is_action_just_pressed("shoot") and anim_player.current_animation != "shoot":
			play_shoot_effects()
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if Input.is_action_pressed("shift") : 
			velocity.x = direction.x * (SPEED * 1.5)
			velocity.z = direction.z * (SPEED * 1.5)
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if anim_player.current_animation != "shoot":
		if input_dir != Vector2.ZERO and is_on_floor():
			anim_player.play("move")
		else:
			anim_player.play("idle") 

	move_and_slide()

func play_shoot_effects():
	anim_player.stop()
	anim_player.play("shoot")
	muzzle_flash.restart()
	muzzle_flash.emitting = true;