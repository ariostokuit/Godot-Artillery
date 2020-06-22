extends KinematicBody2D

signal angle_changed

# Vehicle Properties will export as resource later
export var gravity = 200.0
export var speed = 20.0
export var elevation_speed = 20.0
export var max_elevation = -30.0
export var max_depression = 15.0

var velocity = Vector2()
var axis_direction = Vector2()
var angle_speed = deg2rad(elevation_speed)
var elevation_rad = deg2rad(max_elevation)
var depression_rad = deg2rad(max_depression)
onready var shell_spawn = $Barrel/ShellSpawn

func _ready():
	emit_signal("angle_changed", $Barrel.rotation)


func _process(delta):
	# Input polling Vehicle direction
	axis_direction = Vector2(0, 0)
	if Input.is_action_pressed("ui_left"):
		axis_direction.x += -1
	if Input.is_action_pressed("ui_right"):
		axis_direction.x += 1
	if Input.is_action_pressed("ui_up"):
		axis_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		axis_direction.y += 1
	
	# Vehicle direction
	# Temp fix for bug: https://github.com/godotengine/godot/issues/12335
	if axis_direction.x != 0:
		scale.x = scale.y * axis_direction.x


func _physics_process(delta):
	velocity.y += gravity * delta
	
	if is_on_floor():
		velocity.x = speed * axis_direction.x 
	
	if axis_direction.y != 0:
		$Barrel.rotation += angle_speed * delta * axis_direction.y
		if $Barrel.rotation <= elevation_rad:
			  $Barrel.rotation = elevation_rad
		elif $Barrel.rotation >= depression_rad:
			$Barrel.rotation = depression_rad
		emit_signal("angle_changed", $Barrel.rotation)
	
	move_and_slide(velocity, Vector2(0, -1), true)


func shoot():
	pass
