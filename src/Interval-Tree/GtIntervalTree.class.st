"
# Interval Tree

is a simple implementation of an interval tree, providing a way to query values by intervals or values within the interval.

#Example

{{gtExample:IntervalTreeExamples>>search}}
"
Class {
	#name : #GtIntervalTree,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'value',
		'max',
		'interval',
		'leftDepth',
		'rightDepth'
	],
	#category : #'Interval-Tree-Core'
}

{ #category : #accessing }
GtIntervalTree class >> node: aValue at: anInterval [
	^ self new value: aValue; interval: anInterval; max: anInterval upper; leftDepth: 0; rightDepth: 0
]

{ #category : #accessing }
GtIntervalTree >> balance [
	self flag: 'TODO'
]

{ #category : #accessing }
GtIntervalTree >> depthFirstCollect: aBlock [

	| res |
	res := OrderedCollection new.

	left ifNotNil: [ res addAll: (left depthFirstCollect: aBlock) ].

	res add: (aBlock value: self).

	right ifNotNil: [ res addAll: (right depthFirstCollect: aBlock) ].

	^ res
]

{ #category : #accessing }
GtIntervalTree >> depthFirstCollect: aBlock branchedOnLeft: aBranchingBlock [

	| leftCond res |
	res := OrderedCollection new.
	leftCond := left isNotNil and: [ aBranchingBlock value: left ].
	leftCond ifTrue: [ 
		res addAll: (left depthFirstCollect: aBlock) ].

	res add: (aBlock value: self).

	(right isNotNil and: leftCond not) ifTrue: [ 
		res addAll: (right depthFirstCollect: aBlock) ]
]

{ #category : #accessing }
GtIntervalTree >> depthFirstCollect: aBlock filteredWithLeft: aLeftFilterBlock andRight: aRightFilterBlock [

	| res |
	res := OrderedCollection new.

	(left isNotNil and: [ aLeftFilterBlock value: left ]) ifTrue: [ 
		res addAll: (left depthFirstCollect: aBlock) ].

	res add: (aBlock value: self).

	(right isNotNil and: [ aRightFilterBlock value: right ]) ifTrue: [ 
		res addAll: (right depthFirstCollect: aBlock) ].

	^ res
]

{ #category : #accessing }
GtIntervalTree >> depthFirstDo: aBlock [

	left ifNotNil: [ left depthFirstDo: aBlock ].

	aBlock value: self.

	right ifNotNil: [ right depthFirstDo: aBlock ]
]

{ #category : #accessing }
GtIntervalTree >> depthFirstDo: aBlock branchedOnLeft: aBranchingBlock [

	| leftCond |
	leftCond := left isNotNil and: [ aBranchingBlock value: left ].
	leftCond ifTrue: [ 
		left depthFirstCollect: aBlock ].

	aBlock value: self.

	(right isNotNil and: leftCond not) ifTrue: [ 
		right depthFirstCollect: aBlock ]
]

{ #category : #accessing }
GtIntervalTree >> depthFirstDo: aBlock filteredWithLeft: aLeftFilterBlock andRight: aRightFilterBlock [

	(left isNotNil and: [ aLeftFilterBlock value: left ]) ifTrue: [ 
		left depthFirstCollect: aBlock ].

	aBlock value: self.

	(right isNotNil and: [ aRightFilterBlock value: right ]) ifTrue: [ 
		right depthFirstCollect: aBlock ]
]

{ #category : #accessing }
GtIntervalTree >> diff: aTree [
	| nodesA nodesB |
	nodesA := self depthFirstCollect: [:each | each interval -> each value].
	nodesB := aTree depthFirstCollect: [:each | each interval -> each value].
	
	^ nodesA copyWithoutAll: nodesB
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

	self privateInsert: aValue at: anInterval.

	(leftDepth - rightDepth > 2 or: leftDepth - rightDepth < -2) ifTrue: [ 
		self balance ]
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
GtIntervalTree >> leftDepth: anInteger [
	leftDepth := anInteger
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
GtIntervalTree >> privateInsert: aValue at: anInterval [

	anInterval lower < interval lower
		ifTrue: [ 
			left
				ifNil: [ 
					left := GtIntervalTree node: aValue at: anInterval.
					leftDepth := 1 ]
				ifNotNil: [ leftDepth := (left privateInsert: aValue at: anInterval) + 1 ] ]
		ifFalse: [ 
			right
				ifNil: [ 
					right := GtIntervalTree node: aValue at: anInterval.
					rightDepth := 1 ]
				ifNotNil: [ rightDepth := (right privateInsert: aValue at: anInterval) + 1 ] ].

	max < anInterval upper ifTrue: [ max := anInterval upper ].
	
	^ leftDepth max: rightDepth
]

{ #category : #accessing }
GtIntervalTree >> rightDepth: anInteger [
	rightDepth := anInteger
]

{ #category : #accessing }
GtIntervalTree >> search: aValue [

	| res |
	res := OrderedCollection new.

	self
		depthFirstDo: [ :aNode | 
			(aNode interval contains: aValue) ifTrue: [ res add: aNode value ] ]
		branchedOnLeft: [ :aNode | aNode max >= aValue ].

	^ res
]

{ #category : #accessing }
GtIntervalTree >> searchInterval: anInterval [

	| res |
	res := OrderedCollection new.

	self depthFirstDo: [ :aNode | 
		(aNode interval overlaps: anInterval) ifTrue: [ 
			res add: aNode value ] ] branchedOnLeft: [ :aNode | aNode max >= anInterval lower ].

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
