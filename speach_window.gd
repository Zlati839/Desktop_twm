extends Window
var font := load("res://Terminus-TTF-Bold-700.ttf")
@onready var text: RichTextLabel = $TextureRect/RichTextLabel
var rng = RandomNumberGenerator.new()
var words = ""
var text_done = false
var lock1 = false
var lock2 = false
# Called when the node enters the scene tree for the first time.
var greeting_voice = ["Hello!" , "Greetings" , "Nice to see you agian", "How have you been ?" , "Hi agian" ]
var teleport_voice = ["Whats this ?", "Whats over here ?" , "I will just move a litle ", "How about over here ?" ]
var drag_voice = ["Release me !" , "Why are you moving me ?" , "What are you doing ?" , "You could have just asked"]
func _ready() -> void:
	var d = rng.randf_range(0, 4)
	words = greeting_voice[d]
	text.add_theme_font_override("normal_font", font)
	text.add_theme_font_size_override("normal_font_size", 16)
	printText(words)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text_done == true:
		await get_tree().create_timer(1.0).timeout
		visible = false
		text_done = false
		words = ""
		text.text = ""
		lock2 = false
		lock1 = false
	
func printText(texxt) -> void:
	visible = true
	var txt = texxt
	for i in txt:
		text.text += i
		await get_tree().create_timer(0.06).timeout
	text_done = true

func Teleport_Voice():
	if not lock1:
		var d = rng.randf_range(0, 3)
		words = teleport_voice[d]
		printText(words)
		lock1 = true
	
func Drag_Voice():
	if not lock2:
		var d = rng.randf_range(0, 3)
		words = drag_voice[d]
		printText(words)
		lock2 = true
	
