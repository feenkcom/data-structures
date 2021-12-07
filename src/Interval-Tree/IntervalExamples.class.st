Class {
	#name : #IntervalExamples,
	#superclass : #Object,
	#category : #'Interval-Tree-Examples'
}

{ #category : #accessing }
IntervalExamples >> contains [
	<gtExample>
	^ (GtInterval from: 1 to: 10) contains: (GtInterval from: 1 to: 5)
]

{ #category : #accessing }
IntervalExamples >> intervalString [
	<gtExample>
	^ self numericInterval intervalString
]

{ #category : #accessing }
IntervalExamples >> numericInterval [
	<gtExample>
	^ GtInterval from: 1 to: 120
]
