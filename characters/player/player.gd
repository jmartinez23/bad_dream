class_name Player
extends KinematicBody
# Used to control the Player

# exported variables
export (float) var speed = 6.0
export (NodePath) var camera_path
export (NodePath) var move_joystick_path
export (NodePath) var aim_joystick_path

# public variables
var direction: Vector3 = Vector3.ZERO

# private variables
var _is_moving: bool = false
var _look_at_point: Vector3
var _look_at_upadte_required: bool = false

# onready variables
onready var _camera: Camera = get_node(camera_path)
onready var _state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _move_joystick: Joystick = get_node(move_joystick_path)
onready var _aim_joystick: Joystick = get_node(aim_joystick_path)
onready var gun_barrel_end = $GunBarrelEnd
onready var gun_skeleton: Skeleton = $"PlayerControl/ControlGroup/Skeleton 2"

# Built-in virtual _ready method
func _ready():
	pass # Replace with function body.


# Remaining built-in virutal methods
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

	if _move_joystick.is_visible():
		direction.x = -_move_joystick.output.y
		direction.z = _move_joystick.output.x
	else:
		direction.x = Input.get_action_strength("ui_up") -Input.get_action_strength("ui_down")
		direction.z = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if _aim_joystick.is_visible():
		if not _aim_joystick.output == Vector2.ZERO:
			var look_vector: Vector2 = _aim_joystick.output
			_look_at_point = self.transform.origin + Vector3(-look_vector.y, 0.0, look_vector.x) * 100
			_look_at_upadte_required = true
			gun_barrel_end.shoot(10.0)
		elif not _move_joystick.output == Vector2.ZERO:
			var look_vector: Vector2 = _move_joystick.output
			_look_at_point = self.transform.origin + Vector3(-look_vector.y, 0.0, look_vector.x) * 100
			_look_at_upadte_required = true
	elif Input.is_mouse_button_pressed(1):
		gun_barrel_end.shoot(10.0)

	if direction.length() < 0.1:
		_is_moving = false
		_state_machine.travel("idle")
	else:
		direction = direction.normalized()
		_is_moving = true
		_state_machine.travel("move")

	_update_barrel_end_position()


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
