# 01. tool
# 02. class_name
class_name Health

# 03. extends
extends Node

# 04. # docstring

# 05. signals
signal health_changed
signal health_depleted
signal max_health_changed

# 06. enums
# 07. constants
# 08. exported variables
export(int) var max_health = 100 setget set_max_health, get_max_health
export(int) var health = max_health setget  set_health, get_health

# 09. public variables
# 10. private variables
# 11. onready variables

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
# 14. remaining built-in virtual methods
# 15. public methods
func set_max_health(value):
	if value < 1:
		max_health = 1
	else:
		max_health = value

	if self.max_health < self.health:
		health = self.max_health
	emit_signal("max_health_changed")


func get_max_health() -> int:
	return max_health


func set_health(value):
	if value <= 0:
		if self.health <= 0:
			return
		health = 0
		emit_signal("health_depleted")
	elif value > max_health:
		health = max_health
	else:
		health = value

	emit_signal("health_changed")


func get_health() -> int:
	return health


# 16. private methods
