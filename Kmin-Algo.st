	| distanceLambda averageLambda points doc max min rand k groups grouptmp |
	
	"To launch this code you can do CMD-A then CMD-I to inspect the result or CMD-P to print the result."
	
	"Name of the file"
	doc := 'square1.data'.	
	"Number of clusters"
	k := 4.	
	"Random generator"
	rand := Random seed: 4.
	
	doc := FileSystem workingDirectory / doc.
	
	"We get all the lines of the file and we remove the ones beginning by a @ or the empty ones."
	points := (String lf split: doc contents) reject: [ :e | (e beginsWith: '@') or: [ e isEmpty ] ].
	
	"We transforme the strings into points."
	points := points
		collect: [ :str | 
			| coord |
			coord := $, split: str.
			coord first asNumber @ coord second asNumber ].
		
	max := (points collect: #x) max @ (points collect: #y) max.
	min := (points collect: #x) min @ (points collect: #y) min.
	
	" We define lambda for the distances and the averages."
	distanceLambda := [ :dist :dist2 | (((dist x - dist2 x) / (max x - min x)) squared + ((dist y - dist2 y) / (max y - min y)) squared) sqrt ].
	averageLambda := [ :aCollectionOfPoints | 
	| xs ys |
	xs := aCollectionOfPoints collect: #x.
	ys := aCollectionOfPoints collect: #y.
	(xs sum / xs size) @ (ys sum / ys size) ].

	grouptmp := OrderedDictionary new.
	"We generate k different points."
	1 to: k do: [ :ind | grouptmp at: ((min x to: max x) atRandom: rand) @ ((min y to: max y) atRandom: rand) put: OrderedCollection new ].
	
	[ 
	groups := grouptmp copy.
	
	"We iterate on the points and add the points to the right centers."
	points
		do: [ :point | 
			| minD |
			"We set an initial value that will be remove by the first min."
			minD := 1.1 -> nil.
			groups keysDo: [ :key | minD := minD min: (distanceLambda value: key value: point) -> key ].
			(groups at: minD value) add: point ].
		
	groups values
		detect: [ :e | e isEmpty ]
		ifFound: [ ^ 'Un des centre n''as pas de point proche :( Vous pouvez essayer une autre graine ou tester sur plus de points.' ].
	
	grouptmp := OrderedDictionary new.
	
	"Get the new centers"
	groups valuesDo: [ :values | grouptmp at: (averageLambda value: values) put: OrderedCollection new ].
	groups keys = grouptmp keys ] whileFalse.

	groups keys