extends Node2D

func myLoad():
	var file = File.new()
	file.open("res://input.txt", File.READ)
	var content = file.get_as_text()
	file.close()
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	var content = myLoad();
	
	var lines = content.split("\n")
	
	var hitDictionary = {}
	
	for line in lines:
		var commands = line.split(" -> ");
		var firstPoint = commands[0].split(",");
		var secondPoint = commands[1].split(",");
		
		var firstX = int(firstPoint[0])
		var firstY = int(firstPoint[1])
		
		var secondX = int(secondPoint[0])
		var secondY = int(secondPoint[1])
		
		# if x == x, do y line
		if (firstX == secondX):
			addPointsTodDictionaryY(hitDictionary, firstY, secondY, firstX)
		
		# if y == y, do x line
		if (firstY == secondY):
			addPointsTodDictionaryX(hitDictionary, firstX, secondX, firstY)
		
		var diagVal = isDiagonal(firstX, firstY, secondX, secondY)
		
		# check if they are diagonal negative
		if diagVal == 1:
			if firstX < secondX:
				addPointsTodDictionaryDiag(hitDictionary, firstX, secondX, firstY, secondY, 1, 1)
			else:
				addPointsTodDictionaryDiag(hitDictionary, secondX, firstX, secondY, firstY, 1, 1)
		
		# check if they are diagonal positive
		if diagVal == -1:
			if secondX > firstX:
				addPointsTodDictionaryDiag(hitDictionary, secondX, firstX, secondY, firstY, -1, 1)
			else:
				addPointsTodDictionaryDiag(hitDictionary, firstX, secondX, firstY, secondY, -1, 1)

	# now go through dict and get all entries with value 2 and over
	var sum = 0
	for val in hitDictionary.values():
		if val >= 2:
			sum+=1
			
	print("Result: " + String(sum))	

func addPointsTodDictionaryDiag(dictionary, firstX, secondX, firstY, secondY, gradientX, gradientY):
	
	for inc in range(0, (secondY - firstY) + 1):
		addPointToDict(dictionary, firstX + (inc * gradientX), firstY + (inc * gradientY))

func isDiagonal(firstX, firstY, secondX, secondY):
	var xDiff = secondX - firstX
	var yDiff = secondY - firstY
	if xDiff == yDiff:
		# intersects x axis negative 45 degrees
		return 1
	elif xDiff == -yDiff:
		# intersects x axis positive 45 degrees
		return -1
	return 0

func addPointsTodDictionaryY(dictionary, startY, endY, x):
	
	var s = startY
	var e = endY
	if endY < startY:
		s = endY
		e = startY
	
	for y in range(s, e + 1):
		addPointToDict(dictionary, x, y)

func addPointsTodDictionaryX(dictionary, startX, endX, y):
	
	var s = startX
	var e = endX
	if endX < startX:
		s = endX
		e = startX
		
	for x in range(s, e + 1):
		addPointToDict(dictionary, x, y)
		
func addPointToDict(dict, x, y):
	# create point
	var newPoint = [x, y]
	
	# check for entry in dictionary
	if dict.has(newPoint):
		var hits = dict.get(newPoint) + 1
		dict[newPoint] = hits
	else:
		dict[newPoint] = 1
		
	
	
