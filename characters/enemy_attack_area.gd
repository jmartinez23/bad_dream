# 01. tool
# 02. class_name
# 03. extends
extends Area

# 04. # docstring

# 05. signals
# 06. enums
# 07. constants
# 08. exported variables
export(int) var damage = 10

# 09. public variables
# 10. private variables
var _dealing_damage:  bool = false
# 11. onready variables
onready var _hit_timer = $HitTimer

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
# 14. remaining built-in virtual methods
# 15. public methods
# 16. private methods
func _on_AttackArea_body_entered(body):	
	if body is Player:
		_start_dealing_damage(body as Player)


func _on_AttackArea_body_exited(body):
	if body is Player:
		_stop_dealing_damage(body as Player)


func _start_dealing_damage(player: Player):
	_dealing_damage = true
	while _dealing_damage:
		player.hurt(damage)
		_hit_timer.start()
		yield(_hit_timer, "timeout")


func _stop_dealing_damage(player: Player):
	_dealing_damage = false


func _on_HitTimer_timeout():
    pass