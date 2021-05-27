Class {
	#name : #IntervalTreeNode,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'interval',
		'value',
		'high',
		'parent'
	],
	#category : #'DataStructures-IntervalTree'
}

{ #category : #'instance creation' }
IntervalTreeNode class >> interval: anIntervalTreeInterval [
	^ self new
		interval: anIntervalTreeInterval
]

{ #category : #'instance creation' }
IntervalTreeNode class >> interval: anInterval value: anObject [ 
	^ self new
		value: anObject;
		interval: anInterval
]

{ #category : #comparing }
IntervalTreeNode >> = anObject [
	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].

	self hasRight = anObject hasRight
		ifFalse: [ ^ false ].

	(self hasRight and: [ self right ~= anObject right ])
		ifTrue: [ ^ false ].
		
	self hasLeft = anObject hasLeft
		ifFalse: [ ^ false ].
		
	(self hasLeft and: [ self left ~= anObject left ])
		ifTrue: [ ^ false ].
		
	self high = anObject high
		ifFalse: [ ^ false ].
		
	self selection = anObject selection
		ifFalse: [ ^ false ].

	^ true
]

{ #category : #accessing }
IntervalTreeNode >> children [
	"Return a collection of children selection nodes"
	<return: #Array of: #IntervalTreeNode>
	
	^ Array streamContents: [ :aStream |
		self hasLeft
			ifTrue: [ aStream nextPut: self left ].
		self hasRight
			ifTrue: [ aStream nextPut: self right ] ]
]

{ #category : #'tree - testing' }
IntervalTreeNode >> contains: anIndex [
	"Return true if this selection interval includes a given index, false otherwise"
	<return: #Boolean>

	anIndex > self high
		ifTrue: [ ^ false ].
		
	(self selection contains: anIndex)
		ifTrue: [ ^ true ].
		
	(self hasLeft and: [ anIndex <= self left high ])
		ifTrue: [ ^ self left contains: anIndex ].
		
	(self hasRight and: [ anIndex <= self right high ])
		ifTrue: [ ^ self right contains: anIndex ].
		
	^ false
]

{ #category : #'tree - testing' }
IntervalTreeNode >> containsIndex: anIndex [
	"Return true if this selection interval includes a given index, false otherwise"
	<return: #Boolean>

	anIndex > self high
		ifTrue: [ ^ false ].
		
	(self selection containsIndex: anIndex)
		ifTrue: [ ^ true ].
		
	(self hasLeft and: [ anIndex <= self left high ])
		ifTrue: [ ^ self left containsIndex: anIndex ].
		
	(self hasRight and: [ anIndex <= self right high ])
		ifTrue: [ ^ self right containsIndex: anIndex ].
		
	^ false
]

{ #category : #'instance creation' }
IntervalTreeNode >> createNode: aSelection [
	^ (self class selection: aSelection)
		parent: self;
		yourself
]

{ #category : #'tree - deletion' }
IntervalTreeNode >> delete [
	"Delete me from the tree"

	(self hasLeft and: [ self hasRight ])
		ifTrue: [ 
			| successorNode |
			successorNode := self right findMin.
			value := successorNode value.
			successorNode delete ]
		ifFalse: [ 
			self hasLeft
				ifTrue: [ self replaceInParent: self left ]
				ifFalse: [ self hasRight
					ifTrue: [ self replaceInParent: self right ]
					ifFalse: [ self deleteInParent ] ] ]
]

{ #category : #'tree - deletion' }
IntervalTreeNode >> deleteInParent [
	"Delete me from the parent"
	self
		assert: [ self hasLeft not and: [ self hasRight not ] ]
		description: [ 'I can not be deleted from the parent if I have children' ].
	
	(self hasParent and: [ self parent isRoot not ])
		ifTrue: [			
			(self parent hasLeft and: [ self parent left == self ])
				ifTrue: [ self parent removeLeft ].
			(self parent hasRight and: [ self parent right == self ])
				ifTrue: [ self parent removeRight ] ].
	
	(self hasParent and: [ self parent isRoot ])
		ifTrue: [ self parent removeRoot ].
	
	"I am deleted and don't have a parent anymore"
	parent := nil
]

{ #category : #'tree - enumerating' }
IntervalTreeNode >> do: aBlock [
	self hasLeft
		ifTrue: [ self left do: aBlock ].
		
	aBlock value: self selection.
	
	self hasRight
		ifTrue: [ self right do: aBlock ]
]

{ #category : #'tree - searching' }
IntervalTreeNode >> findMax [
	"Return a minimum node in a subtree"
	<return: #IntervalTreeNode>
	| aCurrentNode |
	
	aCurrentNode := self.
	[ aCurrentNode hasRight ]
		whileTrue: [ aCurrentNode := aCurrentNode right ].
	^ aCurrentNode
]

{ #category : #'tree - searching' }
IntervalTreeNode >> findMin [
	"Return a minimum node in a subtree"
	<return: #IntervalTreeNode>
	| aCurrentNode |
	
	aCurrentNode := self.
	[ aCurrentNode hasLeft ]
		whileTrue: [ aCurrentNode := aCurrentNode left ].
	^ aCurrentNode
]

{ #category : #'tree - testing' }
IntervalTreeNode >> hasLeft [
	^ left isNotNil
]

{ #category : #'tree - testing' }
IntervalTreeNode >> hasParent [
	^ parent isNotNil
]

{ #category : #'tree - testing' }
IntervalTreeNode >> hasRight [
	^ right isNotNil
]

{ #category : #accessing }
IntervalTreeNode >> high [
	^ high
]

{ #category : #'tree - inserting' }
IntervalTreeNode >> insert: aMonotoneTextSelection [

	aMonotoneTextSelection < self selection
		ifTrue: [
			left
				ifNil: [ left := self createNode: aMonotoneTextSelection ]
				ifNotNil: [ left insert: aMonotoneTextSelection ] ]
		ifFalse: [ 
			right
				ifNil: [ right := self createNode: aMonotoneTextSelection ]
				ifNotNil: [ right insert: aMonotoneTextSelection ] ].
	high := high max: ((left ifNil: [ 0 ] ifNotNil: #high) max: (right ifNil: [ 0 ] ifNotNil: #high))
]

{ #category : #accessing }
IntervalTreeNode >> interval [
	<return: #IntervalTreeInterval>

	^ interval
]

{ #category : #initialization }
IntervalTreeNode >> interval: anIntervalTreeInterval [
	interval := anIntervalTreeInterval.
	high := interval last
]

{ #category : #'tree - testing' }
IntervalTreeNode >> isRoot [
	^ false
]

{ #category : #accessing }
IntervalTreeNode >> left [
	self
		assert: [ left isNotNil ]
		description: [ 'You can not access `left` if it does not exist. Check #hasLeft first!' ].
	
	^ left
]

{ #category : #accessing }
IntervalTreeNode >> left: aTextSelectionNode [
	self
		assert: [ aTextSelectionNode isNotNil ]
		description: [ 'aTextSelectionNode must not be nil' ].
	
	left := aTextSelectionNode
]

{ #category : #'tree - testing' }
IntervalTreeNode >> neighboursInterval: anInterval [
	^ self interval neighboursInterval: anInterval
]

{ #category : #'tree - searching' }
IntervalTreeNode >> overlapping: aMonotoneTextSelection in: aStream [
	
	(left isNotNil and: [ aMonotoneTextSelection from <= left high ])
		ifTrue: [ left overlapping: aMonotoneTextSelection in: aStream ].

	(self selection overlaps: aMonotoneTextSelection)
		ifTrue: [ aStream nextPut: self ].

	(right isNotNil and: [ aMonotoneTextSelection from <= right high ])
		ifTrue: [ right overlapping: aMonotoneTextSelection in: aStream ]
]

{ #category : #'tree - searching' }
IntervalTreeNode >> overlappingNeighbours: anIntervalTreeInterval in: aStream [
	(left isNotNil and: [ anIntervalTreeInterval first <= (left high + 1) ])
		ifTrue: [ left overlappingNeighbours: anIntervalTreeInterval in: aStream ].

	((self overlapsInterval: anIntervalTreeInterval) or: [ self interval neighbours: anIntervalTreeInterval ])
		ifTrue: [ aStream nextPut: self ].

	(right isNotNil and: [ anIntervalTreeInterval last <= (right high + 1) ])
		ifTrue: [ right overlappingNeighbours: anIntervalTreeInterval in: aStream ]
]

{ #category : #'tree - testing' }
IntervalTreeNode >> overlapsInterval: anInterval [
	^ self interval overlapsInterval: anInterval
]

{ #category : #accessing }
IntervalTreeNode >> parent [
	self
		assert: [ parent isNotNil ]
		description: [ 'You can not access `parent` if it does not exist. Check #hasParent first!' ].
		
	^ parent
]

{ #category : #accessing }
IntervalTreeNode >> parent: aBlSelectionNode [
	parent := aBlSelectionNode
]

{ #category : #copying }
IntervalTreeNode >> postCopy [
	right := right copy.
	right ifNotNil: [ right parent: self ].
	
	left := left copy.
	left ifNotNil: [ left parent: self ].
	
	high := high copy.
	interval := interval copy
]

{ #category : #printing }
IntervalTreeNode >> printOn: aStream [

	self hasLeft ifTrue: [ self left printOn: aStream ].
	self interval printOn: aStream.
	self hasRight ifTrue: [ self right printOn: aStream ].
]

{ #category : #'tree - deletion' }
IntervalTreeNode >> removeLeft [
	left := nil
]

{ #category : #'tree - deletion' }
IntervalTreeNode >> removeRight [
	right := nil
]

{ #category : #'tree - deletion' }
IntervalTreeNode >> replaceInParent: aTextSelectionNode [
	"Replace me in a parent with a given node"
	
	self
		assert: [ aTextSelectionNode isNotNil ]
		description: [ 'aTextSelectionNode must not be nil!' ].
	
	(self hasParent and: [ self parent isRoot not ])
		ifTrue: [			
			(self parent hasLeft and: [ self parent left == self ])
				ifTrue: [ self parent left: aTextSelectionNode ].
			(self parent hasRight and: [ self parent right == self ])
				ifTrue: [ self parent right: aTextSelectionNode ] ].
	
	(self hasParent and: [ self parent isRoot ])
		ifTrue: [ self parent root: aTextSelectionNode ].
	
	aTextSelectionNode parent: self parent.
	"I am replaced and don't have a parent anymore"
	parent := nil
]

{ #category : #'tree - enumerating' }
IntervalTreeNode >> reverseDo: aBlock [

	self hasRight
		ifTrue: [ self right reverseDo: aBlock ].
	
	aBlock value: self selection.
	
	self hasLeft
		ifTrue: [ self left reverseDo: aBlock ]
]

{ #category : #accessing }
IntervalTreeNode >> right [
	self
		assert: [ right isNotNil ]
		description: [ 'You can not access `right` if it does not exist. Check #hasRight first!' ].
	
	^ right
]

{ #category : #accessing }
IntervalTreeNode >> right: aTextSelectionNode [
	self
		assert: [ aTextSelectionNode isNotNil ]
		description: [ 'aTextSelectionNode must not be nil' ].
	
	right := aTextSelectionNode
]

{ #category : #accessing }
IntervalTreeNode >> value [
	<return: #Object>

	^ value
]

{ #category : #initialization }
IntervalTreeNode >> value: anObject [
	value := anObject
]
