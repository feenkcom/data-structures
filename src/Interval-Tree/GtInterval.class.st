"
# Interval

is an implementation of intervals meant to be used with {{gtClass:GtIntervalTree}}.

#Example
{{gtExample:IntervalExamples>>numericInterval}}
"
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
	^ (other isKindOf: GtInterval) and: [lower = other lower and: upper = other upper]
]

{ #category : #accessing }
GtInterval >> contains: aValue [

	(aValue isKindOf: GtInterval) ifTrue: [ 
		^ lower <= aValue lower and: upper >= aValue upper ].
	^ lower <= aValue and: upper >= aValue
]

{ #category : #accessing }
GtInterval >> gtLiveFor: aView [

	<gtView>
	^ aView explicit
		  title: 'Live';
		  stencil: [ 
			  BlElement new
				  layout: BlFrameLayout new;
				  constraintsDo: [ :c | 
					  c horizontal matchParent.
					  c vertical matchParent ];
				  addChild: (BlElement new
						   aptitude: BrShadowAptitude new;
						   background: Color white;
						   constraintsDo: [ :c | 
							   c frame horizontal alignCenter.
							   c frame vertical alignCenter.
							   c horizontal fitContent.
							   c vertical fitContent ];
						   layout: BlLinearLayout horizontal;
						   addChild: (BrLabel new
								    text: lower asString;
								    aptitude: BrGlamorousLabelAptitude;
								    layout: BlLinearLayout vertical alignCenter;
								    padding: (BlInsets all: 10));
						   addChild: ((BrGlamorousVectorIcons right asElement asScalableElement)
								    layout: BlLinearLayout vertical alignCenter;
								    margin: (BlInsets all: 5));
						   addChild: (BrLabel new
								    text: upper asString;
								    aptitude: BrGlamorousLabelAptitude;
								    layout: BlLinearLayout vertical alignCenter;
								    padding: (BlInsets all: 10))) ]
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
GtInterval >> shiftBy: aNumber [
	lower := lower + aNumber.
	upper := upper + aNumber
]

{ #category : #accessing }
GtInterval >> upper [
	^ upper
]

{ #category : #accessing }
GtInterval >> upper: aValue [
	upper := aValue
]
