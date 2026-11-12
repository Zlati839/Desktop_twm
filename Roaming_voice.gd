extends Window
@onready var text: RichTextLabel = $TextureRect/RichTextLabel
@onready var sprite: TextureRect = $TextureRect/TextureRect

var walking_voice = ["I ESCAPED!!" , "Im out !" , "So much space" , "Im free " , "YAAAAAY !!" , "I will explore for a little "]
var Sometimes_vocie =["So fun !!!" , "Look at me go!" , "Its good to streatch a little !" , "Just walking around" , "I can see your icons more clearly !" , "I can climb !" , "I cant get hurt from falling !!!","Finally, some room to move!" , "Maybe I should explore more often." ,"You're not going to leave me out here, right?","Hey! I can see my own window from here!" ]
var Climbing_voice = ["Up we go !" , "Look what i can do !" , " Im a spider !!" , "Im really high !" ]
var words = ""
var rng = RandomNumberGenerator.new()
var font := load("res://Terminus-TTF-Bold-700.ttf")
var speaking = false
var main: Node2D
var Walk: Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().transparent_bg = true
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 0))
	#=======================Window settings====================
	transparent = true
	transparent_bg = true
	borderless = true
	always_on_top = true
	get_viewport().transparent_bg = true
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 0))
	set_flag(Window.FLAG_NO_FOCUS, true)
	set_flag(Window.FLAG_MOUSE_PASSTHROUGH, true)
	var sometimes_timer = Timer.new()
	add_child(sometimes_timer)
	sometimes_timer.wait_time = 8
	sometimes_timer.start()
	sometimes_timer.timeout.connect(Sometimes_Voice)

func printText(texxt) -> void:
	if speaking:
		return
	switch_faceRandom()
	speaking = true
	visible = true
	text.text = ""
	var txt = str(texxt)
	for i in txt:
		text.text += i
		await get_tree().create_timer(0.06).timeout
	switch_faceNormal()
	await get_tree().create_timer(1.6).timeout
	visible = false
	text.text = ""
	speaking = false

func Exiting_voice():
	var d = rng.randf_range(0, walking_voice.size() - 1)
	words = walking_voice[d]
	text.add_theme_font_override("normal_font", font)
	text.add_theme_font_size_override("normal_font_size", 16)
	printText(words)
func Sometimes_Voice():
	var chance = rng.randi_range(0,3)
	if main.OutTheWindow and chance == 2:
		var d = rng.randi_range(0, Sometimes_vocie.size() - 1)
		words = Sometimes_vocie[d]
		printText(words)
func Climbing_Voice():
	if main.OutTheWindow and Walk.climbing:
		var chance  =  rng.randi_range(0, 4)
		if chance == 2:
			var d = rng.randi_range(0, Climbing_voice.size() - 1)
			words = Climbing_voice[d]
			printText(words)

func switch_faceTalking() -> void :
	sprite.texture = load("res://Talking_Twm.png")
func switch_faceNormal() -> void :
	sprite.texture = load("res://Nromal_Twm.png")
func switch_faceHappier() -> void :
	sprite.texture = load("res://Happier_twm.png")
func switch_faceHappy() -> void :
	sprite.texture = load("res://Happy_Twm.png")

func switch_faceRandom() -> void :
	var Chance = 1
	if not Walk.climbing:
		Chance = rng.randi_range(1,3)
	match Chance:
		1:
			switch_faceTalking()
		2:
			switch_faceHappy()
		3:
			switch_faceHappier()

func _process(delta: float) -> void:
	if not main.OutTheWindow :
		visible = false
	if Input.is_key_pressed(KEY_0):
		Sometimes_Voice()
