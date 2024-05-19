@icon("res://addons/modplug_tracker_import/AudioTrackerModule.png")
extends Resource
class_name AudioTrackerModule

@export var interpolation := 2
@export var volume_offset := 0.0
@export var loop := true

@export var data := PackedByteArray()
