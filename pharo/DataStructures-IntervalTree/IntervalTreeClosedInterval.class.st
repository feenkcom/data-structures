Class {
	#name : #IntervalTreeClosedInterval,
	#superclass : #IntervalTreeInterval,
	#instVars : [
		'from',
		'to'
	],
	#category : #'DataStructures-IntervalTree'
}

{ #category : #'instance creation' }
IntervalTreeClosedInterval class >> from: aFromNumber to: aToNumber [
	^ self new
		from: aFromNumber;
		to: aToNumber
]

{ #category : #accessing }
IntervalTreeClosedInterval >> first [
	^ self from
]

{ #category : #accessing }
IntervalTreeClosedInterval >> from [
	^ from
]

{ #category : #accessing }
IntervalTreeClosedInterval >> from: anObject [
	from := anObject
]

{ #category : #accessing }
IntervalTreeClosedInterval >> last [
	^ self to
]

{ #category : #printing }
IntervalTreeClosedInterval >> printOn: aStream [
	aStream
		nextPut: $[;
		print: self from;
		nextPut: $,;
		space;
		print: self to;
		nextPut: $]
]

{ #category : #accessing }
IntervalTreeClosedInterval >> to [
	^ to
]

{ #category : #accessing }
IntervalTreeClosedInterval >> to: anObject [
	to := anObject
]
