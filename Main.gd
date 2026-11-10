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
var W = preload("res://WalkOut.tscn")
var VW = preload("res://Roaming_voice.tscn")
var speach: Window = D.instantiate()
var PopUp: Window = P.instantiate()
var Walk: Window = W.instantiate()
var WalkingVoice: Window = VW.instantiate()
var speak = false
var lock = true
var Tel = true
var direction = 0
var previuos = 0
var previuos_direction = 0
var shaken_times = 0
var starting = false
var OutTheWindow = false
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
	PopUp.main = self
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
	PopUp.size = Vector2i(270, 340)
	PopUp.position = Vector2i(200, 200)
	add_child(PopUp)
	#=======================TIMERS=========================
	var my_timer = Timer.new()
	var blink_timer = Timer.new()
	var Out_chance = Timer.new()
	add_child(my_timer) 
	add_child(blink_timer)
	add_child(Out_chance)
	my_timer.wait_time = random_time
	blink_timer.wait_time = 6
	Out_chance.wait_time = 20
	blink_timer.timeout.connect(blink)
	my_timer.timeout.connect(teleport)
	Out_chance.timeout.connect(ChanceToWalkOut)
	my_timer.start()
	blink_timer.start()
	Out_chance.start()
	
	

func teleport() -> void:
	if not dragging and not OutTheWindow and Tel:
		var max_coordsX = DisplayServer.screen_get_size().x
		var max_coordsY = DisplayServer.screen_get_size().y
		var safe_max_x = max_coordsX - get_window().size.x #get_window.size is window size
		var safe_max_y = max_coordsY - get_window().size.y
		var random_x = rng.randf_range(0, safe_max_x)
		var random_y = rng.randf_range(0, safe_max_y)
		get_window().position = Vector2i(random_x, random_y)
		random_time = rng.randf_range(25, 50)
		UpdatePopUp()
		if rng.randf() < 0.3:
			speach.Teleport_Voice()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
var i = 0
func _process(delta: float) -> void:
	if Walk.dragging:
		if Overlapping():
			WalkIn()
			speach.BackToWindow_Voice()
	if Walk.walkL or Walk.climbing or Walk.falling or Walk.dragging :
		UpdateWalkingVoice()
	detect_shake()
	if dragging:
		UpdatePopUp()
	if dragging or speach.speaking:
		UpdateText()
	if dragging and not speak and lock:
		lock = false
		var Chance_Drag = rng.randi_range(0,3)
		if Chance_Drag == 2:
			speach.Drag_Voice()
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
			shaken_times = 0
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and not OutTheWindow:
		if Geometry2D.is_point_in_polygon(get_window().get_mouse_position(), calculated_polygon):
			UpdatePopUp()
			PopUp.visible = not PopUp.visible 
	
	if event is InputEventKey and event.keycode == KEY_E and event.pressed and not OutTheWindow:
		speach.Drag_Voice()

func blink() -> void:
	if not OutTheWindow and (not speach.dizzy or speach.speaking):
		Buddy.play("Blink")
func Speak() -> void:
	Buddy.play("Talking_animation")
func Normal() -> void:
	Buddy.play("new_animation")
func Happy() -> void:
	Buddy.play("Happy")
func Happier() -> void:
	Buddy.play("Happier")
func Guilty() -> void:
	Buddy.play("Guilty")
func Sleepy() -> void:
	Buddy.play("Sleepy")
func Shocked() -> void:
	Buddy.play("Shocked")
func Worried() -> void:
	Buddy.play("Worried")
func UpdateText() -> void:
	var buddy_screen = Vector2(get_window().position) + Buddy.global_position + Buddy.global_position
	speach.position.x = int(buddy_screen.x - speach.size.x / 2 - 50)
	speach.position.y = int(buddy_screen.y)
func UpdatePopUp() -> void:
	var buddy_screen = Vector2(get_window().position) + Buddy.global_position + Buddy.global_position 
	PopUp.position.x = int(buddy_screen.x - speach.size.x / 1.75 )
	PopUp.position.y = int(buddy_screen.y - speach.size.y )
func UpdateWalkingVoice() -> void:
	var buddy_WALK = Vector2(Walk.position) + Walk.Buddy.position
	WalkingVoice.position = Vector2i(
		int(buddy_WALK.x - WalkingVoice.size.x / 2),
		int(buddy_WALK.y - WalkingVoice.size.y)
	)


func detect_shake() -> void :
	if not OutTheWindow:
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
		
func Walk_Out():
	var buddy_screen = Vector2(get_window().position) + Buddy.global_position + Buddy.global_position 
	var buddy_WALK = Vector2(get_window().position) + Vector2(WalkingVoice.position)
	WalkingVoice.position.x = int(buddy_WALK.x )
	WalkingVoice.position.y = int(buddy_WALK.y)
	WalkingVoice.visible = false
	WalkingVoice.transparent = true
	WalkingVoice.transparent_bg = true
	WalkingVoice.borderless = true
	WalkingVoice.always_on_top = true
	WalkingVoice.size = Vector2i(800, 200)
	add_child(WalkingVoice)
	Walk.position.x = buddy_screen.x
	Walk.position.y = buddy_screen.y
	Buddy.play("Empty")
	OutTheWindow = true
	PopUp.visible = false
	add_child(Walk)
func Overlapping():
	var rectWindow = Rect2i(get_window().position , get_window().size)
	var rectWalking = Rect2i(Walk.position , Walk.size)
	return rectWindow.intersects(rectWalking)
func ChanceToWalkOut():
	var random_chance = rng.randi_range(1, 20)
	if random_chance == 5:
		Walk_Out()
func WalkIn():
	Buddy.play("new_animation")
	OutTheWindow = false
	remove_child(Walk)
	Walk.dragging = false
