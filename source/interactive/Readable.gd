extends Sprite

signal access_denied
export var file_content: String = "Secret potato"

func interage():
	emit_signal("access_denied", "Read file:\n" + file_content)

func on_access_denied():
	emit_signal("access_denied", "You cannot read this file. Permission denied.")
