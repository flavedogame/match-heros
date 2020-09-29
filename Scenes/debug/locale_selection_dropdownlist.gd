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
func _ready():
	for locale_info in locale_info_array:
		add_item(locale_info[text_str])
	connect("item_selected",self,"item_selected")

func item_selected(id):
	var locale_info = locale_info_array[id]
	print(locale_info[locale_str])
	TranslationServer.set_locale(locale_info[locale_str])
	Events.emit_signal("locale_update")
