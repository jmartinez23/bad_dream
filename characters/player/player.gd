# 01. tool
# 02. class_name
class_name Player

# 03. extends / 04. # docstring
extends KinematicBody
# Used to control the Player

# 05. signals
signal score_changed(score)

# 06. enums
# 07. constants
# 08. exported variables
export (float) var speed = 6.0
export (NodePath) var camera_path
export (NodePath) var move_joystick_path
export (NodePath) var aim_joystick_path

# 09. public variables
var direction: Vector3 = Vector3.ZERO
var score: int = 0 setget set_score, get_score

# 10. private variables
var _is_moving: bool = false
var _look_at_point: Vector3
var _look_at_upadte_required: bool = false
var _dead: bool = false


# 11. onready variables
onready var health: Health = $Health
onready var _camera: Camera = get_node(camera_path)
onready var _state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _move_joystick: Joystick = get_node(move_joystick_path)
onready var _aim_joystick: Joystick = get_node(aim_joystick_path)
onready var gun_barrel_end = $GunBarrelEnd
onready var gun_skeleton: Skeleton = $"PlayerControl/ControlGroup/Skeleton 2"

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
func _ready():
	pass # Replace with function body.


# 14. remaining built-in virtual methods
func _input(event):
	if not _move_joystick.is_visible():
		if event is InputEventMouseMotion:
			var ray: Vector3 = Vector3.ZERO
			var ray_origin: Vector3 = _camera.project_ray_origin(event.position)
			ray = ray_origin + _camera.project_ray_normal(event.position) * 100
			var space_state: PhysicsDirectSpaceState = get_world().direct_space_state
			var collision_result: Dictionary = space_state.intersect_ray(ray_origin, ray, [self], 2, true, false)
			if collision_result.has("position"):
				_look_at_point = collision_result["position"]
				var look_vector: Vector3 = _look_at_point - self.transform.origin
				look_vector.y = 0.0
				_look_at_point = self.transform.origin + look_vector * 100
				_look_at_upadte_required = true


func _process(delta):
	if _dead: 
		return
	if _move_joystick.is_visible():
		direction.x = -_move_joystick.output.y
		direction.z = _move_joystick.output.x
	else:
		direction.x = Input.get_action_strength("ui_up") -Input.get_action_strength("ui_down")
		direction.z = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	var shot_collider: PhysicsBody
	if _aim_joystick.is_visible():
		if not _aim_joystick.output == Vector2.ZERO:
			var look_vector: Vector2 = _aim_joystick.output
			_look_at_point = self.transform.origin + Vector3(-look_vector.y, 0.0, look_vector.x) * 100
			_look_at_upadte_required = true
			shot_collider = gun_barrel_end.shoot()
		elif not _move_joystick.output == Vector2.ZERO:
			var look_vector: Vector2 = _move_joystick.output
			_look_at_point = self.transform.origin + Vector3(-look_vector.y, 0.0, look_vector.x) * 100
			_look_at_upadte_required = true
	elif Input.is_mouse_button_pressed(1):
		shot_collider = gun_barrel_end.shoot()

	if shot_collider is Enemy:
		shot_collider.hurt(10)
		if not shot_collider.is_connected("died", self,  "_on_Enemy_died"):
			shot_collider.connect("died", self,  "_on_Enemy_died")

	if direction.length() < 0.1:
		_is_moving = false
		_state_machine.travel("idle")
	else:
		direction = direction.normalized()
		_is_moving = true
		_state_machine.travel("move")

	_update_barrel_end_position()


# 15. public methods
func hurt(damage: int):
	health.health -= damage

# 16. private methods
func _physics_process(delta):
	if _look_at_upadte_required:
		look_at(_look_at_point, Vector3.UP)
		_look_at_upadte_required = false

	if _is_moving:
		move_and_slide(direction * speed, Vector3.UP)
	else:
		move_and_slide(Vector3.ZERO, Vector3.UP)


func _update_barrel_end_position():
	var  barrel_end_bone_id: int = gun_skeleton.find_bone("gun_barrel_end")
	var barrel_end_transform: Transform = gun_skeleton.get_bone_global_pose(barrel_end_bone_id)

	var  barrel_stretch_bone_id: int = gun_skeleton.find_bone("gun_barrel_stretch")
	var barrel_stretch_transform: Transform = gun_skeleton.get_bone_global_pose(barrel_stretch_bone_id)

	var look_point_local: Vector3 = 2 * barrel_end_transform.origin - barrel_stretch_transform.origin
	var look_point_global: Vector3 = gun_skeleton.to_global(look_point_local)

	gun_barrel_end.transform.origin = self.to_local(gun_skeleton.to_global(barrel_end_transform.origin))
	gun_barrel_end.look_at(look_point_global, Vector3.UP)


func get_score() -> int:
	return score


func set_score(value: int):
	score = value
	emit_signal("score_changed", get_score())


func _on_Enemy_died(enemy: Enemy):
	self.score += enemy.score_value


func _on_Health_health_depleted():
	_dead = true
	_state_machine.travel("death")