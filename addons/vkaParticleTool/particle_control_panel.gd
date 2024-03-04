@tool
extends Control

var editor_interface: EditorInterface # set by plugin.gd on enter_tree
var editor_selection: EditorSelection

@onready var particle_control_panel: Control = $"."
@onready var timer: Timer = Timer.new()

var AutoEmitParticle: Node2D


func _ready() -> void:
	if Engine.is_editor_hint():
		timer.wait_time = 1 # temporary value
		timer.connect("timeout", func() -> void: if (isValidParticle(AutoEmitParticle)): startParticles(AutoEmitParticle))
		add_child(timer)
		timer.autostart = false


## set_editor_interface called from plugin.gd to pass EditorInterface once everything
## is instantiated.
func set_editor_interface(editorInterface: EditorInterface) -> void:
	editor_interface = editorInterface
	editor_selection = editor_interface.get_selection()
	editor_selection.selection_changed.connect(_on_selection_changed)


## Signal Handler for _on_selection_changed determines whether to display particle control panel.
func _on_selection_changed() -> void:
	if !Engine.is_editor_hint():
		return
		
	var isParticle: bool = false
	var selectedNodes = editor_selection.get_selected_nodes()
	
	# Make sure at least 1 selecte Node is a GPUParticles2D
	for eachNode in selectedNodes:
		if isValidParticle(eachNode):
			isParticle = true
			break;
			
	visible = true if isParticle else false
	
	if isParticle and selectedNodes.size() == 1:
		%OneShot.button_pressed = selectedNodes[0].one_shot
		%AutoEmitCheckbox.disabled = false
		%AutoEmitSlider.editable =  true
		%AutoEmitAmountLabel.text = "%d" % %AutoEmitSlider.value
	else:
		%AutoEmitCheckbox.disabled = !%AutoEmitCheckbox.button_pressed # only enabled if it is auto emitting, to turn off.
		%AutoEmitSlider.editable = %AutoEmitCheckbox.button_pressed # only enabled if it is auto emitting, to turn off.


## Signal Handler for Emit button - Emit all selected particles
func _on_emit_button_pressed() -> void:
	if !Engine.is_editor_hint():
		return
		
	var selectedNodes = editor_selection.get_selected_nodes()
	
	for snode in selectedNodes:
		startParticles(snode)


## Signal Handler for Emit All button - Emits All particles it can find in tree segmanet
func _on_emit_all_button_pressed() -> void:
	if !Engine.is_editor_hint():
		return
		
	var emitNode: Node
	
	emitNode = get_top_parent()
	if emitNode != null:
		emitNode.propagate_call("restart") # TODO: This could be a problem if alternate particle start method.


## Signal Hanlder for Stop button
func _on_stop_button_pressed() -> void:
	if !Engine.is_editor_hint():
		return

	var selectedNodes = editor_selection.get_selected_nodes()
	
	for snode in selectedNodes:
		snode.emitting = false


## Signal Handler for Stop All button
func _on_stop_all_button_pressed() -> void:
	if !Engine.is_editor_hint():
		return

	var emitNode: Node
	
	emitNode = get_top_parent()
	if emitNode != null:
		for snode: Node in emitNode.get_children():
			if isValidParticle(snode):
				snode.emitting = false


## get_top_parent starts the emitter for the currently selected particle
## and all of its children.
##
## Checks the parents of the currently selected particle to try
## to find all of the children.
func get_top_parent() -> Node:
	var selectedNodes = editor_selection.get_selected_nodes()
	var topNode: Node 
	
	# no GPUParticles2D nodes selected, return null
	if selectedNodes.size() == 0:
		return null
		
	# Get first GPUParticles2D in selectedNodes
	for snode: Node in selectedNodes:
		if isValidParticle(snode):
			topNode = snode
			break

	while (isValidParticle(topNode)):
		if topNode.get_parent() != null:
			topNode = topNode.get_parent()
		else:
			break # no get_parent, so quit loop.
	
	return topNode


## Signl Handler for Auto Emit Checkbox
func _on_auto_emit_checkbox_toggled(toggled_on: bool) -> void:
	if !Engine.is_editor_hint():
		return
		
	var selectedNodes = editor_selection.get_selected_nodes()
	
	if toggled_on:
		if isValidParticle(selectedNodes[0]) && selectedNodes.size() == 1:
			AutoEmitParticle = selectedNodes[0]
			%AutoEmitCheckbox.text = "Auto Emit: " + selectedNodes[0].name
			timer.start()
		
	if !toggled_on: # Unchecked
		%AutoEmitCheckbox.text = "Auto Emit:"
		timer.stop()
		AutoEmitParticle = null
		if selectedNodes.size() > 1:
			%AutoEmitCheckbox.disabled = true # Can't turn back on with multiple selection
			%AutoEmitSlider.editable = false # Can't turn back on with multiple selection



## Signal Handler for Auto Emit Slider
func _on_autoemit_slider_value_changed(value: float) -> void:
	if !Engine.is_editor_hint():
		return

	%AutoEmitAmountLabel.text = "%d" % %AutoEmitSlider.value
	
	# Restart time if value changes.
	if %AutoEmitCheckbox.button_pressed:
		timer.stop()
		timer.wait_time = %AutoEmitSlider.value
		timer.start()


## Signal Handler for One Shot button - toggle one_shot on/off
func _on_one_shot_toggled(toggled_on: bool) -> void:
	if !Engine.is_editor_hint():
		return

	# We know it is a valid particle, otherwise Panel would be hidden.
	var selectedNodes = editor_selection.get_selected_nodes()
	if selectedNodes.size() == 1:
		var particle: Node2D = selectedNodes[0]
		particle.one_shot = toggled_on
	else:
		for snode: Node in selectedNodes:
			if isValidParticle(snode):
				snode.one_shot = toggled_on


## Make particle run (using method in case future requires differnt start conditions)
func startParticles(particle: Node2D, _propogateCall: bool = false) -> void:
	particle.restart()


## Check if the node is a valid particle
func isValidParticle(node: Node) -> bool:
	return (node is GPUParticles2D || node is CPUParticles2D || node is GPUParticles3D || node is CPUParticles3D)

