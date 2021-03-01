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
onready var ray_cast: RayCast = $RayCast

# 12. optional built-in virtual _init method
# 13. built-in virtual _ready method
# 14. remaining built-in virtual methods
func _physics_process(delta):
	pass


# 15. public methods
func shoot() -> PhysicsBody:
	var collider: Object = null
	if _can_shoot:
		_can_shoot = false
		ray_cast.enabled = true
		ray_cast.force_raycast_update()
		var target: Vector3 = ray_cast.get_collision_point()
		var mesh: CylinderMesh = bullet_ray.mesh
		mesh.height = (target - self.global_transform.origin).length()
		bullet_ray.translation.z = -mesh.height / 2
		self.visible = true
		if audio_stream_player.playing:
			audio_stream_player.stop()
		audio_stream_player.play()
		show_timer.start()
		shoot_timer.start()
		collider = ray_cast.get_collider()
		ray_cast.enabled = false

	if collider is PhysicsBody:
		return collider as PhysicsBody
	return null

# 16. private methods
func _on_ShowTimer_timeout():
	self.visible = false


func _on_ShootTimer_timeout():
	_can_shoot = true