extends Window
var main: Node2D
@onready var ShutOff = $TextureRect/Button
@onready var Settings = $TextureRect/Button2
@onready var ExitWindow = $TextureRect/Button3
@onready var Back = $TextureRect/Button4
@onready var Text = $TextureRect/RichTextLabel
@onready var More = $TextureRect/Button5
@onready var Common = $TextureRect/Button6
@onready var Less = $TextureRect/Button7
@onready var On = $TextureRect/Button9
@onready var Off = $TextureRect/Button8
@onready var text2 = $TextureRect/RichTextLabel2
var settings = false
var teleport_pressed = false
var talking = false
var pressedMore = false
var pressedNetural = false
var pressedLess = false
var quality = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Back.visible = false
	Text.visible = false
	More.visible = false
	Common.visible = false
	Less.visible = false
	On.visible = false
	Off.visible = false
	text2.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	main.speach.Goodbye_Voice()

func _on_button_2_button_down() -> void:
	settings = true
	if settings:
		ShutOff.visible = false
		Settings.visible = false
		ExitWindow.visible = false
		Back.visible = true
		Text.visible = true
		More.visible = true
		Common.visible = true
		Less.visible = true
		On.visible = true
		Off.visible = true
		text2.visible = true
		
func _on_button_3_button_down() -> void:
	if not main.speach.speaking:
		main.Walk_Out()
		main.WalkingVoice.Exiting_voice()



func _on_button_4_button_down() -> void:
	settings = false
	if not settings:
		ShutOff.visible = true
		Settings.visible = true
		ExitWindow.visible = true
		Back.visible = false
		Text.visible = false
		More.visible = false
		Common.visible = false
		Less.visible = false
		On.visible = false
		Off.visible = false
		text2.visible = false
	Detect_Quality()
	if quality > 0 :
		main.speach.SettingsGood_Voice()
	if quality == 0 :
		main.speach.SettingsNetural_Voice()
	if quality < 0 :
		main.speach.SettingsBad_Voice()
	quality = 0
	teleport_pressed = false
	talking = false
	pressedMore = false
	pressedNetural = false
	pressedLess = false
	print(str(quality))


func _on_button_5_button_down() -> void:
	main.speach.UpdateTimer(15)
	talking = true
	pressedMore = true
	pressedNetural = false
	pressedLess = false


func _on_button_6_button_down() -> void:
	main.speach.UpdateTimer(9)
	talking = true
	pressedMore = false
	pressedNetural = true
	pressedLess = false

func _on_button_7_button_down() -> void:
	main.speach.UpdateTimer(3)
	talking = true
	pressedMore = false
	pressedNetural = false
	pressedLess = true

func _on_button_8_button_down() -> void:
	main.Tel = true
	teleport_pressed = true
func _on_button_9_button_down() -> void:
	main.Tel = false
	teleport_pressed = true

func Detect_Quality():
	if teleport_pressed:
		if not  main.Tel:
			quality -= 1
		if main.Tel : 
			quality += 1
	if talking :
		if pressedMore:
			quality += 1
		if pressedLess:
			quality -= 1
		if pressedNetural:
			if quality > 0 :
				quality -= 1
			if quality < 0 :
				quality += 1
	
