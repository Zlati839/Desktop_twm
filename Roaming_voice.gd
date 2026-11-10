extends Window
@onready var text: RichTextLabel = $TextureRect/RichTextLabel
var walking_voice = ["I ESCAPED!!" , "Im out !" , "So much space" , "Im free " , "YAAAAAY !!" , "I will explore for a little "]
var words = ""
var rng = RandomNumberGenerator.new()
var font := load("res://Terminus-TTF-Bold-700.ttf")
var speaking = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().transparent_bg = true
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 0))
	#=======================Window settings====================
	set_flag(Window.FLAG_NO_FOCUS, true)
	set_flag(Window.FLAG_MOUSE_PASSTHROUGH, true)


func printText(texxt) -> void:
	if speaking:
		return
	speaking = true
	visible = true
	text.text = ""
	var txt = str(texxt)
	for i in txt:
		text.text += i
		await get_tree().create_timer(0.06).timeout
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_0):
		var d = rng.randf_range(0, walking_voice.size() - 1)
		words = walking_voice[d]
		text.add_theme_font_override("normal_font", font)
		text.add_theme_font_size_override("normal_font_size", 16)
		printText(words)
