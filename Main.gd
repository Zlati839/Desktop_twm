extends Node2D
@onready var Buddy = $AnimatedSprite2D
@onready var Buddy_Boddy = $AnimatedSprite2D/Polygon2D
var drag_offset = Vector2.ZERO
var calculated_polygon: PackedVector2Array = PackedVector2Array()
var dragging = false
var rng = RandomNumberGenerator.new()
var random_time = rng.randf_range(10, 40)
var D = preload("res://SpeachWindow.tscn")
var speach: Window = D.instantiate()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#======================2ND WINDOW============
	speach.visible = false
	speach.transparent = true
	speach.transparent_bg = true
	speach.borderless = true
	speach.always_on_top = true
	speach.size = Vector2i(800, 200)
	speach.position = Vector2i(200, 200)
	add_child(speach)
	speach.visible = true
	#===================SETTINGS======================
	get_viewport().transparent_bg = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	#=======================TIMERS=========================
	var my_timer = Timer.new()
	var blink_timer = Timer.new()
	add_child(my_timer) 
	add_child(blink_timer)
	my_timer.wait_time = random_time
	blink_timer.wait_time = 6
	blink_timer.timeout.connect(blink)
	my_timer.timeout.connect(teleport)
	my_timer.start()
	blink_timer.start()
	

func teleport() -> void:
	if not dragging:
		var max_coordsX = DisplayServer.screen_get_size().x
		var max_coordsY = DisplayServer.screen_get_size().y
		var safe_max_x = max_coordsX - get_window().size.x #get_window.size is window size
		var safe_max_y = max_coordsY - get_window().size.y
		var random_x = rng.randf_range(0, safe_max_x)
		var random_y = rng.randf_range(0, safe_max_y)
		get_window().position = Vector2i(random_x, random_y)
		random_time = rng.randf_range(10, 40)
		if rng.randf() < 0.3:
			speach.Teleport_Voice()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var buddy_screen = Vector2(get_window().position) + Buddy.global_position + Buddy.global_position 
	speach.position.x = int(buddy_screen.x - speach.size.x / 2 - 50)
	speach.position.y = int(buddy_screen.y)
	var world_space = PackedVector2Array()
	var stuff = Buddy_Boddy.get_global_transform_with_canvas()
	for p in Buddy_Boddy.polygon:
		var stuffmore = stuff * p
		world_space.append(stuffmore)
	calculated_polygon = world_space
	get_window().mouse_passthrough_polygon = world_space
	
	if dragging:
		print("draging")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Geometry2D.is_point_in_polygon(get_window().get_mouse_position(), calculated_polygon):
			DisplayServer.window_start_drag()
			dragging = true
	else :
		dragging = false
func blink() -> void:
	Buddy.play("Blink")
