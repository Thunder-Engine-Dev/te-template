extends MenuSelection

@export var character_list: Array = [
	"Mario",
	"Luigi",
]
var selection_index: int

var toggle_sound = preload("res://engine/scenes/main_menu/sounds/change.wav")

@onready var value: Label = $HBoxContainer/Value
@onready var arrow_l: Label = $HBoxContainer/Value/arrow
@onready var arrow_r: Label = $HBoxContainer/HBoxContainer/arrow

func _ready():
	_update_string.call_deferred()


func _handle_select(mouse_input: bool = false) -> void:
	#super(mouse_input)
	if !focused || !get_parent().focused: return
	var old_value = SettingsManager.settings.character
	
	selection_index = wrapi(selection_index + 1, 0, character_list.size())
	SettingsManager.settings.character = character_list[selection_index]
	_toggled_option(old_value, SettingsManager.settings.character)


func _physics_process(delta: float) -> void:
	super(delta)
	
	arrow_r.visible = focused
	arrow_l.visible = focused
	
	if !get_parent().focused: return
	
	if !focused: return
	
	var old_value = SettingsManager.settings.character
	
	if Input.is_action_just_pressed("ui_right"):
		selection_index = wrapi(selection_index + 1, 0, character_list.size())
		SettingsManager.settings.character = character_list[selection_index]
		_toggled_option(old_value, SettingsManager.settings.character)
	elif Input.is_action_just_pressed("ui_left"):
		selection_index = wrapi(selection_index - 1, 0, character_list.size())
		SettingsManager.settings.character = character_list[selection_index]
		_toggled_option(old_value, SettingsManager.settings.character)


func _toggled_option(old_val, new_val) -> void:
	if old_val == new_val: return
	Audio.play_1d_sound(toggle_sound, true, { "ignore_pause": true, "bus": "1D Sound" })
	SettingsManager._process_settings()
	_update_string()


func _update_string() -> void:
	value.text = SettingsManager.settings.character
	var findings := clampi(int(character_list.find(SettingsManager.settings.character)), 0, 99)
	selection_index = findings
	if selection_index >= character_list.size():
		selection_index = 0
