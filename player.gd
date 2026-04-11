extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 4.5
var mouse_sensitivity = 0.002
var hp = 10
var ammo = 30
@onready var camera = $Camera3D
@onready var anim := $Rogue_Hooded/AnimationPlayer
var was_on_floor = true
var camera_pitch = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var direction = Vector3.ZERO


	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	direction = direction.normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED


	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0.0


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
	
	var is_now_on_floor = is_on_floor()


	if was_on_floor and not is_now_on_floor:
		anim.play("Player/Jump_Start")
	
	if not is_on_floor() and velocity.y < 0:
		anim.play("Player/Jump_Idle")

	if not was_on_floor and is_now_on_floor:
		anim.play("Player/Jump_Land")

	was_on_floor = is_now_on_floor
	
	var forward = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var side = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if not is_on_floor():
		pass
	elif direction.length() > 0:
		if abs(forward) > abs(side):
			if forward > 0:
				anim.play("Player/Walking_A")
			else:
				anim.play("Player/Walking_Backwards")
		else:
			if side > 0:
				anim.play("Player/Running_Strafe_Right")
			else:
				anim.play("Player/Running_Strafe_Left")
	else:
		anim.play("Player/Melee_2H_Idle")
	
func shoot():
	var camera = $Camera3D
	var from = camera.global_position
	var to = from - camera.global_transform.basis.z * 100

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_bodies = true

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		if result and result.collider.has_method("take_damage"):
			result.collider.take_damage(1)

			
func take_damage(amount):
	hp -= amount
	print("Player HP:", hp)
	if hp <= 0:
		die()

func die():
	print("Zginąłeś")
	get_tree().reload_current_scene()

func _input(event):

	if event.is_action_pressed("shoot"):
		shoot()
		
	if event is InputEventMouseMotion:

		rotate_y(-event.relative.x * mouse_sensitivity)


		camera_pitch -= event.relative.y * mouse_sensitivity
		camera_pitch = clamp(camera_pitch, -1.5, 1.5)

		camera.rotation.x = camera_pitch
