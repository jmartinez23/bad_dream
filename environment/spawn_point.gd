# 01. tool
# 02. class_name
# 03. extends
extends Spatial

# 04. # docstring

# 05. signals
# 06. enums
# 07. constants
# 08. exported variables
export (Array, PackedScene) var enemy_packed_scenes
export (float) var spawn_time = 5.0

# 09. public variables
# 10. private variables
# 11. onready variables
onready var spawn_timer: Timer = $SpawnTimer
onready var instanantiation_node: Node = get_parent()

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
func _ready():
	randomize()
	var next_spawn_time: float = rand_range(spawn_time * 0.75, spawn_time * 1.25)
	spawn_timer.start(next_spawn_time)


# 14. remaining built-in virtual methods
# 15. public methods
# 16. private methods

func _instantiate_enemy():
	var index: int = round(rand_range(0, enemy_packed_scenes.size() - 1))
	var enemy_instance: Node = enemy_packed_scenes[index].instance()
	enemy_instance.transform = transform
	instanantiation_node.add_child(enemy_instance)
	var next_spawn_time = rand_range(spawn_time * 0.75, spawn_time * 1.25)
	spawn_timer.start(next_spawn_time)


func _on_SpawnTimer_timeout():
	_instantiate_enemy()
