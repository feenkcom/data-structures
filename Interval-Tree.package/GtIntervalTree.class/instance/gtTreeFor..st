accessing
gtTreeFor: aView
	<gtView>
	
	^ aView columnedTree
		  title: 'Tree';
		  priority: 1;
		  items: [ 
			  self gtChildren ];
		  children: [ :eachItem | eachItem gtChildren ];
		  column: 'Value' text: [ :eachItem | eachItem value ];
		  column: 'Interval' text: [ :eachItem | eachItem interval intervalString ]