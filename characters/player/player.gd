class_name Player
extends KinematicBody
# Used to control the Player

# exported variables
export (float) var speed = 6.0
export (NodePath) var camera

# public variables
var direction: Vector3 = Vector3.ZERO

# private variables
var _is_moving: bool = false
var _look_at_point: Vector3
var _look_at_upadte_required: bool = false

# onready variables
onready var _camera: Camera = get_node(camera)
onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

# Built-in virtual _ready method
func _ready():
	pass # Replace with function body.


# Remaining built-in virutal methods
func _input(event):
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
	direction.x = Input.get_action_strength("ui_up") -Input.get_action_strength("ui_down")
	direction.z = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if direction.length() < 0.1:
		_is_moving = false
		state_machine.travel("idle")
	else:
		direction = direction.normalized()
		_is_moving = true
		state_machine.travel("move")


func _physics_process(delta):	
	if _look_at_upadte_required:
		look_at(_look_at_point, Vector3.UP)
		_look_at_upadte_required = false

	if _is_moving:
		move_and_slide(direction * speed, Vector3.UP)		
	else:
		move_and_slide(Vector3.ZERO, Vector3.UP)		
