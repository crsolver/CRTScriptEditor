@tool
extends EditorPlugin

var editor: ScriptEditor
var overlay_scene


func _enter_tree():
	editor = get_editor_interface().get_script_editor()
	overlay_scene = load("res://addons/crt_script_editor/crt_overlay.tscn")
	editor.editor_script_changed.connect(_on_editor_script_changed)
	add_overlay()


func _on_editor_script_changed(script: Script):
	add_overlay()


func add_overlay():
	var current = editor.get_current_editor()
	if not current: return
	var base = current.get_base_editor()
	if not base.get_children().is_empty(): return
	var overlay = overlay_scene.instantiate()
	base.add_child(overlay)


func _exit_tree():
	editor.get_open_script_editors()
	for script_editor in editor.get_open_script_editors():
		var overlay = script_editor.get_base_editor().get_child(0)
		if overlay: overlay.queue_free()
