extends Node

var translatedStrings = {}

var localizationFilePath = "res://resources/localization.csv"
var waitingForLocalizationFilePath = "res://resources/waitingForLocalization.txt"

func _ready():
	var groupname=""
	var file = File.new()
	file.open(localizationFilePath, file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line ()
		for i in csv:
			translatedStrings[i] = true
	file.close()		
	file.open(waitingForLocalizationFilePath, file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line ()
		if csv[0]:
			translatedStrings[csv[0]] = true
	file.close()
	
func addTranslation(text):
	var formatText = "\""+text+"\""
	if not translatedStrings.has(text) and not translatedStrings.has(formatText):
		var file = File.new()
		file.open(waitingForLocalizationFilePath, file.READ_WRITE)
		file.seek_end()
		#var content = file.get_as_text()
		#print(content)
		#var content = text+","+text+","
		var content = "\""+text+"\""+","+"\""+text+"\""+","+"\""+"\""+"\r"
		file.store_line(content)
		file.close()
		translatedStrings[text] = true
