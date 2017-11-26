Class {
	#name : #VoxelSpaceMorph,
	#superclass : #Morph,
	#instVars : [
		'voxelSpace',
		'position',
		'angle',
		'rendering'
	],
	#category : #VoxelSpace
}

{ #category : #initialization }
VoxelSpaceMorph >> drawOn: aCanvas [

	aCanvas drawImage: voxelSpace screen at: self innerBounds origin.
]

{ #category : #initialization }
VoxelSpaceMorph >> handlesKeyboard: evt [
	^ true
]

{ #category : #initialization }
VoxelSpaceMorph >> handlesMouseOver: anEvent [
	"Enables capturing mouse over events"
	^true.
]

{ #category : #initialization }
VoxelSpaceMorph >> initialize [

	super initialize.
	
	voxelSpace := VoxelSpace new.
	position := 600@150.
	angle := 90.
	self width: 800.
	self height: 600.
	rendering := false.

	self render.

	
	
]

{ #category : #initialization }
VoxelSpaceMorph >> keyDown: anEvent [
	"Keyboard interaction dispatching"

	| keyValue |
	keyValue := anEvent keyValue.
		
	keyValue = 30 "Up"
		ifTrue: [ position := position + (-10@0) ]. 
	keyValue = 31 "Down"
		ifTrue: [ position := position + (10@0) ]. 
	keyValue = 29 "Right"
		ifTrue: [ angle := angle - 10 ]. 
	keyValue = 28 "Left"
		ifTrue: [ angle := angle + 10 ]. 
	
	rendering ifFalse: [ 	
		self render.
		
	self changed. ].
]

{ #category : #initialization }
VoxelSpaceMorph >> layoutChanged [ 
	"react on morph resize"
	super layoutChanged.

	self render.
	self changed.
	
]

{ #category : #initialization }
VoxelSpaceMorph >> mouseEnter: anEvent [
	"Give keyboard focus when the mouse enters the morph"
	anEvent hand newKeyboardFocus: self.
]

{ #category : #initialization }
VoxelSpaceMorph >> render [

	rendering := true.

	voxelSpace render: position angle: angle degreesToRadians height: 90 horizon: 120 scale: (self width/self height)*225.0 distance: 800 screenWidth: self width asInteger screenHeight: self height asInteger.

	rendering := false.
]
