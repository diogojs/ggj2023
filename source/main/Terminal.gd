extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var history: RichTextLabel = $ColorRect/RichTextLabel
onready var _input: LineEdit = $ColorRect/LineEdit
var prompt = "\nuser@archie:~$ "

# Called when the node enters the scene tree for the first time.
func _ready():
	history.text = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	history.text += prompt

func _on_text_entered(new_text):
	_input.clear()

	if new_text == "":
		return

	if _validate(new_text):
		history.text += prompt + new_text
	else:
		history.text += "\n" + new_text + ": invalid command"

func _validate(command: String) -> bool:
	return command == "cat"
		
