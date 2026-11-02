# Pop up menu 
# Can wlak out of their window 
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
var greeting_voice = ["Hello!" , "Greetings" , "How have you been ?",   ]
var teleport_voice = ["Whats this ?", "Whats over here ?" , "I will just move a litle ", "How about over here ?" , "Surprise!" , "Just exploring!" ]
var drag_voice = ["Release me !" , "Why are you moving me ?" , "What are you doing ?" , "You could have just asked"]
var sometimes_voice = ["What are you working on ?" , "Do you think Niko remembers me  ?" , "Do programs also have motion sickness ?" , "I wounder if im able to ecape this window " ,"Can you see everything I do?" , "Sometimes I forget how small this window is.","What's the weather like outside?","Make sure to take a break every now and then.","Make sure you're getting enough sleep.", "It's nice having someone to talk to.", "I wonder if Niko is doing alright." , "Remember to stretch a little!" , "I hope I'm not distracting you."]
var shake_voice = ["Why did you have to do this ?" , "Stop it !!!" , "Programs do have motion sickness !" , "I dont feel good " , "I dont like this !", "I think I'm going to be sick..."]

func _ready() -> void:
	UpdateActiveApps()
	var my_timer = Timer.new()
	add_child(my_timer) 
	my_timer.wait_time = 20
	my_timer.timeout.connect(UpdateActiveApps)
	my_timer.start()
	#===============================App specific voicelines ====================
	if desktop_iconsGet("Spotify.lnk"):
		sometimes_voice.append("I see you have spotify , what kind of music do you listend to ?")
		sometimes_voice.append("Do you listen to any of my worlds music ? ")
	if desktop_iconsGet("OneShot.url"):
		greeting_voice.append("Nice to see you agian")
		greeting_voice.append("Hi agian" )
		sometimes_voice.append("You still have me on your system after sending niko home ?")
		sometimes_voice.append("You still have the game installed?")
		sometimes_voice.append("I suppose some memories are worth keeping.")
	if desktop_iconsGet("OneShot.url") == false and  desktop_iconsGet("OneShot World Machine Edition.url") == false:
		greeting_voice.append("Hello , nice to meet you !")
		greeting_voice.append("Hello im The World Machine !")
	if  desktop_iconsGet("OneShot World Machine Edition.url") :
		greeting_voice.append("Nice to see you agian")
		greeting_voice.append("Hi agian" )
	if desktop_iconsGet("Terraria.url"):
		sometimes_voice.append("You have Terraira ? OneShot is better")
	if desktop_iconsGet("Steam.lnk"):
		sometimes_voice.append("MY PROGRAM IS BEING SOLD ON STEAM !?!?!?!?")
	if desktop_iconsGet("Krita.url"):
		sometimes_voice.append("Do you like drawing on krita ?")
		sometimes_voice.append("Do you use krita often ?")
	if desktop_iconsGet("Visual Studio Code.lnk"):
		sometimes_voice.append("Do program often ?")
	if desktop_iconsGet("OneShot.url") and desktop_iconsGet("OneShot World Machine Edition.url") :
		sometimes_voice.append("You bought my software twice ?")
	#==========================Icon specifix dialog ==============
	var icon_count = desktop_iconsCoubt()
	if icon_count > 20 :
		sometimes_voice.append("is it aways this messy around here ?")
		sometimes_voice.append("Its really messy in here")
	if icon_count <= 20 :
		sometimes_voice.append("Nice ! An organised desktop")
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
	sometimes_timer.wait_time = 12
	sometimes_timer.start()
	sometimes_timer.timeout.connect(Sometimes_Voice)
	
	#====================systme uptime====================
	var total_seconds = get_windows_uptime()
	var uptime_hour = int(total_seconds / 3600)
	var uptime_min = int(total_seconds / 60) % 60
	var Uptime =  str(uptime_hour) + " hours and " +  str(uptime_min) + " min "
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
		d = rng.randf_range(0, greeting_voice.size() - 1)
		
	#=======================Window settings====================
	set_flag(Window.FLAG_NO_FOCUS, true)
	set_flag(Window.FLAG_MOUSE_PASSTHROUGH, true)
	
	#======================Greeting text======================
	words = greeting_voice[d]
	text.add_theme_font_override("normal_font", font)
	text.add_theme_font_size_override("normal_font_size", 16)
	printText(words)
	print(sometimes_voice.size())
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
		await get_tree().create_timer(0.06).timeout
	if not dizzy:
		main.Normal()
		switch_faceNormal()
	await get_tree().create_timer(1.6).timeout
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

#========================System checking comands =========================
func get_windows_uptime() -> int:
	var output = []
	var args = ["-Command", "(Get-Counter '\\System\\System Up Time').CounterSamples[0].CookedValue"]
	
	var exit_code = OS.execute("powershell.exe", args, output, true)
	
	if exit_code == 0 and output.size() > 0:
		return output[0].strip_edges().to_float()
	
	return -1.0 # Failed to retrieve
func desktop_iconsCoubt() -> int:
	var dir := DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP))
	if dir == null:
		return -1
	return dir.get_files().size() + dir.get_directories().size()
func desktop_iconsGet(keyword : String ) -> bool:
	var dir := DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP))
	if dir == null:
		return false
	var files := dir.get_files()
	for f in dir.get_files() :
		var ext := f.get_extension().to_lower()
		if (ext == "lnk" or ext == "url") and f.to_lower() == keyword.to_lower()  :
			return true
	return false
func get_active_apps(process_name : String) -> bool:
	var output = []
	var exit_code = OS.execute("tasklist.exe",["/FI", "IMAGENAME eq " + process_name],output,true)
	if output.size() > 0:
				return output[0].to_lower().contains(process_name.to_lower())
	return false
func UpdateActiveApps():
	if get_active_apps("Discord.exe"):
		sometimes_voice.append("I see you have Discord opened ")
		sometimes_voice.append("I wish Discord worked between worlds too ")
	if get_active_apps("obs64.exe"):
		sometimes_voice.append("Am i being recorded ?")
	if get_active_apps("twitch.exe"):
		sometimes_voice.append("Are you a streamer ?")
	if get_active_apps("Spotify.exe"):
		sometimes_voice.append("I see you have Spotify opened")
	if get_active_apps("OneShot.exe"):
		printText("See you in my world!!!!")
		printText("I will be waiting for you in my world")
