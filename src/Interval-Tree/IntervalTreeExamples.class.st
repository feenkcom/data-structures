Class {
	#name : #IntervalTreeExamples,
	#superclass : #Object,
	#category : #'Interval-Tree-Examples'
}

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
IntervalTreeExamples >> tree [
	<gtExample>
	| root |
	root := GtIntervalTree node: 'Murong Yong' at: (GtInterval from: 386 to: 394).
	root insert: 'Ruzi Ying' at: (GtInterval from: 6 to: 8).
	root insert: 'Bu Jiang' at: (GtInterval from: -1851 to: -1792).
	root insert: 'Qin Er Shi' at: (GtInterval from: -209 to: -206).
	root insert: 'Zhū Wēn' at: (GtInterval from: 907 to:912).
	root insert: 'Murong Zhong' at: (GtInterval from: 386 to: 386).
	root insert: 'Murong Yao' at: (GtInterval from: 386 to: 386).
	root insert: 'Murong Yi' at: (GtInterval from: 386 to: 386).
	root insert: 'Duan Sui' at: (GtInterval from: 386 to: 386).
	root insert: 'Youchao' at: (GtInterval from: -3162 to: -2962).
	root insert: 'Pan Geng' at: (GtInterval from: -1290 to: -1262).
	^ root
]

{ #category : #accessing }
IntervalTreeExamples >> treeDiff [
	<gtExample>
	
	| treeA treeB |
	treeA := self tree.
	
	treeB := GtIntervalTree node: 'Murong Yong' at: (GtInterval from: 386 to: 394).
	treeB insert: 'Ruzi Ying' at: (GtInterval from: 6 to: 8).
	treeB insert: 'Bu Jiang' at: (GtInterval from: -1851 to: -1792).
	treeB insert: 'Qin Er Shi' at: (GtInterval from: -209 to: -206).
	treeB insert: 'Not in the other tree' at: (GtInterval from: 5000 to: 6000).
	
	^ treeA diff: treeB
]
