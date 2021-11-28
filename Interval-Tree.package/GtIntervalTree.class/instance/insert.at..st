accessing
insert: aValue at: anInterval

	anInterval lower < interval lower
		ifTrue: [ 
			left
				ifNil: [ left := GtIntervalTree node: aValue at: anInterval ]
				ifNotNil: [ left insert: aValue at: anInterval ] ]
		ifFalse: [ 
			right
				ifNil: [ right := GtIntervalTree node: aValue at: anInterval ]
				ifNotNil: [ right insert: aValue at: anInterval ] ].

	max < anInterval upper ifTrue: [ max := anInterval upper ]