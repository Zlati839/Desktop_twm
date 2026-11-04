extends Node2D
@onready var Buddy = $Test1
@onready var Buddy_Boddy = $Test1/Polygon2D
var gravity = 3
var WalkingSpeed = 2
var rng = RandomNumberGenerator.new()
var random_time = rng.randf_range(2, 5)
var walkL = false
var walkR = false
var calculated_polygon: PackedVector2Array = PackedVector2Array()
var usable_rect = DisplayServer.screen_get_usable_rect()
var left_wall = 0
var right_wall = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wall = usable_rect.position.x 
	right_wall = usable_rect.size.x + usable_rect.position.x - get_window().size.x
	var window = get_window()
	get_viewport().transparent_bg = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	var my_timer = Timer.new()
	add_child(my_timer) 
	random_time
	my_timer.wait_time = random_time
	my_timer.timeout.connect(Walk)
	my_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var window = get_window()
	var target_y = usable_rect.position.y  - window.size.y + usable_rect.size.y
	get_window().position.y += gravity
	if  get_window().position.y > target_y :
		gravity = 0
	var world_space = PackedVector2Array()
	var stuff = Buddy_Boddy.get_global_transform_with_canvas()
	for p in Buddy_Boddy.polygon:
		var stuffmore = stuff * p
		world_space.append(stuffmore)
	calculated_polygon = world_space
	get_window().mouse_passthrough_polygon = world_space

func Walk():
	walkL = true
	var random = rng.randi_range(1, 4)
	match random:
		1:
			walkLeft()
		2:
			walkRight()
		3:
			pass
func walkRight():
	if walkL:
		var timer = 0.0
		var random = rng.randi_range(1, 4)
		while timer < random :
			if get_window().position.x > right_wall :
				walkL = false
				break
			get_window().position.x += WalkingSpeed
			await get_tree().create_timer(0.016).timeout
			timer += 0.016
		walkL = false
func walkLeft():
	if walkL:
		var timer = 0.0
		var random = rng.randi_range(1, 4)
		while timer < random :
			if  get_window().position.x < left_wall:
				walkL = false
				break
			get_window().position.x -= WalkingSpeed
			await get_tree().create_timer(0.016).timeout
			timer += 0.016
		walkL = false
