extends Window
var main: Node2D
var font := load("res://Terminus-TTF-Bold-700.ttf")
@onready var text: RichTextLabel = $TextureRect/RichTextLabel
@onready var sprite: TextureRect = $TextureRect/TextureRect
#A bunch of vars
var rng = RandomNumberGenerator.new()
var words = ""
var text_done = false
var tapped = false
var tapped_sometimes = false
var username = ""
var d = 0
var pressed = false
var speaking = false
var dizzy = false
# Called when the node enters the scene tree for the first time.
var greeting_voice = ["Hello!" , "Greetings" , "Nice to see you agian", "How have you been ?" , "Hi agian" ]
var teleport_voice = ["Whats this ?", "Whats over here ?" , "I will just move a litle ", "How about over here ?" , "Surprise!" , "Just exploring!" ]
var drag_voice = ["Release me !" , "Why are you moving me ?" , "What are you doing ?" , "You could have just asked"]
var sometimes_voice = ["What are you working on ?" , "Do you think Niko remembers me  ?" , "Do programs also have motion sickness ?" , "Its really messy in here" , "I wounder if im able to ecape this window " ,"Can you see everything I do?" , "Sometimes I forget how small this window is.","What's the weather like outside?","Make sure to take a break every now and then.","Make sure you're getting enough sleep.", "It's nice having someone to talk to.", "If i draw will it be considered ai generated ?" , "I wonder if Niko is doing alright." , "Remember to stretch a little!" , "I hope I'm not distracting you."]
var shake_voice = ["Why did you have to do this ?" , "Stop it !!!" , "Programs do have motion sickness !" , "I dont feel good " , "I dont like this !", "I think I'm going to be sick..."]

func _ready() -> void:
	#=======================Time specific dialog =============
	var time = Time.get_time_dict_from_system()
	var hour = time.hour
	if hour >= 22 or hour < 6:
		greeting_voice.append("Isnt it kinda late for you to be awake ?")
		greeting_voice.append("Isnt it kinda late for you to be awake ?")
		greeting_voice.append("Isnt it kinda late for you to be awake ?")
		greeting_voice.append("Isnt it kinda late for you to be awake ?")
	if hour >= 6 and hour < 13:
		greeting_voice.append("Good Morning !")
		greeting_voice.append("Good Morning !")
	#===================sometimes timer==================
	var sometimes_timer = Timer.new()
	add_child(sometimes_timer)
	sometimes_timer.wait_time = 9
	sometimes_timer.start()
	sometimes_timer.timeout.connect(Sometimes_Voice)
	
	#====================systme uptime====================
	var total_seconds = get_windows_uptime()
	var uptime_hour = int(total_seconds / 3600)
	var uptime_min = int(total_seconds / 60) % 60
	var Uptime =  str(uptime_hour) + " hours and " +  str(uptime_min) + " min "
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	sometimes_voice.append("This system has been running for " + Uptime)
	
	if uptime_hour > 20:
		sometimes_voice.append("Its good to restart your system from time to time, just saying")
	if uptime_hour > 119:
		sometimes_voice.append("Your system has been running for " + Uptime + " A restart would be neat ")
		sometimes_voice.append("Take a break ")
	
	#========================Os Name======================
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	else:
		username = "Player"
		
	if username.to_lower() in ["twm", "the world machine"]:
		greeting_voice.append("Hello also you are not me , nice try ")
	
	elif username.to_lower() in ["niko"]:
		greeting_voice.append("There is only one person i know with that name , and its not you ")
	else:
		greeting_voice.append("Hello " + username + "!")
		d = rng.randf_range(6, greeting_voice.size() - 1)
		
	#=======================Window settings====================
	set_flag(Window.FLAG_NO_FOCUS, true)
	set_flag(Window.FLAG_MOUSE_PASSTHROUGH, true)
	
	#======================Greeting text======================
	words = greeting_voice[d]
	text.add_theme_font_override("normal_font", font)
	text.add_theme_font_size_override("normal_font_size", 16)
	printText(words)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Testing thing
	if Input.is_key_pressed(KEY_0):
		if not pressed:
			Shake_Voice()
			pressed = true
	else:
		pressed = false
	
# To display words little by little , LIKE IN ONESHOT !!!!
func printText(texxt) -> void:
	if not dizzy:
		main.Speak()
		switch_faceRandom()
	elif dizzy :
		switch_faceDizzy()
	if speaking:
		return
	speaking = true
	visible = true
	text.text = ""
	var txt = str(texxt)
	for i in txt:
		text.text += i
		await get_tree().create_timer(0.04).timeout
	if not dizzy:
		main.Normal()
		switch_faceNormal()
	await get_tree().create_timer(1.5).timeout
	main.Normal()
	visible = false
	text.text = ""
	tapped = true
	tapped_sometimes = false
	speaking = false
	dizzy = false


# ALL THE VOICES !!!!!!!!!!!!
func Teleport_Voice():
		var d = rng.randf_range(0, teleport_voice.size() - 1)
		words = teleport_voice[d]
		printText(words)
func Drag_Voice(): 
	if tapped :
		tapped = false
		var d = rng.randi_range(0,  drag_voice.size() - 1)
		words = drag_voice[d]
		printText(words)
func Sometimes_Voice():
	var chance  =  rng.randi_range(0, 5)
	if chance == 0 and not tapped_sometimes :
		tapped_sometimes = true
		var d = rng.randi_range(0, sometimes_voice.size() - 1)
		words = sometimes_voice[d]
		printText(words)
func Shake_Voice():
	var d = rng.randf_range(0, shake_voice.size() - 1)
	words = shake_voice[d]
	printText(words)
	
# Sprite Switch
func switch_faceRandom() -> void :
	sprite.texture = load("res://Talking_Twm.png")
func switch_faceNormal() -> void :
	sprite.texture = load("res://Nromal_Twm.png")
func switch_faceDizzy() -> void:
	sprite.texture = load("res://Dizzy_twm.png")

func get_windows_uptime() -> int:
	var output = []
	var args = ["-Command", "(Get-Counter '\\System\\System Up Time').CounterSamples[0].CookedValue"]
	
	var exit_code = OS.execute("powershell.exe", args, output, true)
	
	if exit_code == 0 and output.size() > 0:
		return output[0].strip_edges().to_float()
	
	return -1.0 # Failed to retrieve
