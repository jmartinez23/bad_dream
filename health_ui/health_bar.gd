# 01. tool
# 02. class_name
# 03. extends
extends MarginContainer

# 04. # docstring

# 05. signals
# 06. enums
# 07. constants
# 08. exported variables
export(NodePath) var player_health_path

# 09. public variables
# 10. private variables

# 11. onready variables
onready var player_health: Health = get_node(player_health_path)
onready var _health_slider: TextureProgress = $HBoxContainer/LayoutControl/TextureProgress

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
func _ready():
	_health_slider.max_value = player_health.get_max_health()
	_health_slider.value = player_health.get_health()

# 14. remaining built-in virtual methods
func _process(delta):
	pass
# 15. public methods
# 16. private methods


func _on_player_health_changed():
	_health_slider.value = player_health.get_health()


func _on_player_max_health_changed():
	_health_slider.max_value = player_health.get_max_health()
