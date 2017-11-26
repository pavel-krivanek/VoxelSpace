Extension { #name : #BitBlt }

{ #category : #'*VoxelSpace' }
BitBlt >> drawVerticalLine: x from: heightOnScreen to: screenHeight color: aColor [

	sourceForm := nil.
	combinationRule := Form over.
	halftoneForm := aColor.
	destX := x.
	destY := heightOnScreen.
	sourceX := 0.
	sourceY := 0.
	width := 1.
	height := screenHeight - heightOnScreen + 1.
	self copyBits.
	
]
