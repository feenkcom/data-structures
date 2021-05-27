Class {
	#name : #IntervalTreeOpenInterval,
	#superclass : #IntervalTreeInterval,
	#instVars : [
		'from',
		'to'
	],
	#category : #'DataStructures-IntervalTree'
}

{ #category : #'instance creation' }
IntervalTreeOpenInterval class >> from: aFromNumber to: aToNumber [
	^ self new
		from: aFromNumber;
		to: aToNumber
]

{ #category : #accessing }
IntervalTreeOpenInterval >> first [
	^ self from + 1
]

{ #category : #accessing }
IntervalTreeOpenInterval >> from [
	^ from
]

{ #category : #accessing }
IntervalTreeOpenInterval >> from: anObject [
	from := anObject
]

{ #category : #accessing }
IntervalTreeOpenInterval >> last [
	^ self to - 1
]

{ #category : #printing }
IntervalTreeOpenInterval >> printOn: aStream [
	aStream
		nextPut: $(;
		print: self from;
		nextPut: $,;
		space;
		print: self to;
		nextPut: $)
]

{ #category : #accessing }
IntervalTreeOpenInterval >> to [
	^ to
]

{ #category : #accessing }
IntervalTreeOpenInterval >> to: anObject [
	to := anObject
]
