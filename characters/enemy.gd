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
export var score_value: int = 1
export var sink_speed: float = 0.5

# 09. public variables
# 10. private variables
var _sinking: bool = false

# 11. onready variables
onready var health: Health = $Health
onready var death_timer: Timer = $DeathTimer
onready var _state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
# 14. remaining built-in virtual methods
func _physics_process(delta):
	if _sinking:
		_sink(delta)

# 15. public methods
func hurt(damage: int):
	health.health -= damage

# 16. private methods
func _on_Health_health_depleted():
	_state_machine.travel("death")
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
