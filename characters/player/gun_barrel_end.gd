# 01. tool
# 02. class_name
class_name GunBarrelEnd
# 03. extends
extends Spatial

# 04. # docstring

# 05. signals
# 06. enums
# 07. constants
# 08. exported variables
# 09. public variables
# 10. private variables
var _can_shoot: bool = true
# 11. onready variables
onready var barrel_light: OmniLight = $BarrelLight
onready var bullet_ray: MeshInstance = $BulletRay
onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
onready var show_timer: Timer = $ShowTimer
onready var shoot_timer: Timer = $ShootTimer

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
# 14. remaining built-in virtual methods
# 15. public methods
func shoot(length: float):
	if _can_shoot:
		_can_shoot = false
		var mesh: CylinderMesh = bullet_ray.mesh
		mesh.height = length
		bullet_ray.translation.z = -mesh.height / 2
		self.visible = true
		if audio_stream_player.playing:
			audio_stream_player.stop()
		audio_stream_player.play()
		show_timer.start()
		shoot_timer.start()

# 16. private methods
func _on_ShowTimer_timeout():
	self.visible = false


func _on_ShootTimer_timeout():
	_can_shoot = true