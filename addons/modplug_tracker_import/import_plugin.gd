@tool
extends EditorImportPlugin

enum Presets { DEFAULT }

func _get_importer_name():
	return "libopenmpt.modimporter"

func _get_visible_name():
	return "Tracker Music"

func _get_recognized_extensions():
	return [
		"mptm", "mod", "s3m", "xm", "it", "669", "amf", "ams", "c67", "mmcmp",
		"dbm", "digi", "dmf", "dsm", "dsym", "dtm", "far", "fmt", "imf", "ice",
		"j2b", "m15", "mdl", "med", "mms", "mt2", "mtm", "mus", "nst", "okt",
		"plm", "psm", "pt36", "ptm", "sfx", "sfx2", "st26", "stk", "stm", "stx",
		"stp", "symmod", "ult", "wow", "gdm", "mo3", "oxm", "umx", "xpk", "ppm"
	]

func _get_priority() -> float:
	return 2.0

func _get_import_order() -> int:
	return 0

func _get_save_extension():
	return "res"

func _get_resource_type():
	return "Resource"

func _get_preset_count():
	return Presets.size()
	
func _get_preset_name(preset_index):
	match preset_index:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"
			
func _get_import_options(path, preset_index):
	match preset_index:
		Presets.DEFAULT:
			return [{
					"name": "interpolation",
					"default_value": 2,
					"property_hint": PROPERTY_HINT_ENUM,
					"hint_string": "Default,Nothing,Linear,Cubic:4,Sinc:8"
				}, {
					"name": "loop",
					"default_value": true,
				}, {
					"name": "volume_offset",
					"default_value": 0.0,
				}
			]
		_:
			return []

func _get_option_visibility(path, option_name, options):
	return true

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	
	var buffer = file.get_buffer(file.get_length())
	
	var resource = preload("res://addons/modplug_tracker_import/tracker_resource.gd").new()
	resource.data = buffer
	resource.interpolation = options.interpolation
	resource.loop = options.loop
	resource.volume_offset = options.volume_offset
	
	return ResourceSaver.save(resource, "%s.%s" % [save_path, _get_save_extension()])
