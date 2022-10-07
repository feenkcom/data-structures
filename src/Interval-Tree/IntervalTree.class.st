"
# Interval Tree

is a simple implementation of an interval tree, providing a way to query values by intervals or values within the interval.

#Example

{{gtExample:IntervalTreeExamples>>search}}
"
Class {
	#name : #IntervalTree,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'value',
		'max',
		'interval',
		'leftDepth',
		'rightDepth',
		'parent'
	],
	#category : #'Interval-Tree-Core'
}

{ #category : #accessing }
IntervalTree class >> empty [
	^ self new leftDepth: 0; rightDepth: 0
]

{ #category : #accessing }
IntervalTree class >> fromNodes: aCollectionOfAssociations [
	| root |
	self assert: aCollectionOfAssociations isNotEmpty.
	
	root := self node: aCollectionOfAssociations first key at:aCollectionOfAssociations first value.
	
	aCollectionOfAssociations allButFirst do: [:each | root := root insert: each key at: each value].
	
	^ root 
]

{ #category : #accessing }
IntervalTree class >> node: aValue at: anInterval [
	^ self new value: aValue; interval: anInterval; max: anInterval upper; leftDepth: 0; rightDepth: 0
]

{ #category : #accessing }
IntervalTree >> balance [
	^ rightDepth - leftDepth
]

{ #category : #accessing }
IntervalTree >> depth [
	^ leftDepth max: rightDepth
]

{ #category : #accessing }
IntervalTree >> depthFirstCollect: aBlock [

	| res |
	res := OrderedCollection new.

	left ifNotNil: [ res addAll: (left depthFirstCollect: aBlock) ].

	res add: (aBlock value: self).

	right ifNotNil: [ res addAll: (right depthFirstCollect: aBlock) ].

	^ res
]

{ #category : #accessing }
IntervalTree >> depthFirstCollect: aBlock branchedOnLeft: aBranchingBlock [

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
IntervalTree >> depthFirstCollect: aBlock filteredWithLeft: aLeftFilterBlock andRight: aRightFilterBlock [

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
IntervalTree >> depthFirstDo: aBlock [

	left ifNotNil: [ left depthFirstDo: aBlock ].

	aBlock value: self.

	right ifNotNil: [ right depthFirstDo: aBlock ]
]

{ #category : #accessing }
IntervalTree >> depthFirstDo: aBlock branchedOnLeft: aBranchingBlock [

	| leftCond |
	leftCond := left isNotNil and: [ aBranchingBlock value: left ].
	leftCond ifTrue: [ 
		left depthFirstCollect: aBlock ].

	aBlock value: self.

	(right isNotNil and: leftCond not) ifTrue: [ 
		right depthFirstCollect: aBlock ]
]

{ #category : #accessing }
IntervalTree >> depthFirstDo: aBlock filteredWithLeft: aLeftFilterBlock andRight: aRightFilterBlock [

	(left isNotNil and: [ aLeftFilterBlock value: left ]) ifTrue: [ 
		left depthFirstCollect: aBlock ].

	aBlock value: self.

	(right isNotNil and: [ aRightFilterBlock value: right ]) ifTrue: [ 
		right depthFirstCollect: aBlock ]
]

{ #category : #accessing }
IntervalTree >> diff: aTree [
	| nodesA nodesB |
	nodesA := self depthFirstCollect: [:each | each interval -> each value].
	nodesB := aTree depthFirstCollect: [:each | each interval -> each value].
	
	^ nodesA copyWithoutAll: nodesB
]

{ #category : #accessing }
IntervalTree >> gtChildren [
	| children |
	children := OrderedCollection new.
	left ifNotNil: [children add: left].
	right ifNotNil: [children add: right].
	^ children
]

{ #category : #accessing }
IntervalTree >> gtGraphFor: aView [

	<gtView>
	interval ifNil: [
		^ aView empty.
	].
	^ aView mondrian
		  title: 'Graph';
		  priority: 1;
		  painting: [ :m | 
			  m nodes
				  stencil: [ :each | 
				  	BrVerticalPane new
				  		fitContent;
				  		alignCenter;
				  		addChild: (
					  		BrLabel new
						  		aptitude: BrGlamorousLabelAptitude;
						  		text: each value asString);
				  		addChild: (
					  		BrLabel new
						  		aptitude: (BrGlamorousLabelAptitude new foreground: Color gray; fontSize: 10);
						  		text: each interval intervalString);
				  		addChild: (
					  		BrLabel new
						  		aptitude: (BrGlamorousLabelAptitude new foreground: Color gray; fontSize: 10);
						  		text: 'Max: ' , each max asString)
						  		 ];
				  with: (self depthFirstCollect: #yourself).
			  m edges connectToAll: #gtChildren.
			  m layout tree separateSubtrees: true; nodeDistance: 10 ]
]

{ #category : #accessing }
IntervalTree >> gtTreeFor: aView [
	<gtView>
	
	^ aView columnedTree
		  title: 'Tree';
		  priority: 2;
		  items: [ interval ifNil: [{}] ifNotNil: [{ self }] ];
		  children: #gtChildren;
		  column: 'Value' text: #value;
		  column: 'Interval' text: [ :eachItem | eachItem interval intervalString ]
]

{ #category : #accessing }
IntervalTree >> insert: aValue at: anInterval [
	
	"we were empty before"
	interval ifNil: [
		interval := anInterval.
		value := aValue.
		max := anInterval upper.
		^ self
	].
	
	anInterval lower < interval lower
		ifTrue: [ 
			left
				ifNil: [ 
					left := IntervalTree node: aValue at: anInterval.
					left parent: self.
					leftDepth := 1 ]
				ifNotNil: [ left := (left insert: aValue at: anInterval) ] ]
		ifFalse: [ 
			right
				ifNil: [ 
					right := IntervalTree node: aValue at: anInterval.
					right parent: self.
					rightDepth := 1 ]
				ifNotNil: [ right := (right insert: aValue at: anInterval) ] ].

	max < anInterval upper ifTrue: [ max := anInterval upper ].
	
	self recalculateDepthsOne.
	
	^ self rebalance
]

{ #category : #accessing }
IntervalTree >> interval [
	^ interval
]

{ #category : #accessing }
IntervalTree >> interval: anInterval [
	interval := anInterval
]

{ #category : #accessing }
IntervalTree >> left [
	^ left
]

{ #category : #accessing }
IntervalTree >> left: aNode [
	left := aNode.
	left ifNotNil: [ left parent: self ]
]

{ #category : #accessing }
IntervalTree >> leftDepth: anInteger [
	leftDepth := anInteger
]

{ #category : #accessing }
IntervalTree >> max [

	^ max
]

{ #category : #accessing }
IntervalTree >> max: aValue [
	max := aValue
]

{ #category : #accessing }
IntervalTree >> parent: aNode [
	parent := aNode
]

{ #category : #accessing }
IntervalTree >> rebalance [
	(self balance < -1 and: (left isNotNil and: [left balance < 0])) ifTrue: [ ^ self rotateRight].
	(self balance > 1 and: (right isNotNil and: [right balance > 0])) ifTrue: [ ^ self rotateLeft].
	(self balance < -1 and: (left isNotNil and: [left balance > 0])) ifTrue: [ ^ self rotateLeftRight].
	(self balance > 1 and: (right isNotNil and: [right balance < 0])) ifTrue: [ ^ self rotateRightLeft].
	^ self
]

{ #category : #accessing }
IntervalTree >> recalculateDepths [
	left ifNil: [ leftDepth := 0 ] ifNotNil: [ left recalculateDepths. leftDepth := left depth + 1].
	right ifNil: [ rightDepth := 0 ] ifNotNil: [ right recalculateDepths. rightDepth := right depth + 1].
]

{ #category : #accessing }
IntervalTree >> recalculateDepthsOne [
	"non-recursive version of recalculateDepths. useful if you know the child nodes' depths are accurate (such as at the end of insert)"
	left ifNil: [ leftDepth := 0 ] ifNotNil: [ leftDepth := left depth + 1].
	right ifNil: [ rightDepth := 0 ] ifNotNil: [ rightDepth := right depth + 1].
]

{ #category : #accessing }
IntervalTree >> reloadTree: aNode [

	| s |
	s := self.
	aNode ifNil: [ ^ s ].
	aNode left ifNotNil: [ s := s reloadTree: aNode left ].
	aNode right ifNotNil: [ s := s reloadTree: aNode right ].
	^ s insert: aNode value at: aNode interval
]

{ #category : #accessing }
IntervalTree >> remove: anInterval [

	left ifNotNil: [ left remove: anInterval ].
	right ifNotNil: [ right remove: anInterval ].
	interval = anInterval ifTrue: [ 
		parent ifNil: [ ^ left reloadTree: right ] ifNotNil: [ 
			left
				ifNil: [ 
					self = parent left
						ifTrue: [ parent left: right ]
						ifFalse: [ parent right: right ] ]
				ifNotNil: [ 
					self = parent left
						ifTrue: [ parent left: left ]
						ifFalse: [ parent right: left ].
					^ parent reloadTree: right ] ] ]
]

{ #category : #accessing }
IntervalTree >> remove: anInterval if: aBlock [

	left ifNotNil: [ left remove: anInterval if: aBlock ].
	right ifNotNil: [ right remove: anInterval if: aBlock ].
	(interval = anInterval and: [ aBlock value: value ]) ifTrue: [ 
		parent ifNil: [ ^ left reloadTree: right ] ifNotNil: [ 
			left
				ifNil: [ 
					self = parent left
						ifTrue: [ parent left: right ]
						ifFalse: [ parent right: right ] ]
				ifNotNil: [ 
					self = parent left
						ifTrue: [ parent left: left ]
						ifFalse: [ parent right: left ].
					^ parent reloadTree: right ] ] ]
]

{ #category : #accessing }
IntervalTree >> removeOverlapping: anInterval [

	left ifNotNil: [ left removeOverlapping: anInterval ].
	right ifNotNil: [ right removeOverlapping: anInterval ].
	(anInterval contains: interval) ifTrue: [ 
		parent ifNil: [ ^ left reloadTree: right ] ifNotNil: [ 
			left
				ifNil: [ 
					self = parent left
						ifTrue: [ parent left: right ]
						ifFalse: [ parent right: right ] ]
				ifNotNil: [ 
					self = parent left
						ifTrue: [ parent left: left ]
						ifFalse: [ parent right: left ].
					^ parent reloadTree: right ] ] ]
]

{ #category : #accessing }
IntervalTree >> right [
	^ right
]

{ #category : #accessing }
IntervalTree >> right: aNode [
	right := aNode.
	right ifNotNil: [ right parent: self ]
]

{ #category : #accessing }
IntervalTree >> rightDepth: anInteger [
	rightDepth := anInteger
]

{ #category : #accessing }
IntervalTree >> rotateLeft [
	| r |
	r := right.
	right := r left.
	right ifNotNil: [ right parent: self ].	
	r parent: parent.
	r left: self.
	r recalculateDepths.
	self recalculateDepths.
	self max: (right ifNil: [interval upper] ifNotNil: [right max]).
	^ r
]

{ #category : #accessing }
IntervalTree >> rotateLeftRight [
	| res |
	left := left rotateLeft.
	res := self rotateRight.
	res recalculateDepths.
	^ res
]

{ #category : #accessing }
IntervalTree >> rotateRight [

	| l |
	l := left.
	left := l right.
	l parent: parent.
	l right: self.
	left ifNotNil: [ left parent: self ].
	l max: l right max.
	self recalculateDepths.
	l recalculateDepths.
	^ l
]

{ #category : #accessing }
IntervalTree >> rotateRightLeft [
	| res |
	right := right rotateRight.
	res := self rotateLeft.
	res recalculateDepths.
	^ res
]

{ #category : #accessing }
IntervalTree >> search: aValue [

	| res |
	res := OrderedCollection new.

	self
		depthFirstDo: [ :aNode | 
			(aNode interval contains: aValue) ifTrue: [ res add: aNode value ] ]
		branchedOnLeft: [ :aNode | aNode max >= aValue ].

	^ res
]

{ #category : #accessing }
IntervalTree >> searchInterval: anInterval [

	| res |
	res := OrderedCollection new.

	self depthFirstDo: [ :aNode | 
		(aNode interval overlaps: anInterval) ifTrue: [ 
			res add: aNode value ] ] branchedOnLeft: [ :aNode | aNode max >= anInterval lower ].

	^ res
]

{ #category : #accessing }
IntervalTree >> shiftIntervalsBy: aNumber after: anotherNumber [

	"TODO: this needs to move the entire tree possibly"

	| r l |
	self depthFirstDo: [ :each | 
		each interval lower >= anotherNumber ifTrue: [ 
			each interval shiftBy: aNumber ] ].
	r := right.
	right ifNotNil: [ right parent: nil ].
	self right: nil.
	l := left.
	left ifNotNil: [ left parent: nil ].
	self left: nil.
	^ (self reloadTree: l) reloadTree: r
]

{ #category : #accessing }
IntervalTree >> size [
	| count |
	count := 0.
	self depthFirstDo: [:_ | count := count + 1 ].
	^ count
]

{ #category : #accessing }
IntervalTree >> value [
	^ value
]

{ #category : #accessing }
IntervalTree >> value: aValue [
	value := aValue
]
