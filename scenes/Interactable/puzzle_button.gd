extends StaticBody3D

var activated := false

func activate():
	if activated:
		return
	
	activated = true
