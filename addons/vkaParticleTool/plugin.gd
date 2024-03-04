@tool
extends EditorPlugin

var particleControlPanel: Control = preload("res://addons/vkaParticleTool/particle_control_panel.tscn").instantiate()


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	if particleControlPanel.has_method("set_editor_interface"):
		particleControlPanel.set_editor_interface(get_editor_interface())
	add_control_to_container(EditorPlugin.CONTAINER_INSPECTOR_BOTTOM, particleControlPanel)
	particleControlPanel.visible = false


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_container(EditorPlugin.CONTAINER_INSPECTOR_BOTTOM, particleControlPanel)
	particleControlPanel.queue_free()


func _get_plugin_name() -> String:
	return "Particle Control Panel"
	
func _has_main_screen() -> bool:
	return false
	
func _make_visible(visible: bool) -> void:
	if particleControlPanel:
		particleControlPanel.visible = visible
