extends Window
@onready var Buddy = $Test1
@onready var Buddy_Boddy = $Test1/Polygon2D
var gravity = 6
var WalkingSpeed = 2
var ClimbingSpeed = 3
var rng = RandomNumberGenerator.new()
var random_time = rng.randf_range(2, 5)
var walkL = false
var calculated_polygon: PackedVector2Array = PackedVector2Array()
var usable_rect = DisplayServer.screen_get_usable_rect()
var left_wall = 0
var right_wall = 0
var climbing = false
var dragging = false
var falling = false
var climbRight = false
var climbLeft = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transparent_bg = true
	transparent = true
	always_on_top = true
	Buddy.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	left_wall = usable_rect.position.x 
	right_wall = usable_rect.size.x + usable_rect.position.x - get_window().size.x
	var window = get_window()
	get_viewport().transparent_bg = true
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
	if  get_window().position.y > target_y  or climbing == true:
		gravity = 0
		falling = false
	elif dragging == true:
		gravity = 0
	else :
		gravity = 6
		falling = true
	var world_space = PackedVector2Array()
	var stuff = Buddy_Boddy.get_global_transform_with_canvas()
	for p in Buddy_Boddy.polygon:
		var stuffmore = stuff * p
		world_space.append(stuffmore)
	calculated_polygon = world_space
	get_window().mouse_passthrough_polygon = world_space

func Walk():
	if not walkL:
		walkL = true
		var random = rng.randi_range(1, 3)
		match random:
			1:
				walkRight()
			2:
				walkLeft()
			3:
				walkL = false
func walkRight():
	if not walkL or climbing or falling or dragging:
		walkL = false
		return
	var timer = 0.0
	var random = rng.randi_range(1, 4)
	Buddy.play("WalkRight")
	while timer < random :
		if get_window().position.x > right_wall :
			walkL = false
			climbRight = true
			Climbing()
			break
		get_window().position.x += WalkingSpeed
		await get_tree().create_timer(0.016).timeout
		timer += 0.016
	Buddy.play("Normal-right")
	walkL = false
func walkLeft():
	if not walkL or climbing or falling or dragging:
		walkL = false
		return
	Buddy.play("WalkLeft")
	var timer = 0.0
	var random = rng.randi_range(1, 4)
	while timer < random :
		if  get_window().position.x < left_wall :
			Climbing()
			walkL = false
			climbLeft = true
			break
		if  dragging :
			break
		get_window().position.x -= WalkingSpeed
		await get_tree().create_timer(0.016).timeout
		timer += 0.016
	Buddy.play("Normal_left")
	walkL = false
func Climb():
	if climbing:
		var timer = 0.0
		var random = rng.randf_range(0.5, 4.5)
		while timer < random :
			get_window().position.y -= ClimbingSpeed
			await get_tree().create_timer(0.016).timeout
			timer += 0.016
		if climbLeft:
			Buddy.play("Normal_left")
		if climbRight:
			Buddy.play("Normal-right")
		climbing = false
		climbLeft = false
		climbRight = false
func Climbing():
	var random = rng.randi_range(1, 4)
	match random:
		1, 2:
			climbing = true
			await Climb()
		3, 4:
			climbing = false
			climbLeft = false
			climbRight = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Geometry2D.is_point_in_polygon(get_window().get_mouse_position(), calculated_polygon):
			dragging = true
			DisplayServer.window_start_drag(get_window_id())
	else:
			dragging = false
	
