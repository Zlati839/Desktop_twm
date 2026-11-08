extends Window
var main: Node2D
@onready var ShutOff = $TextureRect/Button
@onready var Settings = $TextureRect/Button2
@onready var ExitWindow = $TextureRect/Button3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	main.speach.Goodbye_Voice()


func _on_button_2_button_down() -> void:
	pass


func _on_button_3_button_down() -> void:
	main.Walk_Out()
