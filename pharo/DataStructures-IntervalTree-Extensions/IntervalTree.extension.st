Extension { #name : #IntervalTree }

{ #category : #'*DataStructures-IntervalTree-Extensions' }
IntervalTree >> gtTreeFor: aView [
	<gtView>
	
	self hasRoot
		ifFalse: [ ^ aView empty ].
	
	^ self root gtTreeFor: aView
]
