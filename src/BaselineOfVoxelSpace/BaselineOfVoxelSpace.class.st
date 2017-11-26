"
Baseline of VoxelSpace

Metacello new
  baseline: 'VoxelSpace';
  repository: 'github://pavel-krivanek/VoxelSpace/src';
  load.
"
Class {
	#name : #BaselineOfVoxelSpace,
	#superclass : #BaselineOf,
	#category : #BaselineOfVoxelSpace
}

{ #category : #baselines }
BaselineOfVoxelSpace >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec 
			package: 'VoxelSpace'.
	].		
]
