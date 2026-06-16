extends Control

const SHADER_OPTIMIZER = preload("res://engine/components/shader_optimizer/shader_optimizer.tscn")

@onready var disclaimer: TextureRect = $CenterContainer/Disclaimer
@onready var icon: TextureRect = $CenterContainer/Icon
@onready var text: Label = $Text

var loading_finished: bool = false
var cacher

func _ready() -> void:
	SettingsManager.enable_shortcut_scene_change_keys = false
	print("[Startup] Game Version %s" % [ProjectSettings.get_setting("application/config/version")])
	print("[Startup] Preparing to compile shaders...")
	if "--no-shader-precompile" in OS.get_cmdline_user_args():
		print("[Startup] Found a flag in cmdline arguments, skipping compilation.")
		display_disclaimer()
		return
		
	await get_tree().create_timer(0.6, false, true, false).timeout
	print("[Startup] Optimizing shaders...")
	cacher = SHADER_OPTIMIZER.instantiate()
	cacher.complete.connect(display_disclaimer)
	Scenes.current_scene.add_child(cacher)
	Thunder.reorder_top(cacher)



func display_disclaimer() -> void:
	print("[Startup] Shader compilation complete!")
	text.queue_free()
	icon.queue_free()
	if is_instance_valid(cacher):
		cacher.hide()
		cacher.queue_free()
	
	var tw = disclaimer.create_tween()
	tw.tween_property(disclaimer, "modulate:a", 1.0, 0.6)
	tw.tween_interval(2.2)
	tw.tween_property(disclaimer, "modulate:a", 0.0, 0.6)
	tw.tween_callback(transition)
	await get_tree().physics_frame
	SettingsManager.enable_shortcut_scene_change_keys = true


func transition() -> void:
	var _crossfade: bool = SettingsManager.get_tweak("replace_circle_transitions_with_fades", false)
	var mainmenu = ProjectSettings.get_setting("application/thunder_settings/main_menu_path")
	if !_crossfade:
		TransitionManager.accept_transition(
			load("res://engine/components/transitions/circle_transition/circle_transition.tscn")
				.instantiate()
				.with_speeds(0.04, -0.1)
				.with_pause()
		)

		await TransitionManager.transition_middle
		Scenes.goto_scene(mainmenu)
	else:
		Scenes.goto_scene(mainmenu)
