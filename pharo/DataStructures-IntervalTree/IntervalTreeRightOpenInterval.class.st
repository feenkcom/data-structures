Class {
	#name : #IntervalTreeRightOpenInterval,
	#superclass : #IntervalTreeInterval,
	#instVars : [
		'from',
		'to'
	],
	#category : #'DataStructures-IntervalTree'
}

{ #category : #'instance creation' }
IntervalTreeRightOpenInterval class >> from: aFromNumber to: aToNumber [
	^ self new
		from: aFromNumber;
		to: aToNumber
]

{ #category : #accessing }
IntervalTreeRightOpenInterval >> first [
	^ self from
]

{ #category : #accessing }
IntervalTreeRightOpenInterval >> from [
	^ from
]

{ #category : #accessing }
IntervalTreeRightOpenInterval >> from: anObject [
	from := anObject
]

{ #category : #accessing }
IntervalTreeRightOpenInterval >> last [
	^ self to - 1
]

{ #category : #printing }
IntervalTreeRightOpenInterval >> printOn: aStream [
	aStream
		nextPut: $[;
		print: self from;
		nextPut: $,;
		space;
		print: self to;
		nextPut: $)
]

{ #category : #accessing }
IntervalTreeRightOpenInterval >> to [
	^ to
]

{ #category : #accessing }
IntervalTreeRightOpenInterval >> to: anObject [
	to := anObject
]
