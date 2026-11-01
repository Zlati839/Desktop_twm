extends Node2D
@onready var Buddy = $AnimatedSprite2D
@onready var Buddy_Boddy = $AnimatedSprite2D/Polygon2D
var drag_offset = Vector2.ZERO
var calculated_polygon: PackedVector2Array = PackedVector2Array()
var dragging = false
var rng = RandomNumberGenerator.new()
var random_time = rng.randf_range(25, 50)
var D = preload("res://SpeachWindow.tscn")
var P = preload("res://PopUp.tscn")
var speach: Window = D.instantiate()
var PopUp: Window = P.instantiate()
var speak = false
var lock = true
var direction = 0
var previuos = 0
var previuos_direction = 0
var shaken_times = 0
var starting = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#===================SETTINGS======================
	get_viewport().transparent_bg = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	#======================Start anim======================
	starting = true
	Buddy.stop()
	Buddy.frame = 0 
	Buddy.play("Start_animation")
	await get_tree().create_timer(1.5).timeout
	starting = false
	
	previuos = get_window().position.x
	speach.main = self
	#======================2ND WINDOW============
	var buddy_screen = Vector2(get_window().position) + Buddy.global_position + Buddy.global_position 
	speach.visible = false
	speach.transparent = true
	speach.transparent_bg = true
	speach.borderless = true
	speach.always_on_top = true
	speach.size = Vector2i(800, 200)
	speach.position.x = int(buddy_screen.x - speach.size.x / 2 - 50)
	speach.position.y = int(buddy_screen.y)
	if not starting:
		add_child(speach)
		speach.visible = true
	#=====================3RD WINDOW==================
	#For later use rn work on more desktop voiclines 
	PopUp.visible = false
	PopUp.transparent = true
	PopUp.transparent_bg = true
	PopUp.borderless = true
	PopUp.always_on_top = true
	PopUp.size = Vector2i(270, 440)
	PopUp.position = Vector2i(200, 200)
	add_child(PopUp)
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
		random_time = rng.randf_range(25, 50)
		if rng.randf() < 0.3:
			speach.Teleport_Voice()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
var i = 0
func _process(delta: float) -> void:
	detect_shake()
	if dragging and not speak and lock:
		lock = false
		var Chance_Drag = rng.randi_range(0,3)
		if Chance_Drag == 2:
			speach.Drag_Voice()
	var buddy_screen = Vector2(get_window().position) + Buddy.global_position + Buddy.global_position 
	speach.position.x = int(buddy_screen.x - speach.size.x / 2 - 50)
	speach.position.y = int(buddy_screen.y)
	PopUp.position.x = int(buddy_screen.x - speach.size.x / 1.7 )
	PopUp.position.y = int(buddy_screen.y - speach.size.y * 2.2)
	var world_space = PackedVector2Array()
	var stuff = Buddy_Boddy.get_global_transform_with_canvas()
	for p in Buddy_Boddy.polygon:
		var stuffmore = stuff * p
		world_space.append(stuffmore)
	calculated_polygon = world_space
	get_window().mouse_passthrough_polygon = world_space

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Geometry2D.is_point_in_polygon(get_window().get_mouse_position(), calculated_polygon):
			dragging = true
			speak = false
			DisplayServer.window_start_drag()
	else:
			dragging = false
			lock = true
	if event is InputEventKey and event.keycode == KEY_E and event.pressed:
		speach.Drag_Voice()
func blink() -> void:
	if not speach.dizzy :
		Buddy.play("Blink")
func Speak() -> void:
	Buddy.play("Talking_animation")
func Normal() -> void:
	Buddy.play("new_animation")

func detect_shake() -> void :
	var current = get_window().position.x
	var movement = current - previuos 
	if dragging :
		direction = sign(movement)
		if direction != 0:
			if previuos_direction != 0 and direction != previuos_direction:
				shaken_times += 1
		if direction == -1:
			previuos_direction = -1
			previuos = get_window().position.x
		elif direction == 1:
			previuos_direction = 1
			previuos = get_window().position.x 
	if shaken_times > 17 :
		speach.dizzy = true
		Buddy.play("Dizzy_animation")
		speach.Shake_Voice()
		shaken_times = 0
		previuos_direction = 0
		previuos = get_window().position.x
		
