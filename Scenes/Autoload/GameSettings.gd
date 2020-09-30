extends Node

var locale:String

var locale_SAVE_KEY = "locale"

func save(saved_game: Resource):
	saved_game.data[locale_SAVE_KEY] = TranslationServer.get_locale()
	
func load(saved_game: Resource):
	if not saved_game.data.has(locale_SAVE_KEY):
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale(saved_game.data[locale_SAVE_KEY])
