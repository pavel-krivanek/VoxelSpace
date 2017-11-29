"
for more information see https://github.com/s-macke/VoxelSpace
"
Class {
	#name : #VoxelSpace,
	#superclass : #Object,
	#instVars : [
		'colorMap',
		'heightMap',
		'screen',
		'canvas',
		'bits'
	],
	#category : #VoxelSpace
}

{ #category : #accessing }
VoxelSpace >> heightOf: aPoint [

	^ heightMap at: (aPoint y asInteger abs \\ self mapSize) * self mapSize + (aPoint x asInteger abs \\ self mapSize) + 1
]

{ #category : #initialization }
VoxelSpace >> initialize [

	| colorPng heigthPng |
	
	super initialize.
	
	colorMap := Array ofSize: self mapSize*self mapSize.
	heightMap := ByteArray ofSize: self mapSize*self mapSize.

	colorPng := PNGReadWriter formFromFileNamed: 'C1W.png'.
	heigthPng := PNGReadWriter formFromFileNamed: 'D1.png'.
	
	screen := Form extent: 800 @ 600 depth: 32.

	0 to: self mapSize-1 do: [:x |
		0 to: self mapSize-1 do: [:y |
			| index |
			index := (y*self mapSize)+x+1.
			colorMap at: index put: (screen bitPatternFor: (colorPng colorAt: x@y)).
			heightMap at: index put: ((heigthPng colorAt: x@y) red*255.0) asInteger. ]].
	

]

{ #category : #'as yet unclassified' }
VoxelSpace >> mapSize [

	^ 1024
]

{ #category : #utility }
VoxelSpace >> open [

	screen asMorph openInWindow
]

{ #category : #rendering }
VoxelSpace >> rebuildFormForWidth: width height: height [

	(screen width ~= width or: [ screen height ~= height ])
		ifTrue: [ 
			screen := Form extent: width @ height depth: 32 ].
]

{ #category : #rendering }
VoxelSpace >> render: position angle: angleInRadians height: height horizon: horizon scale: scaleHeight distance: distance screenWidth: screenWidth screenHeight: screenHeight [

	| dx heightOnScreen sinphi cosphi dy yBuffer dz z leftPointX leftPointY rightPointX rightPointY sinZ cosZ px py arrayIndex lastPointX lastPointY lastHeight lastColor invZ |

	px := position x.
	py := position y.
	 	
	self rebuildFormForWidth: screenWidth height: screenHeight.

	screen fillWithColor: (Color r: 0.486 g: 0.612 b: 0.721 alpha: 1.0).
	
	bits := BitBlt bitPokerToForm: screen.

	sinphi := angleInRadians sin.
   cosphi := angleInRadians cos.

	yBuffer := IntegerArray new: screenWidth withAll: screenHeight.
	dz := 1.0.
	z := 1.0.
	
	lastHeight := lastColor := nil.
	
	[z <= distance] whileTrue: [ 
		sinZ := sinphi * z.
		cosZ := cosphi * z.
		invZ := scaleHeight / z.
		leftPointX := cosZ negated - sinZ. 
		leftPointY := sinZ - cosZ.
		rightPointX := cosZ - sinZ.
		rightPointY := sinZ negated - cosZ.
			
		dx := (rightPointX - leftPointX) / screenWidth.
		dy := (rightPointY - leftPointY) / screenWidth.
		
		leftPointX := leftPointX + px.
		leftPointY := leftPointY + py.
		
		1 to: screenWidth do: [ :x |
			| currentY |
			currentY := yBuffer at: x.

			lastPointX := lastPointY := nil.
			
			(leftPointX asInteger = lastPointX and: [ leftPointY asInteger = lastPointY ])
				ifFalse: [ 
					arrayIndex := (leftPointY asInteger abs \\ self mapSize) * self mapSize + (leftPointX asInteger abs \\ self mapSize) + 1.
					heightOnScreen := ((height - (lastHeight := heightMap at: arrayIndex)) * invZ + horizon) asInteger.					
					(heightOnScreen < currentY) 
						ifTrue: [
							heightOnScreen := heightOnScreen min: screenHeight.
							bits drawVerticalLine: (x-1) from: heightOnScreen to: currentY color: (lastColor := colorMap at: arrayIndex).
							yBuffer at: x put: heightOnScreen ].
					lastPointX := leftPointX asInteger.
					lastPointY := leftPointY asInteger. ]
			ifTrue: [
					heightOnScreen := ((height - (lastHeight)) * invZ + horizon) asInteger.					
					(heightOnScreen < currentY) 
						ifTrue: [
							heightOnScreen := heightOnScreen min: screenHeight.
							bits drawVerticalLine: (x-1) from: heightOnScreen to: currentY color: lastColor.
							yBuffer at: x put: heightOnScreen ] ].
			
			leftPointX := leftPointX + dx.
			leftPointY := leftPointY + dy. ].
		
		z := z + dz.
		dz := dz + 0.01].
]

{ #category : #accessing }
VoxelSpace >> screen [

	^ screen
]

{ #category : #accessing }
VoxelSpace >> screen: anObject [
	screen := anObject
]
