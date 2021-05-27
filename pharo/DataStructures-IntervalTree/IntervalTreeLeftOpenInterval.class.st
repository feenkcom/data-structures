Class {
	#name : #IntervalTreeLeftOpenInterval,
	#superclass : #IntervalTreeInterval,
	#instVars : [
		'from',
		'to'
	],
	#category : #'DataStructures-IntervalTree'
}

{ #category : #'instance creation' }
IntervalTreeLeftOpenInterval class >> from: aFromNumber to: aToNumber [
	^ self new
		from: aFromNumber;
		to: aToNumber
]

{ #category : #accessing }
IntervalTreeLeftOpenInterval >> first [
	^ self from + 1
]

{ #category : #accessing }
IntervalTreeLeftOpenInterval >> from [
	^ from
]

{ #category : #accessing }
IntervalTreeLeftOpenInterval >> from: anObject [
	from := anObject
]

{ #category : #accessing }
IntervalTreeLeftOpenInterval >> last [
	^ self to
]

{ #category : #printing }
IntervalTreeLeftOpenInterval >> printOn: aStream [
	aStream
		nextPut: $(;
		print: self from;
		nextPut: $,;
		space;
		print: self to;
		nextPut: $]
]

{ #category : #accessing }
IntervalTreeLeftOpenInterval >> to [
	^ to
]

{ #category : #accessing }
IntervalTreeLeftOpenInterval >> to: anObject [
	to := anObject
]
