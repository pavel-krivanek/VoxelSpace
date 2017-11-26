"
VoxelSpaceMorph new openInWindow.
"
Class {
	#name : #VoxelSpaceMorph,
	#superclass : #Morph,
	#instVars : [
		'voxelSpace',
		'position',
		'angle',
		'rendering',
		'mouseControl',
		'lastMousePosition',
		'cameraHeight'
	],
	#category : #VoxelSpace
}

{ #category : #initialization }
VoxelSpaceMorph >> defaultHeight [

	^ 50
]

{ #category : #initialization }
VoxelSpaceMorph >> drawOn: aCanvas [

	aCanvas drawImage: voxelSpace screen at: self innerBounds origin.
]

{ #category : #initialization }
VoxelSpaceMorph >> handlesMouseDown: anEvent [
		
	^ true
]

{ #category : #initialization }
VoxelSpaceMorph >> initialize [

	super initialize.
	
	voxelSpace := VoxelSpace new.
	position := 560@120.
	angle := 120.
	rendering := false.
	cameraHeight := (voxelSpace heightOf: position) + self defaultHeight.
	
	mouseControl := false.

	self extent: 800@600.
	
	
]

{ #category : #initialization }
VoxelSpaceMorph >> layoutChanged [ 
	"react on morph resize"
	super layoutChanged.

	self render.
	self changed.
	
]

{ #category : #initialization }
VoxelSpaceMorph >> mouseDown: anEvent [

	mouseControl := true. 
	lastMousePosition := anEvent cursorPoint
]

{ #category : #initialization }
VoxelSpaceMorph >> mouseMove: anEvent [
	
	| dif |
	mouseControl 
		ifFalse: [ ^ super mouseMove: anEvent ].
	
	dif := anEvent cursorPoint - lastMousePosition.
	
 	angle := angle - dif x . 	
 	position := position x + (dif y * angle degreesToRadians sin)
		@ (position y + (dif y * angle degreesToRadians cos)). 	
	cameraHeight := (voxelSpace heightOf: position) + self defaultHeight.	
	lastMousePosition := anEvent cursorPoint.
	

	self render.
	self changed.

]

{ #category : #initialization }
VoxelSpaceMorph >> mouseUp: anEvent [

	mouseControl := false. 

]

{ #category : #initialization }
VoxelSpaceMorph >> render [

	rendering := true.

	voxelSpace 
		render: position 
		angle: angle degreesToRadians 
		height: cameraHeight 
		horizon: 120 
		scale: (self width/self height)*225.0 
		distance: 500 
		screenWidth: self width asInteger 
		screenHeight: self height asInteger.

	rendering := false.
]
