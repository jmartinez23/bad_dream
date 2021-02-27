# 01. tool
# 02. class_name
class_name CharacterAudioPlayer
# 03. extends
extends AudioStreamPlayer3D

# 04. # docstring

# 05. signals
# 06. enums
# 07. constants
# 08. exported variables
export (AudioStream) var hurt_sound
export (AudioStream) var death_sound

# 09. public variables
# 10. private variables
# 11. onready variables

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
# 14. remaining built-in virtual methods
# 15. public methods
# 16. private methods
func _on_Health_health_changed():
	stream = hurt_sound
	play()

func _on_Health_health_depleted():
	yield(self, "finished") 
	stream = death_sound
	play()
