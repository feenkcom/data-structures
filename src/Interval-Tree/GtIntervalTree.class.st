Class {
	#name : #GtIntervalTree,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'value',
		'max',
		'interval'
	],
	#category : #'Interval-Tree-Core'
}

{ #category : #accessing }
GtIntervalTree class >> node: aValue at: anInterval [
	^ self new value: aValue; interval: anInterval; max: anInterval upper 
]

{ #category : #accessing }
GtIntervalTree >> gtChildren [
	| children |
	children := OrderedCollection new.
	left ifNotNil: [children add: left].
	right ifNotNil: [children add: right].
	^ children
]

{ #category : #accessing }
GtIntervalTree >> gtTreeFor: aView [
	<gtView>
	
	^ aView columnedTree
		  title: 'Tree';
		  priority: 1;
		  items: [ { self } ];
		  children: [ :eachItem | eachItem gtChildren ];
		  column: 'Value' text: [ :eachItem | eachItem value ];
		  column: 'Interval' text: [ :eachItem | eachItem interval intervalString ]
]

{ #category : #accessing }
GtIntervalTree >> insert: aValue at: anInterval [

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
]

{ #category : #accessing }
GtIntervalTree >> interval [
	^ interval
]

{ #category : #accessing }
GtIntervalTree >> interval: anInterval [
	interval := anInterval
]

{ #category : #accessing }
GtIntervalTree >> isLeaf [
	^ left isNil and: right isNil
]

{ #category : #accessing }
GtIntervalTree >> left [
	^ left
]

{ #category : #accessing }
GtIntervalTree >> max [

	^ max
]

{ #category : #accessing }
GtIntervalTree >> max: aValue [
	max := aValue
]

{ #category : #accessing }
GtIntervalTree >> search: aValue [

	| res |
	res := OrderedCollection new.
	(interval contains: aValue) ifTrue: [ res add: value ].

	left ifNotNil: [ res addAll: (left search: aValue) ].

	right ifNotNil: [ res addAll: (right search: aValue) ].
	
	^ res
]

{ #category : #accessing }
GtIntervalTree >> searchInterval: anInterval [

	| res |
	res := OrderedCollection new.
	(interval overlaps: anInterval) ifTrue: [ res add: value ].
	
	(left isNotNil and: [ left max >= anInterval lower ]) ifTrue: [ 
		res addAll: (left searchInterval: anInterval) ].

	right ifNotNil: [ res addAll: (right searchInterval: anInterval) ].
	^ res
]

{ #category : #accessing }
GtIntervalTree >> value [
	^ value
]

{ #category : #accessing }
GtIntervalTree >> value: aValue [
	value := aValue
]