from dataclasses import dataclass
import queue
import heapq

import sys

@dataclass
class Point:
    x:   int
    y:   int
    val: int

    def __init__(self, x: int, y: int, val: int = 1000000000):
        self.x = x
        self.y = y
        self.val = val

    def __eq__(self, item):
        if isinstance(item, Point):
            return self.x == item.x and self.y == item.y
        else:
            False

    def __cmp__(self, item):
        return cmp(self.val,item.val)

def getSurrounding(currentPoint, closedPath, matLen):
    surroundingPoints = []
    if (currentPoint.x - 1) >= 0:
        newPoint = Point(currentPoint.x - 1, currentPoint.y)
        if not (newPoint in closedPath):
            surroundingPoints.append(newPoint)
    if (currentPoint.x + 1) < matLen:
        newPoint = Point(currentPoint.x + 1, currentPoint.y)
        if not (newPoint in closedPath):
            surroundingPoints.append(newPoint)
    if (currentPoint.y - 1) >= 0:
        newPoint = Point(currentPoint.x, currentPoint.y - 1)
        if not (newPoint in closedPath):
            surroundingPoints.append(newPoint)
    if (currentPoint.y + 1) < matLen:
        newPoint = Point(currentPoint.x, currentPoint.y + 1)
        if not (newPoint in closedPath):
            surroundingPoints.append(newPoint)
    return surroundingPoints

def findPointInOpenPath(openPath, x, y):
    for i in range(len(openPath)):
        fr_p, fr_x, fr_y = openPath[i]
        if fr_x == x and fr_y == y:
            return (i, fr_p)
    return None


def getSurroundingDistances(mat, currentPoint, surroundings, openPath):

    for nextPoint in surroundings:
        nextVal = mat[nextPoint.x][nextPoint.y] + currentPoint.val
        if (nextVal < nextPoint.val):
            nextPoint.val = nextVal
            openPath.append(nextPoint)

    return openPath

def findShortestPathValue(mat, currentPoint, closedPath, openPath, queue, matLen):

    while not ((currentPoint.x == len(mat) - 1) and (currentPoint.y == len(mat) - 1)):

        surroundings = getSurrounding(currentPoint, closedPath, matLen) 

        nextPoints = getSurroundingDistances(mat, currentPoint, surroundings, openPath)

        if nextPoints == []:
            currentPoint = queue.get()
        else:
            queue.put(openPath[0])
            closedPath.append(openPath[0])
            currentPoint = openPath[0]
            openPath = openPath[1:]

    return queue


def createMatrix(fileName):

    f = open(fileName)
    fileText = f.read()

    matrix = []

    for line in fileText.split('\n'):
        row = []
        for character in line:
            if character != '\n':
                row.append(int(character))
        matrix.append(row)

    return matrix

def createOpenPoints(mat):
    ret = queue.PriorityQueue()
    for rIdx, row in enumerate(mat):
        for cIdx, col in enumerate(row):
            if rIdx == 0 and rIdx == 0:
                heapq.heappush(queue, (0, Point(rIdx, cIdx, 0)))
            else:
                heapq.heappush(queue, (1000000000, Point(rIdx, cIdx, 1000000000)))
    return ret

mat = createMatrix("input.txt")
mat[0][0] = 0

q = queue.Queue()
q.put(Point(0,0))

retQueue = findShortestPathValue(mat, Point(0,0,0), [Point(0,0,0)], createOpenPoints(mat), q, len(mat))

print("WTF")

while not retQueue.empty():
    print(retQueue.get())