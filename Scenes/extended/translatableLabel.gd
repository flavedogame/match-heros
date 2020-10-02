extends Label

class_name TranslatableLabel


func _set(property, value):
	if property == "text":
		AutoCheckTranslation.addTranslation(value)
