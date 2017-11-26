Class {
	#name : #VoxelSpace,
	#superclass : #Object,
	#instVars : [
		'colorMap',
		'heightMap',
		'screen',
		'canvas'
	],
	#category : #VoxelSpace
}

{ #category : #accessing }
VoxelSpace >> colorMap [
	^ colorMap
]

{ #category : #accessing }
VoxelSpace >> colorMap: anObject [
	colorMap := anObject
]

{ #category : #rendering }
VoxelSpace >> colorOf: aPoint [

	| x y |
	x := aPoint x asInteger abs \\ 1024.
	y := aPoint y asInteger abs \\ 1024.
	^ colorMap at: (y * 1024 + x +1)

]

{ #category : #rendering }
VoxelSpace >> drawVerticalLine: i from: heightOnScreen to: screenHeight color: aColor [

	canvas line: (i@heightOnScreen) to: (i@screenHeight) color: aColor
]

{ #category : #rendering }
VoxelSpace >> heightOf: aPoint [

	| x y |
	x := aPoint x asInteger abs \\ 1024.
	y := aPoint y asInteger abs \\ 1024.
	^ heightMap at: (y * 1024 + x +1)

"	| p r |
	
	p := (aPoint x asInteger abs \\ 1024) @ (aPoint y asInteger abs \\ 1024).
	r := (heigthMap colorAt: p) red.
	^ r*255.0"
]

{ #category : #rendering }
VoxelSpace >> initialize [

	| colorPng heigthPng |
	
	super initialize.
	
	colorMap := Array ofSize: 1024*1024.
	heightMap := ByteArray ofSize: 1024*1024.

	colorPng := PNGReadWriter formFromFileNamed: 'C1W.png'.
	heigthPng := PNGReadWriter formFromFileNamed: 'D1.png'.
	
	0 to: 1023 do: [:x |
		0 to: 1023 do: [:y |
			| index |
			index := (y*1024)+x+1.
			colorMap at: index put: ((colorPng colorAt: x@y)).
			heightMap at: index put: ((heigthPng colorAt: x@y) red*255.0) asInteger.
			
			
			]].
	
	screen := Form extent: 800 @ 600 depth: 32.
	canvas := FormCanvas on: screen.

]

{ #category : #rendering }
VoxelSpace >> open [

	screen asMorph openInWindow
]

{ #category : #rendering }
VoxelSpace >> rebuildFormForWidth: width height: height [

	(screen width ~= width or: [ screen height ~= height ])
		ifTrue: [ 
			screen := Form extent: width @ height depth: 32.
			canvas := FormCanvas on: screen ].
]

{ #category : #rendering }
VoxelSpace >> render: p angle: phi height: height horizon: horizon scale: scaleHeight distance: distance screenWidth: screenWidth screenHeight: screenHeight [

	| pleft pright dx heightOnScreen sinphi cosphi dy ybuffer dz z |

	self rebuildFormForWidth: screenWidth height: screenHeight.

	screen fillWithColor: Color lightGray.

	sinphi := phi sin.
   cosphi := phi cos.

	ybuffer := Array new: screenWidth.
	1 to: screenWidth do: [ :x | ybuffer at: x put: screenHeight ].
	dz := 1.
	z := 1.

	[z <= distance] whileTrue: [ 
		pleft := (((cosphi negated * z) - (sinphi * z)) + p x) 
			@ (((sinphi * z) - (cosphi * z)) + p y).
		pright := (((cosphi * z) - (sinphi * z)) + p x) 
			@ (((sinphi negated * z) - (cosphi * z)) + p y).
			
		dx := (pright x - pleft x) asFloat / screenWidth.
		dy := (pright y - pleft y) asFloat / screenWidth.
		
		1 to: screenWidth do: [ :i |
			heightOnScreen := (height - (self heightOf: pleft x@pleft y)) / z * scaleHeight + horizon.
			heightOnScreen := heightOnScreen max: 0.
			heightOnScreen := heightOnScreen min: screenHeight.
			(heightOnScreen < ((ybuffer at: i))) 
				ifTrue: [
					self drawVerticalLine: i from: heightOnScreen to: ((ybuffer at: i)) color: (self colorOf: pleft x@pleft y).
					ybuffer at: i put: heightOnScreen ].
			pleft setX: pleft x + dx setY: pleft y.
			pleft setX: pleft x setY: pleft y + dy. ].
		
		z := z + dz.
		dz := dz + 0.01].
]

{ #category : #rendering }
VoxelSpace >> render: p height: height horizon: horizon scale: scaleHeight distance: distance screenWidth: screenWidth screenHeight: screenHeight [

	| pleft pright dx heightOnScreen |

	distance to: 1 by: -1 do: [ :z |
		pleft := (z negated + p x) @ (z negated + p y).
		pright := (z + p x) @ (z negated + p y).
		dx := (pright x - pleft x) asFloat / screenWidth.
		
		0 to: screenWidth do: [ :i |
			heightOnScreen := (height - (self heightOf: pleft x@pleft y)) / z * scaleHeight + horizon.
			self drawVerticalLine: i from: heightOnScreen to: screenHeight color: (self colorOf: pleft x@pleft y).
			pleft setX: pleft x + dx setY: pleft y ]]
]

{ #category : #rendering }
VoxelSpace >> renderSlow: p angle: phi height: height horizon: horizon scale: scaleHeight distance: distance screenWidth: screenWidth screenHeight: screenHeight [

	| pleft pright dx heightOnScreen sinphi cosphi dy |

	sinphi := phi sin.
   cosphi := phi cos.

	distance to: 1 by: -1 do: [ :z |
		pleft := (((cosphi negated * z) - (sinphi * z)) + p x) 
			@ (((sinphi * z) - (cosphi * z)) + p y).
		pright := (((cosphi * z) - (sinphi * z)) + p x) 
			@ (((sinphi negated * z) - (cosphi * z)) + p y).
			
		dx := (pright x - pleft x) asFloat / screenWidth.
		dy := (pright y - pleft y) asFloat / screenWidth.
		
		0 to: screenWidth do: [ :i |
			heightOnScreen := (height - (self heightOf: pleft x@pleft y)) / z * scaleHeight + horizon.
			heightOnScreen := heightOnScreen asInteger.
			heightOnScreen := heightOnScreen max: 0.
			heightOnScreen := heightOnScreen min: screenHeight.
			self drawVerticalLine: i from: heightOnScreen to: screenHeight color: (self colorOf: pleft x@pleft y).
			pleft setX: pleft x + dx setY: pleft y.
			pleft setX: pleft x setY: pleft y + dy.
			 ]]
]

{ #category : #rendering }
VoxelSpace >> screen [

	^ screen
]

{ #category : #accessing }
VoxelSpace >> screen: anObject [
	screen := anObject
]
