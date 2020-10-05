extends Node

var translatedStrings = {}

var localizationFilePath = "res://resources/localization.csv"

func _ready():
	if OS.has_feature("standalone"):
		#print("Running an exported build.")
		pass
	else:
		#print("Running from the editor.")
		var file = File.new()
		var error = file.open(localizationFilePath, File.READ)
		if error != OK:
			printerr("Couldn't open file for read: %s, error code: %s." % [localizationFilePath, error])
			return
		while !file.eof_reached():
			var csv = file.get_csv_line ()
			for i in csv:
				translatedStrings[i] = true
				#translated string in other language need to be added,
				#otherwise they will be catched as string that need to be translated
		file.close()
	
func addTranslation(text):
	if OS.has_feature("standalone"):
		pass
		#print("Running an exported build.")
	else:
		var formatText = "\""+text+"\""
		if not translatedStrings.has(text) and not translatedStrings.has(formatText):
			var file = File.new()
			file.open(localizationFilePath, file.READ_WRITE)
			file.seek_end()
			var content = formatText+","+formatText+","+formatText+"\r"
			file.store_line(content)
			file.close()
			translatedStrings[text] = true
	
