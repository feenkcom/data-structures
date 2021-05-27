Class {
	#name : #IntervalTreeNodeExamples,
	#superclass : #Object,
	#category : #'DataStructures-IntervalTree-Examples'
}

{ #category : #examples }
IntervalTreeNodeExamples >> neighboursClosedInterval [
	<gtExample>
	| aNode |
	
	aNode := IntervalTreeNode interval: (IntervalTreeClosedInterval from: 5 to: 10).
	self assert: (aNode neighboursInterval: (IntervalTreeClosedInterval from: 2 to: 3)) not.
	self assert: (aNode neighboursInterval: (IntervalTreeClosedInterval from: 2 to: 4)).
	self assert: (aNode neighboursInterval: (IntervalTreeClosedInterval from: 2 to: 5)) not.
	self assert: (aNode neighboursInterval: (IntervalTreeClosedInterval from: 2 to: 6)) not.
	self assert: (aNode neighboursInterval: (IntervalTreeClosedInterval from: 5 to: 10)) not.
	self assert: (aNode neighboursInterval: (IntervalTreeClosedInterval from: 10 to: 12)) not.
	self assert: (aNode neighboursInterval: (IntervalTreeClosedInterval from: 11 to: 13)).
	
	^ aNode
]

{ #category : #examples }
IntervalTreeNodeExamples >> overlapsClosedInterval [
	<gtExample>
	| aNode |
	
	aNode := IntervalTreeNode interval: (IntervalTreeClosedInterval from: 5 to: 10).
	self assert: (aNode overlapsInterval: (IntervalTreeClosedInterval from: 2 to: 4)) not.
	self assert: (aNode overlapsInterval: (IntervalTreeClosedInterval from: 2 to: 5)).
	self assert: (aNode overlapsInterval: (IntervalTreeClosedInterval from: 2 to: 6)).
	self assert: (aNode overlapsInterval: (IntervalTreeClosedInterval from: 5 to: 10)).
	self assert: (aNode overlapsInterval: (IntervalTreeClosedInterval from: 10 to: 12)).
	self assert: (aNode overlapsInterval: (IntervalTreeClosedInterval from: 11 to: 13)) not.
	
	^ aNode
]

{ #category : #examples }
IntervalTreeNodeExamples >> overlapsOpenInterval [
	<gtExample>
	| aNode |
	
	aNode := IntervalTreeNode interval: (IntervalTreeClosedInterval from: 5 to: 10).
	self assert: (aNode overlapsInterval: (IntervalTreeOpenInterval from: 2 to: 4)) not.
	self assert: (aNode overlapsInterval: (IntervalTreeOpenInterval from: 2 to: 5)) not.
	self assert: (aNode overlapsInterval: (IntervalTreeOpenInterval from: 2 to: 6)).
	self assert: (aNode overlapsInterval: (IntervalTreeOpenInterval from: 5 to: 10)).
	self assert: (aNode overlapsInterval: (IntervalTreeOpenInterval from: 10 to: 12)) not.
	self assert: (aNode overlapsInterval: (IntervalTreeOpenInterval from: 11 to: 13)) not.
	
	^ aNode
]
