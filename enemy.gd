extends CharacterBody3D

@export var speed = 2.5
@export var hp = 3
@export var attack_range = 2.0
@export var attack_cooldown = 1.0

@onready var anim := $Barbarian/AnimationPlayer

enum State { IDLE, WALK, ATTACK, DEAD }
var state = State.IDLE

var attack_timer = 0.0
var player = null
var is_attacking = false


func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if player == null or state == State.DEAD:
		return

	attack_timer -= delta

	var direction = (player.global_position - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)

	
	var target = player.global_position
	target.y = global_position.y
	look_at(target, Vector3.UP)

	
	if distance > attack_range:
		state = State.WALK
		is_attacking = false

		velocity.x = lerp(velocity.x, direction.x * speed, 0.1)
		velocity.z = lerp(velocity.z, direction.z * speed, 0.1)

	else:
		velocity.x = 0
		velocity.z = 0

		if attack_timer <= 0 and !is_attacking:
			attack_timer = attack_cooldown
			start_attack()

	
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0

	move_and_slide()

	update_animation()



func update_animation():
	match state:
		State.IDLE:
			if anim.current_animation != "Enemy/Melee_Unarmed_Idle":
				anim.play("Enemy/Melee_Unarmed_Idle")

		State.WALK:
			if anim.current_animation != "Enemy/Walking_A":
				anim.play("Enemy/Walking_A")

		State.ATTACK:
			if anim.current_animation != "Enemy/Melee_Unarmed_Attack_Punch_A":
				anim.play("Enemy/Melee_Unarmed_Attack_Punch_A")



func deal_damage():
	if player and global_position.distance_to(player.global_position) <= attack_range:
		player.take_damage(1)



func take_damage(amount):
	if state == State.DEAD:
		return

	hp -= amount
	print("Enemy HP:", hp)

	
	if player:
		var dir = (global_position - player.global_position).normalized()
		velocity += dir * 4.0

	if hp <= 0:
		die()

func start_attack():
	if is_attacking:
		return

	is_attacking = true
	state = State.ATTACK

	await get_tree().create_timer(0.3).timeout
	deal_damage()

	is_attacking = false

func die():
	state = State.DEAD
	anim.play("Enemy/Death_A")
	await anim.animation_finished
	queue_free()



func _on_animation_finished(anim_name):
	if "Enemy/Melee_Unarmed_Attack_Punch_A" in anim_name:
		is_attacking = false
		state = State.IDLE
