@tool
extends EditorPlugin

var import_plugin

func _enter_tree() -> void:
	add_custom_type(
		"AudioTrackerModule",
		"Resource",
		preload("res://addons/modplug_tracker_import/tracker_resource.gd"),
		preload("res://addons/modplug_tracker_import/AudioTrackerModule.png")
	)
	import_plugin = preload("import_plugin.gd").new()
	add_import_plugin(import_plugin)

func _exit_tree() -> void:
	remove_custom_type("AudioTrackerModule")
	remove_import_plugin(import_plugin)
	import_plugin = null
