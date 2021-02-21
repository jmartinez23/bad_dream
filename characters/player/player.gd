extends KinematicBody

var direction: Vector3 = Vector3.ZERO
var _is_moving: bool = false

export (float) var speed = 6.0
export (NodePath) var camera

onready var _camera: Camera = get_node(camera)

onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		var ray: Vector3 = Vector3.ZERO
		var ray_origin: Vector3 = _camera.project_ray_origin(event.position)
		ray = ray_origin + _camera.project_ray_normal(event.position) * 100
		var space_state = get_world().direct_space_state
		var collision_result = space_state.intersect_ray(ray_origin, ray, [self], 2, true, false)
		if collision_result.has("position"):
			var look_at_point = Vector3(collision_result["position"].x, 0.0, collision_result["position"].z)
			look_at(look_at_point, Vector3.UP)

func _process(delta):
	direction.x = Input.get_action_strength("ui_up") -Input.get_action_strength("ui_down")
	direction.z = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if direction == Vector3.ZERO:
		_is_moving = false
		state_machine.travel("idle")
	else:
		direction = direction.normalized()
		_is_moving = true
		state_machine.travel("move")



func _physics_process(delta):
	if _is_moving:
		move_and_slide(direction * speed, Vector3.UP)
