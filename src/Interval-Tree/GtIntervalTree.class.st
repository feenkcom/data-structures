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
GtIntervalTree class >> fromNodes: aCollectionOfAssociations [
	| root |
	self assert: aCollectionOfAssociations isNotEmpty.
	
	root := self node: aCollectionOfAssociations first key at:aCollectionOfAssociations first value.
	
	aCollectionOfAssociations allButFirst do: [:each | root := root insert: each key at: each value].
	
	^ root 
]

{ #category : #accessing }
GtIntervalTree class >> node: aValue at: anInterval [
	^ self new value: aValue; interval: anInterval; max: anInterval upper; leftDepth: 0; rightDepth: 0
]

{ #category : #accessing }
GtIntervalTree >> balance [
	^ rightDepth - leftDepth
]

{ #category : #accessing }
GtIntervalTree >> depth [
	^ leftDepth max: rightDepth
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

	| res |
	anInterval lower < interval lower
		ifTrue: [ 
			left
				ifNil: [ 
					left := GtIntervalTree node: aValue at: anInterval.
					leftDepth := 1 ]
				ifNotNil: [ left := (left insert: aValue at: anInterval) ] ]
		ifFalse: [ 
			right
				ifNil: [ 
					right := GtIntervalTree node: aValue at: anInterval.
					rightDepth := 1 ]
				ifNotNil: [ right := (right insert: aValue at: anInterval) ] ].

	max < anInterval upper ifTrue: [ max := anInterval upper ].
	
	self recalculateDepthsOne.
	
	^ self rebalance
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
GtIntervalTree >> left: aNode [
	left := aNode
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
GtIntervalTree >> rebalance [
	"self halt."
	(self balance < -1 and: (left isNotNil and: [left balance < 0])) ifTrue: [ ^ self rotateRight].
	(self balance > 1 and: (right isNotNil and: [right balance > 0])) ifTrue: [ ^ self rotateLeft].
	(self balance < -1 and: (left isNotNil and: [left balance > 0])) ifTrue: [ ^ self rotateLeftRight].
	(self balance > 1 and: (right isNotNil and: [right balance < 0])) ifTrue: [ ^ self rotateRightLeft].
	^ self
]

{ #category : #accessing }
GtIntervalTree >> recalculateDepths [
	left ifNil: [ leftDepth := 0 ] ifNotNil: [ left recalculateDepths. leftDepth := left depth + 1].
	right ifNil: [ rightDepth := 0 ] ifNotNil: [ right recalculateDepths. rightDepth := right depth + 1].
]

{ #category : #accessing }
GtIntervalTree >> recalculateDepthsOne [
	"non-recursive version of recalculateDepths. useful if you know the child nodes' depths are accurate (such as at the end of insert)"
	left ifNil: [ leftDepth := 0 ] ifNotNil: [ leftDepth := left depth + 1].
	right ifNil: [ rightDepth := 0 ] ifNotNil: [ rightDepth := right depth + 1].
]

{ #category : #accessing }
GtIntervalTree >> right [
	^ right
]

{ #category : #accessing }
GtIntervalTree >> right: aNode [
	right := aNode
]

{ #category : #accessing }
GtIntervalTree >> rightDepth: anInteger [
	rightDepth := anInteger
]

{ #category : #accessing }
GtIntervalTree >> rotateLeft [
	| r |
	r := right.
	right := r left.
	r left: self.
	r recalculateDepths.
	self recalculateDepths.
	self max: (right ifNil: [0] ifNotNil: [right max]).
	^ r
]

{ #category : #accessing }
GtIntervalTree >> rotateLeftRight [
	| res |
	left := left rotateLeft.
	res := self rotateRight.
	res recalculateDepths.
	^ res
]

{ #category : #accessing }
GtIntervalTree >> rotateRight [
	| l |
	l := left.
	left := l right.
	l right: self.
	l max: l right max.
	self recalculateDepths.
	l recalculateDepths.
	^ l
]

{ #category : #accessing }
GtIntervalTree >> rotateRightLeft [
	| res |
	right := right rotateRight.
	res := self rotateLeft.
	res recalculateDepths.
	^ res
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
