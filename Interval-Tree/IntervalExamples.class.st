Class {
	#name : #IntervalExamples,
	#superclass : #Object,
	#category : #'Interval-Tree-Examples'
}

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
