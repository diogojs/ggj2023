extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var history: RichTextLabel = $ColorRect/RichTextLabel
onready var _input: LineEdit = $ColorRect/LineEdit
var prompt = "\n[color=green]user@archie:~$[/color] "

# Called when the node enters the scene tree for the first time.
func _ready():
	history.bbcode_text = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	history.bbcode_text += prompt

func _on_text_entered(new_text: String):
	_input.clear()
	
	var command = new_text.strip_edges()
	if command.empty():
		return

	add_text(prompt + command)
	if _validate(command):
		add_text(run_command(command))
	else:
		add_text("\n[color=red]" + command + "[/color] : invalid command")

func add_text(text: String):
	history.bbcode_text += text

func _validate(command: String) -> bool:
	var exec = command.substr(0, command.find(" "))
	return exec in ["cat"]

func run_command(command: String) -> String:
	var exec_end = command.find(" ")
	var exec = command.substr(0, exec_end)
	var args = [] if (exec_end == -1) else command.substr(exec_end + 1).split(" ")

	if exec == "cat":
		return cat(args)
	else:
		return "Gurizada esqueceu de cobrir esse comando"
		
func cat(args: Array) -> String:
	if args.empty():
		return "\n[color=red]Usage:[/color] cat <file>"
	return "\n"

func _on_access_denied(message: String):
	add_text(message)
