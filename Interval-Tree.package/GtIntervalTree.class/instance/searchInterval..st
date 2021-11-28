accessing
searchInterval: anInterval

	(value overlaps: anInterval) ifTrue: [ ^ value ].

	(left isNotNil and: [ left max >= anInterval low ]) ifTrue: [ 
		^ left search: anInterval ].

	right ifNotNil: [ ^ left search: anInterval ]