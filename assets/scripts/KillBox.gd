extends Area

func _on_KillBox_body_exited(body):
	if(body is StaticBody):
		return
	body.kill()
