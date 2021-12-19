extends Node2D

func myLoad():
	var file = File.new()
	file.open("res://input.txt", File.READ)
	var content = file.get_as_text()
	file.close()
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var content = myLoad()
	
	var lines = content.split("\n")
	
	var hitDictionary = {}
	var diagDictionary = {}
	
	for line in lines:
		var commands = line.split(" -> ")

		var firstPoint = commands[0].split(",")
		var secondPoint = commands[1].split(",")
		
		var firstX = int(firstPoint[0])
		var firstY = int(firstPoint[1])
		
		var secondX = int(secondPoint[0])
		var secondY = int(secondPoint[1])
		
		if (firstX == secondX):
			addPointsToDictionaryY(hitDictionary, firstY, secondY, firstX)
			addPointsToDictionaryY(diagDictionary, firstY, secondY, firstX)
			
		if (firstY == secondY):
			addPointsToDictionaryX(hitDictionary, firstX, secondX, firstY)
			addPointsToDictionaryX(diagDictionary, firstX, secondX, firstY)
			
		var diagVal = isDiagonal(firstX, firstY, secondX, secondY)
		
		if diagVal == 1:
			if firstX < secondX:
				addPointsToDictionaryDiag(diagDictionary, firstX, secondX, firstY, secondY, 1)
			else:
				addPointsToDictionaryDiag(diagDictionary, secondX, firstX, secondY, firstY, 1)
		
		if diagVal == -1:
			if firstX < secondX:
				addPointsToDictionaryDiag(diagDictionary, secondX, firstX, secondY, firstY, -1)
			else:
				addPointsToDictionaryDiag(diagDictionary, firstX, secondX, firstY, secondY, -1)
		
			
	var sum = 0
	for val in hitDictionary.values():
		if val >= 2:
			sum+=1
	
	$VBoxContainer/HBoxContainer/Day1.text = "Day 1: " + String(sum)
	
	sum = 0
	for val in diagDictionary.values():
		if val >= 2:
			sum+=1
			
	$VBoxContainer/HBoxContainer2/Day2.text = "Day 2: " + String(sum)
	
	
func addPointsToDictionaryDiag(dict, firstX, secondXD, firstY, secondY, gradientX):
	for inc in range(0, (secondY - firstY) + 1):
		addPointToDict(dict, firstX + (inc * gradientX), firstY + inc)
	
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
	
				
func orderPointsCorrectly(start, end):
	var s = start
	var e = end
	if end < start:
		s = end
		e = start
	return [s,e]
		
func addPointsToDictionaryY(hitDict, startY, endY, x):
	var actualStartAndEnd = orderPointsCorrectly(startY, endY)
	
	for y in range(actualStartAndEnd[0], actualStartAndEnd[1] + 1):
		addPointToDict(hitDict, x, y)
			
func addPointsToDictionaryX(hitDict, startX, endX, y):
	var actualStartAndEnd = orderPointsCorrectly(startX, endX)
	
	for x in range(actualStartAndEnd[0], actualStartAndEnd[1] + 1):
		addPointToDict(hitDict, x, y)
		
func addPointToDict(hitDict, x, y):
	# create point
	var newPoint = [x, y]
	
	# check for entry in dictionary
	if hitDict.has(newPoint):
		var hits = hitDict.get(newPoint) + 1
		hitDict[newPoint] = hits
	else:
		hitDict[newPoint] = 1
