extends OptionButton


var text_str = "text"
var locale_str = "locale"

var locale_info_array = [
	{
		text_str:"English",
		locale_str:"en",
	},
	{
		text_str:"中文",
		locale_str:"zh",
	},
]

func getLocaleIndex(locale):
	var id = 0
	for locale_info in locale_info_array:
		if locale_info[locale_str] == locale:
			return id
		id+=1
	return id

func _ready():
	for locale_info in locale_info_array:
		add_item(locale_info[text_str])
	
	selected = getLocaleIndex(TranslationServer.get_locale())
	connect("item_selected",self,"item_selected")
	

func item_selected(id):
	var locale_info = locale_info_array[id]
	TranslationServer.set_locale(locale_info[locale_str])
	GameSaver.save_globally()
	

