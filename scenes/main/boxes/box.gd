extends RigidBody2D

@export var sprite:Sprite2D;
@export var collision:CollisionShape2D;

signal settled(height: float);
signal first_hit();

# Statics
const REQUIRED_STABLE_TIME:float = 0.25
const VELOCITY_THRESHOLD:float = 1.5
const LINEAR_DAMP:float = 3.0;
const ANGULAR_DAMP:float = 5.0;

# State
var peak_y:float = -INF;
var stable_time:float = 0.0

# Events
func _ready():
	set_physics_process(false);
	# Randomized size
	var scaling_factor = 1 # randf_range(0.75, 1.25);
	var new_scale = Vector2(scaling_factor, scaling_factor);
	collision.scale = new_scale;
	sprite.scale = new_scale;
	self.mass = scaling_factor;
	
	# Physics
	self.freeze = true;
	self.collision_layer = 0;
	self.collision_mask = 1;
	self.set_collision_mask_value(2, true)
	self.linear_damp = LINEAR_DAMP;
	self.angular_damp = ANGULAR_DAMP;

	# Color
	sprite.self_modulate = Color.from_ok_hsl(randf(), 0.25, 0.55);
	
	# Signals
	self.body_entered.connect(on_hit);

func _physics_process(delta):
	var moving:bool = self.linear_velocity.length() > VELOCITY_THRESHOLD or abs(self.angular_velocity) > 0.1;

	if moving: stable_time = 0.0;
	else: stable_time += delta;

	if stable_time >= REQUIRED_STABLE_TIME:
		var height = -get_highest_point()
		settled.emit(height);
		set_physics_process(false);

func on_hit(body: Node2D):
	call_deferred("set_contact_monitor", false);
	first_hit.emit();

# Functions
func enable():
	self.freeze = false;
	self.collision_layer = 1;
	self.contact_monitor = true;
	self.max_contacts_reported = 1;
	self.start_tracking();

func start_tracking():
	set_physics_process(true);

func get_highest_point() -> float:
	var shape = collision.shape
	var rect = shape.get_rect()
	var corners = [
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y)
	]

	var min_y = INF
	for corner in corners:
		var global_point = collision.global_transform * corner
		min_y = min(min_y, global_point.y)

	return min_y

func on_enter_freeze_zone():
	if self.linear_velocity.length() > VELOCITY_THRESHOLD: return;
	set_deferred("freeze", true);
