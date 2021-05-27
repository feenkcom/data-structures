Class {
	#name : #IntervalTree,
	#superclass : #Object,
	#instVars : [
		'root'
	],
	#category : #'DataStructures-IntervalTree'
}

{ #category : #comparing }
IntervalTree >> = anObject [
	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].

	self hasRoot = anObject hasRoot
		ifFalse: [ ^ false ].
		
	^ self hasRoot
		ifTrue: [ self root = anObject root ]
		ifFalse: [ true ]
]

{ #category : #'tree - testing' }
IntervalTree >> contains: anIndex [
	"Return true if this selection interval includes a given index, false otherwise"
	<return: #Boolean>
	
	^ self hasRoot
		ifTrue: [ self root contains: anIndex ]
		ifFalse: [ false ]
]

{ #category : #'tree - testing' }
IntervalTree >> containsIndex: anIndex [
	"Return true if this selection interval includes a given index, false otherwise"
	<return: #Boolean>
	
	^ self hasRoot
		ifTrue: [ self root containsIndex: anIndex ]
		ifFalse: [ false ]
]

{ #category : #'tree - deletion' }
IntervalTree >> delete: aMonotoneTextSelection [
	| theOverlapping |
	self hasRoot
		ifFalse: [ ^ self ].
		
	theOverlapping := self findOverlapping: aMonotoneTextSelection.
	theOverlapping
		ifEmpty: [ ^ self ].
	
	theOverlapping reverseDo: #delete.
	
	theOverlapping
		collect: [ :aSelectionNode | aSelectionNode selection complement: aMonotoneTextSelection ]
		thenDo: [ :aComplementSelection | aComplementSelection
			do: [ :aSelection | aSelection isNotEmpty ifTrue: [ self insert: aSelection ] ] ]
]

{ #category : #'tree - enumerating' }
IntervalTree >> do: aBlock [
	self hasRoot
		ifTrue: [ self root do: aBlock ]
]

{ #category : #'tree - searching' }
IntervalTree >> findOverlapping: aMonotoneTextSelection [
	<return: #Collection of: #BlMonotoneSelection>
	
	^ Array streamContents: [ :aStream | self overlapping: aMonotoneTextSelection in: aStream ]
]

{ #category : #'tree - searching' }
IntervalTree >> findOverlappingNeighbours: anInterval [
	<return: #Collection of: #IntervalTreeNode>
	
	^ Array streamContents: [ :aStream | self overlappingNeighbours: anInterval in: aStream ]
]

{ #category : #accessing }
IntervalTree >> first [
	self
		assert: [ self isNotEmpty ]
		description: [ 'Selection is empty, can not get #first' ].

	^ self root findMin
]

{ #category : #'tree - testing' }
IntervalTree >> hasRoot [
	^ root isNotNil
]

{ #category : #comparing }
IntervalTree >> hash [
	^ self hasRoot
		ifTrue: [ self root hash bitXor: self class hash ]
		ifFalse: [ self class hash ]
]

{ #category : #'tree - inserting' }
IntervalTree >> insert: anIntervalTreeInterval [
	self
		insert: anIntervalTreeInterval
		value: nil
]

{ #category : #'tree - inserting' }
IntervalTree >> insert: anIntervalTreeInterval value: anObject [
	| theNeighbours newFrom newTo |
	
	anIntervalTreeInterval isEmpty
		ifTrue: [ ^ self ].
	
	self hasRoot
		ifFalse: [
			root := (IntervalTreeNode interval: anIntervalTreeInterval value: anObject)
				parent: self.
			^ self ].

	theNeighbours := self findOverlappingNeighbours: anIntervalTreeInterval.
	theNeighbours
		ifEmpty: [
			self root insert: anIntervalTreeInterval.
			^ self ].

	newFrom := theNeighbours first first min: anIntervalTreeInterval first.
	newTo := theNeighbours last last max: anIntervalTreeInterval last.
	
	theNeighbours reverseDo: #delete.

	"self hasRoot
		ifFalse: [ root := (IntervalTreeNode selection: (newFrom to: newTo)) parent: self. ^ self ].
	self root insert: (newFrom to: newTo)"
]

{ #category : #'tree - testing' }
IntervalTree >> isEmpty [
	^ self hasRoot not
]

{ #category : #'tree - testing' }
IntervalTree >> isNotEmpty [
	^ self hasRoot
]

{ #category : #'tree - testing' }
IntervalTree >> isRoot [
	^ true
]

{ #category : #accessing }
IntervalTree >> last [
	self
		assert: [ self hasRoot ]
		description: [ 'There must be root!' ].
		
	^ self root findMax
]

{ #category : #'tree - searching' }
IntervalTree >> overlapping: aMonotoneTextSelection in: aStream [
	
	self hasRoot
		ifTrue: [ self root overlapping: aMonotoneTextSelection in: aStream ]
]

{ #category : #'tree - searching' }
IntervalTree >> overlappingNeighbours: anInterval in: aStream [
	
	self hasRoot
		ifTrue: [ self root overlappingNeighbours: anInterval in: aStream ]
]

{ #category : #copying }
IntervalTree >> postCopy [
	root := root copy.
	root ifNotNil: [ root parent: self ]
]

{ #category : #printing }
IntervalTree >> printOn: aStream [

	self hasRoot
		ifTrue: [ self root printOn: aStream ]
]

{ #category : #'tree - deletion' }
IntervalTree >> removeRoot [
	root := nil
]

{ #category : #'tree - enumerating' }
IntervalTree >> reverseDo: aBlock [
	self hasRoot
		ifTrue: [ self root reverseDo: aBlock ]
]

{ #category : #accessing }
IntervalTree >> root [
	<return: #IntervalTreeNode>
	
	self
		assert: [ root isNotNil ]
		description: [ 'Root can not be nil' ].
	
	^ root
]

{ #category : #accessing }
IntervalTree >> root: aTextSelectionNode [
	root := aTextSelectionNode
]
