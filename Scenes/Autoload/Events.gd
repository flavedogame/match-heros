extends Node

signal battle_won(battle_id)
signal battle_complete(battle_id)
signal achievement_update()
signal encounter_battle(battle_id, enemy_formation)

signal start_dialog(dialog_id, content)
signal finish_dialog(dialog_id)

signal show_popup_message(message)

signal actor_talking(talker_name)

signal select_map_node_button(button)
signal cancel_select_map_node_button()

