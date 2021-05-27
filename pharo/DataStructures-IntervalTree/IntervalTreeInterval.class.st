Class {
	#name : #IntervalTreeInterval,
	#superclass : #Object,
	#category : #'DataStructures-IntervalTree'
}

{ #category : #accessing }
IntervalTreeInterval >> first [
	^ self subclassResponsibility
]

{ #category : #testing }
IntervalTreeInterval >> isEmpty [
	^ self first > self last
]

{ #category : #accessing }
IntervalTreeInterval >> last [
	^ self subclassResponsibility
]

{ #category : #testing }
IntervalTreeInterval >> neighboursInterval: anIntervalTreeInterval [
	"Return true if I am a neighour of a given interval, false otherwise.
	Overlapping intervals are not considered as neighbours"
	<return: #Boolean>
	
	"I am to the left"
	^ ((self last + 1) = anIntervalTreeInterval first)
		"I am to the right"
		or: [ (self first - 1) = anIntervalTreeInterval last ]
]

{ #category : #testing }
IntervalTreeInterval >> overlapsInterval: anIntervalTreeInterval [
	"Return true if I overlap with a given interval, false otherwise.
	Intervals such as [6, 7] and [7, 9] are considered to be overllaping,
	while intervals [5, 6] and [7, 9] do *not* overlap.
	Similarly, intervals [5,7) and (6, 8] are overlapping, while
	intervals [6, 7) and (7, 8] are not overlapping."
	<return: #Boolean>

	^ (self rangeIncludes: anIntervalTreeInterval first)
		or: [ (self rangeIncludes: anIntervalTreeInterval last)
			or: [ (anIntervalTreeInterval rangeIncludes: self first)
				or: [ (anIntervalTreeInterval rangeIncludes: self last) ] ] ]
]

{ #category : #testing }
IntervalTreeInterval >> rangeIncludes: aNumber [
	"Return true if the number lies in the interval between from and to"
	<return: #Boolean>

	^ aNumber between: self first and: self last
]
