extends Window
var main: Node2D
var WalkingVoice: Window
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
var leftSide = 0
var rightSide = 0
var ClimbingWindow = 0
var Climbed = false
var Over = false
var Carrying = false
var facing = ""
var JustStarted = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leftSide = get_window().position.x
	rightSide = get_window().position.x + get_window().size.x
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

var touching_main = false
func ColideWindow() -> void:
	if main == null or not main.OutTheWindow:
		touching_main = false
		return
	var walk_rect = Rect2(position, size)
	var main_rect = Rect2(main.get_window().position, main.get_window().size)
	var touching_now = walk_rect.intersects(main_rect)
	if touching_now and not touching_main and not Climbed:
		walkL = false
		DecideWindow()
	if not touching_now :
		Climbed = false
	touching_main = touching_now
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Carry()
	if Input.is_key_pressed(KEY_0):
		Carry()
	var main_top = main.get_window().position.y
	var main_left = main.get_window().position.x
	var main_right = main.get_window().position.x + main.get_window().size.x
	if not JustStarted:
		ColideWindow()
	var window = get_window()
	var target_y = usable_rect.position.y  - window.size.y + usable_rect.size.y
	get_window().position.y += gravity
	if  get_window().position.y > target_y  or climbing == true:
		gravity = 0
		falling = false
		JustStarted = false
	elif dragging == true:
		gravity = 0
	elif get_window().position.y + get_window().size.y <= main_top + 10 \
	and get_window().position.y + get_window().size.y >= main_top - 10 \
	and get_window().position.x + get_window().size.x > main_left \
	and get_window().position.x < main_right:
		gravity = 0
		falling = false
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
func CheckForDraggingPlace():
	var window = get_window()
	var target_y = usable_rect.position.y  - window.size.y + usable_rect.size.y
	if get_window().position.x > right_wall + 20 :
		get_window().position.x - 100
	if  get_window().position.x < left_wall - 20 :
		get_window().position.x = left_wall + 100
	if  get_window().position.y > target_y + 20:
		get_window().position.y = target_y - 100
	
func Walk():
	if not walkL and (not touching_main or Climbed):
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
	while timer < random and main.OutTheWindow:
		ColideWindow()
		if not walkL:
			break
		if get_window().position.x > right_wall :
			walkL = false
			climbRight = true
			Climbing()
			break
		get_window().position.x += WalkingSpeed
		await get_tree().create_timer(0.016).timeout
		facing = "Right"
		if not walkL:
			break
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
	while timer < random and main.OutTheWindow:
		ColideWindow()
		if not walkL:
			break
		if  get_window().position.x < left_wall :
			Climbing()
			walkL = false
			climbLeft = true
			break
		if  dragging :
			break
		get_window().position.x -= WalkingSpeed
		await get_tree().create_timer(0.016).timeout
		facing = "Left"
		if not walkL:
			break
		timer += 0.016
	Buddy.play("Normal_left")
	walkL = false
func Climb():
	if climbing:
		var timer = 0.0
		var random = rng.randf_range(0.5, 4.5)
		while timer < random and main.OutTheWindow:
			get_window().position.y -= ClimbingSpeed
			await get_tree().create_timer(0.016).timeout
			timer += 0.016
			if ClimbingWindow and OverWindow():
				ClimbingWindow = false
				Climbed = true
				break
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
			CheckForDraggingPlace()
	
func DecideWindow():
	var chance = rng.randi_range(1,3)
	match chance:
		1:
			var walk_side = position.x + size.x / 2
			var main_side = main.get_window().position.x + main.get_window().size.x / 2
			await ClimbOverWindow()
			if Climbed:
				falling = false
				walkL = true
				if walk_side < main_side:
					walkRight()
					Climbed = false
				else:
					walkLeft()
					Climbed = false
		2:
			WalkingVoice.Moving_Voice()
			Carrying = true
			var my_timer = Timer.new()
			add_child(my_timer) 
			random_time
			my_timer.wait_time = random_time
			my_timer.timeout.connect(func():
				Carrying = false
				my_timer.queue_free()
				Place())
			my_timer.start()
		3:
			var walk_side = position.x + size.x / 2
			var main_side = main.get_window().position.x + main.get_window().size.x / 2
			await ClimbOverWindow()
			if Climbed:
				falling = false
				walkL = true
				if walk_side < main_side:
					walkRight()
					Climbed = false
				else:
					walkLeft()
					Climbed = false
func ClimbOverWindow():
	if Climbed or climbing:
		return
	WalkingVoice.Window_Voice()
	ClimbingWindow = true
	climbing = true
	await Climb()
	Over = true
	
	
func OverWindow() -> bool :
	var walk_bottom = position.y + size.y
	var main_top = main.get_window().position.y
	return walk_bottom <= main_top 
	
func Carry():
	if Carrying:
		var walk_x = position.x - size.x / 2
		var walk_y = position.y 
		main.get_window().position.y = walk_y - main.get_window().size.y
		main.get_window().position.x = walk_x
func Place():
	var walk_x 
	if facing == "Right":
		walk_x = position.x - main.get_window().size.x 
	elif facing == "Left":
		walk_x = position.x + main.get_window().size.x 
	var walk_y = position.y 
	main.get_window().position.y = walk_y 
	main.get_window().position.x = walk_x
