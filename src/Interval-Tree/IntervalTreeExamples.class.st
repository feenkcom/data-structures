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
IntervalTreeExamples >> negativeMax [
	<gtExample>
	| tree searchResult |
	tree := IntervalTree fromNodes: {
		'A' -> (GtInterval from: -13 to: -10).
		'B' -> (GtInterval from: -10 to: -5).
		'C' -> (GtInterval from: -5 to: -3).
		'D' -> (GtInterval from: -3 to: -2).
		'E' -> (GtInterval from: -2 to: -1).
	}.
	self assert: tree max = -1.
	self assert: tree left max = -10.
	^ tree
]

{ #category : #accessing }
IntervalTreeExamples >> remove [

	<gtExample>
	| tree removed |
	tree := self tree.
	self assert: (tree search: 7) size = 1.
	removed := tree remove: (GtInterval from: 6 to: 8).
	self assert: (removed search: 7) size = 0.
	^ removed
]

{ #category : #accessing }
IntervalTreeExamples >> removeIf [

	<gtExample>
	| tree removed |
	tree := self tree.
	self assert: (tree search: 386) size = 5.
	removed := tree
		           remove: (GtInterval from: 386 to: 386)
		           if: [ :value | value beginsWith: 'Murong' ].
	self assert: (removed search: 386) size = 2.
	^ removed
]

{ #category : #accessing }
IntervalTreeExamples >> removeMultiple [
	<gtExample>
	| tree removed |
	tree := self tree.
	self assert: (tree search: 386) size = 5.
	removed := tree
		           remove: (GtInterval from: 386 to: 386).
	self assert: (removed search: 386) size = 1.
	^ removed
]

{ #category : #accessing }
IntervalTreeExamples >> removeOverlapping [
	<gtExample>
	| tree removed |
	tree := self tree.
	self assert: (tree search: 386) size = 5.
	removed := tree
		           removeOverlapping: (GtInterval from: 386 to: 915).
	self assert: (removed search: 386) size = 0.
	^ removed
]

{ #category : #accessing }
IntervalTreeExamples >> removeRoot [
	<gtExample>
	^ self tree remove: (GtInterval from: -209 to: -206)
]

{ #category : #accessing }
IntervalTreeExamples >> search [
	<gtExample>
	| tree searchResult |
	tree := self tree.
	searchResult := tree search: 386.
	self assert: searchResult size = 5.
	^ searchResult
]

{ #category : #accessing }
IntervalTreeExamples >> searchInterval [

	<gtExample>
	| tree searchResult |
	tree := self tree.
	searchResult := tree searchInterval: (GtInterval from: 364 to: 1000).
	self assert: searchResult size = 6.
	^ searchResult
]

{ #category : #accessing }
IntervalTreeExamples >> searchIntervalExactly [

	<gtExample>
	| tree searchResult |
	tree := self tree.
	searchResult := tree searchInterval: (GtInterval from: 6 to: 8).
	self assert: (searchResult size = 1 and: [ searchResult first = 'Ruzi Ying']).
	^ searchResult
]

{ #category : #accessing }
IntervalTreeExamples >> shiftLeftAfter0 [

	<gtExample>
	| tree shifted |
	tree := self tree.
	shifted := tree shiftIntervalsBy: -1000 after: 0.
	shifted depthFirstDo: [:each | self assert: (each interval lower < 0 or: each interval lower > 1000) ].
	^ shifted
]

{ #category : #accessing }
IntervalTreeExamples >> shiftRightAfter100 [

	<gtExample>
	| tree shifted |
	tree := self tree.
	shifted := tree shiftIntervalsBy: 1000 after: -100.
	shifted depthFirstDo: [:each | self assert: (each interval lower < -100 or: each interval lower > 900) ].
	^ shifted
]

{ #category : #accessing }
IntervalTreeExamples >> shiftRightExactly [

	<gtExample>
	| tree shifted searchResult |
	tree := self tree.
	shifted := tree shiftIntervalsBy: 1000 after: 6.
	searchResult := shifted searchInterval: (GtInterval from: 1006 to: 1008).
	self assert: (searchResult size = 1 and: [searchResult first = 'Ruzi Ying']).
	^ shifted
]

{ #category : #accessing }
IntervalTreeExamples >> size [
	<gtExample>
	| tree |
	tree := self tree.
	self assert:tree size = 11. 
	^ tree
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
	| treeA treeB difference |
	treeA := self tree.

	treeB := IntervalTree fromNodes: { 
			         ('Murong Yong' -> (GtInterval from: 386 to: 394)).
			         ('Ruzi Ying' -> (GtInterval from: 6 to: 8)).
			         ('Bu Jiang' -> (GtInterval from: -1851 to: -1792)).
			         ('Qin Er Shi' -> (GtInterval from: -209 to: -206)).
			         ('Not in the other tree'
			          -> (GtInterval from: 5000 to: 6000)) }.
	difference := treeA diff: treeB.
	self assert: difference size = 7.
	^ difference
]
