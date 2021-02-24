class_name CameraRig
extends Spatial

export (NodePath) var target_path
export (float) var damp_time = 1.0

onready var _target: Spatial = get_node(target_path)
onready var tween: Tween = $Tween

func _process(delta):
	var current_position := self.transform.origin
	var target_position: Vector3 = _target.transform.origin
	if tween.interpolate_property(self, "translation", current_position, target_position,
			damp_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT):
		tween.reset_all()
		tween.start()
