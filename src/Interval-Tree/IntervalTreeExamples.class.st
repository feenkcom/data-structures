Class {
	#name : #IntervalTreeExamples,
	#superclass : #Object,
	#category : #'Interval-Tree-Examples'
}

{ #category : #accessing }
IntervalTreeExamples >> empty [
	<gtExample>
	^ IntervalTree empty
]

{ #category : #accessing }
IntervalTreeExamples >> remove [
	<gtExample>
	^ self tree remove: (GtInterval from: 6 to: 8)
]

{ #category : #accessing }
IntervalTreeExamples >> removeIf [
	<gtExample>
	^ self tree remove: (GtInterval from: 386 to: 386) if: [:value | value beginsWith: 'Murong']
]

{ #category : #accessing }
IntervalTreeExamples >> removeMultiple [
	<gtExample>
	^ self tree remove: (GtInterval from: 386 to: 386)
]

{ #category : #accessing }
IntervalTreeExamples >> removeOverlapping [
	<gtExample>
	^ self tree removeOverlapping: (GtInterval from: 386 to: 915)
]

{ #category : #accessing }
IntervalTreeExamples >> removeRoot [
	<gtExample>
	^ self tree remove: (GtInterval from: -209 to: -206)
]

{ #category : #accessing }
IntervalTreeExamples >> search [
	<gtExample>
	| tree |
	tree := self tree.
	^ tree search: 386.
]

{ #category : #accessing }
IntervalTreeExamples >> searchInterval [
	<gtExample>
	| tree |
	tree := self tree.
	^ tree searchInterval: (GtInterval from: 364 to:1000).
]

{ #category : #accessing }
IntervalTreeExamples >> shiftLeft [
	<gtExample>
	^ self tree shiftIntervalsBy: -1000 after: 100
]

{ #category : #accessing }
IntervalTreeExamples >> shiftRight [
	<gtExample>
	^ self tree shiftIntervalsBy: 1000 after: -100
]

{ #category : #accessing }
IntervalTreeExamples >> tree [
	<gtExample>
	| root |
	root := IntervalTree fromNodes: {
		'Youchao' -> (GtInterval from: -3162 to: -2962).
		'Bu Jiang' -> (GtInterval from: -1851 to: -1792). 
		'Pan Geng' -> (GtInterval from: -1290 to: -1262). 
		'Qin Er Shi' -> (GtInterval from: -209 to: -206).
		'Ruzi Ying' -> (GtInterval from: 6 to: 8).
		'Murong Yong' -> (GtInterval from: 386 to: 394).
		'Murong Zhong' -> (GtInterval from: 386 to: 386).
		'Murong Yao' -> (GtInterval from: 386 to: 386).
		'Murong Yi' -> (GtInterval from: 386 to: 386).
		'Duan Sui' -> (GtInterval from: 386 to: 386).
		'Zhū Wēn' -> (GtInterval from: 907 to:912).
	}.
	^ root
]

{ #category : #accessing }
IntervalTreeExamples >> treeDiff [
	<gtExample>
	
	| treeA treeB |
	treeA := self tree.
	
	treeB := IntervalTree fromNodes: {
		'Murong Yong' -> (GtInterval from: 386 to: 394).
		'Ruzi Ying' -> (GtInterval from: 6 to: 8).
		'Bu Jiang' -> (GtInterval from: -1851 to: -1792).
		'Qin Er Shi' -> (GtInterval from: -209 to: -206).
		'Not in the other tree' -> (GtInterval from: 5000 to: 6000).
	}.
	^ treeA diff: treeB
]
