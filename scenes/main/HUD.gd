extends CanvasLayer


func _on_Player_angle_changed(angle):
	$PlaceholderAngle.text = "Angle: %s" % int(-rad2deg(angle))
