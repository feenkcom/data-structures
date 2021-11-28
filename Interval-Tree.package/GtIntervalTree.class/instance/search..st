accessing
search: aValue

	| res |
	res := OrderedCollection new.
	(interval contains: aValue) ifTrue: [ res add: value ].

	left ifNotNil: [ res addAll: (left search: aValue) ].

	right ifNotNil: [ res addAll: (right search: aValue) ].
	
	^ res