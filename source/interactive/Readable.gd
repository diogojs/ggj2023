extends Sprite

signal access_denied

func interage():
	print("arquivo lido")
	
func on_access_denied():
	emit_signal("access_denied", "You cannot read this file. Permission denied.")
