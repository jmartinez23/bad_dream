# 01. tool
# 02. class_name
class_name Enemy

# 03. extends
extends KinematicBody

# 04. # docstring

# 05. signals
signal died

# 06. enums
# 07. constants
# 08. exported variables
export var speed: float = 3.0
export var score_value: int = 1
export var sink_speed: float = 0.5
export var reach: float = 1.5

# 09. public variables
# 10. private variables
var _dead: bool = false
var _sinking: bool = false
var _navigation: Navigation = null
var _path: PoolVector3Array
var _path_node: int = 0
var _player: Spatial = null
var _target_position: Vector3

# 11. onready variables
onready var health: Health = $Health
onready var death_timer: Timer = $DeathTimer
onready var _state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _blood_particles = $BloodParticles
onready var _attack_area = $AttackArea

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
func _ready():
	_navigation = get_parent().get_node("Navigation")
	_player = get_parent().get_node("Player")
	_target_position = _player.global_transform.origin
	_move_to(_target_position)
# 14. remaining built-in virtual methods
func _physics_process(delta):
	if not _dead:
		var player_distance_with_target: float = (_player.global_transform.origin - _target_position).length()
		if player_distance_with_target > 0.1:
			_target_position = _player.global_transform.origin
		var enemy_distance_with_target: float = (global_transform.origin - _target_position).length()
		if enemy_distance_with_target > reach:
			_move_to(_target_position)
			if _path_node < _path.size():
				var direction: Vector3 = _target_position - _path[_path_node]
				if direction.length() < 1:
					_path_node += 1
				else:
					look_at(global_transform.origin - direction * 100, Vector3.UP)
					move_and_slide(direction.normalized() * speed, Vector3.UP)
					_state_machine.travel("move")
		else:
			_state_machine.travel("idle")



	if _sinking:
		_sink(delta)

# 15. public methods
func hurt(damage: int, global_position: Vector3 = Vector3.ZERO):
	health.health -= damage
	_blood_particles.global_transform.origin = self.global_transform.origin
	if self.name.match("Hellephant*"):
		_blood_particles.translate_object_local(Vector3(0.0, 1.0, -1.25))
	else:
		_blood_particles.translate_object_local(Vector3(0.0, 0.5, -0.5))
	_blood_particles.emitting = true

# 16. private methods
func _on_Health_health_depleted():
	_attack_area.monitoring = false
	_attack_area.monitorable = false
	_state_machine.travel("death")
	_dead = true
	emit_signal("died", self)
	death_timer.start()


func _sink(delta):
	global_transform.origin.y -= sink_speed * delta


func _on_DeathTimer_timeout():
	if not _sinking:
		_sinking = true
		death_timer.start()
	else:
		self.queue_free()


func _move_to(var target_position: Vector3):
	if not _navigation == null:
		_path = _navigation.get_simple_path(global_transform.origin, target_position)
		_path_node = 0
