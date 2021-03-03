# 01. tool
# 02. class_name
# 03. extends
extends MarginContainer

# 04. # docstring

# 05. signals
# 06. enums
# 07. constants
# 08. exported variables
# 09. public variables
# 10. private variables
# 11. onready variables
onready var score_label = $HBoxContainer/CenterContainer/Label

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
# 14. remaining built-in virtual methods
# 15. public methods
# 16. private methods
func _on_Player_score_changed(score):
    score_label.text = str(score) 