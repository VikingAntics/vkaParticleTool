# vkaParticleTool
 Particle control panel resides in bottom of Godot Inspector to help test multi-layer particles

 The PNG files in the example are used from the Keney Particle Pack with much appreciation.

 Sometimes, when you are editing multiple GPUParticles in your project, it gets cumbersome to constantly highlight
 all of the particles, scroll up to the Emitting checkbox, and then go back and forth making changes and repeating the process
 to test your particles.

 This tool tries to alleviate some of the inconvenience by placing a small panel in the bottom of the inspector panel that 
 always makes the Emit/Emit All button visible so you can focus on your particle properties rather than scrolling back and 
 forth to test.

Installation:

 The vkaParticleTool folder needs to be in the res://addons folder in your Godot project.  Then goto menu Project->Project Settings->Plugins and make sure vkaParticleTool is checked/enabled.

 These are the features:
	
 The vkaParticleTool Panel only becomes visible if you select a valid Particle Node in the Scene Inspector.

 Emit Button - Emits the currently selected particle (i.e. sets emitting = true)
 
 Emit All Button - Tries to find the parent node of all the particles, the first non-particle node and isses a particle restart method call to all of the particles that are lower in the tree.
 
 Stop Button - Stops the currently selected particle (i.e. set emitting = false)
 
 Stop All Button - Tries to find the parent node of all the particles, the first non-particle node and traverses the children setting any particles emitting = false
 
 One Shot Button - Will change the one_shot property of all selected particles to true or false, depening on whether the button is toggled on or off.
 
 Auto Emit Checkbox - Sometimes you need a particle to keep restarting over and over again automatically while you play with the different properties in the ParticleProcessMaterial.  If the box is checked, the particle that was selected when the button was checked will keep playing every interval seconds until you uncheck it.  This gives you the ability to see your changes as you make them without constantly replaying the particle.
 

 LIMITATIONS:

 I have not tested this with 3D Particles, but the code is fairly generic.
 The Emit All WILL NOT work with Sub Emitters at the moment unless the Sub Emitter particles are in a different tree branch in the Scene Editor.  It always tries to restart all the child particles in the parent node branch.

 Let me know if you like it or hate it or have any suggestions, but it has made creating particles easier for me, if only I were better at art. :(

 There is an example folder, ParticleToolExample, that you can test the tool with in the project.  The particle is ugly, but that is my lacking artistic skills. Again, thank you Kenney for use of the 3 PNG textues from the Kenney Particle Pack.

 
