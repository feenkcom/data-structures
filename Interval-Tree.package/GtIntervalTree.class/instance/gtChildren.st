accessing
gtChildren
	| children |
	children := OrderedCollection new.
	left ifNotNil: [children add: left].
	right ifNotNil: [children add: right].
	^ children