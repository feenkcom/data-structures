Class {
	#name : #GtInterval,
	#superclass : #Object,
	#instVars : [
		'lower',
		'upper'
	],
	#category : #'Interval-Tree-Core'
}

{ #category : #accessing }
GtInterval class >> from: aValue to: anotherValue [
	^ self new lower: aValue; upper: anotherValue
]

{ #category : #accessing }
GtInterval >> = other [
	^ lower = other lower and: upper = other upper
]

{ #category : #accessing }
GtInterval >> contains: aValue [
	^ lower <= aValue and: upper >= aValue
]

{ #category : #accessing }
GtInterval >> intervalString [
	^ '[', lower asString, ', ', upper asString, ']'
]

{ #category : #accessing }
GtInterval >> lower [
	^ lower
]

{ #category : #accessing }
GtInterval >> lower: aValue [
	lower := aValue
]

{ #category : #accessing }
GtInterval >> overlaps: anInterval [
	^ lower <= anInterval upper and: anInterval lower <= upper
]

{ #category : #accessing }
GtInterval >> upper [
	^ upper
]

{ #category : #accessing }
GtInterval >> upper: aValue [
	upper := aValue
]
