package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type Vector struct {
	X, Y int
}

type Pair struct {
	Dir string
	Val int
}

func (v Vector) reflectX(xLine int) Vector {
	if v.X > xLine {
		return Vector{X: xLine - (v.X - xLine), Y: v.Y}
	} else {
		return v
	}
}

func (v Vector) reflectY(yLine int) Vector {
	if v.Y > yLine {
		return Vector{X: v.X, Y: yLine - (v.Y - yLine)}
	} else {
		return v
	}
}

func (v Vector) reflect(line int, direction string) Vector {
	if direction == "x" {
		return v.reflectX(line)
	} else {
		return v.reflectY(line)
	}
}

func main() {

	dat, err := os.ReadFile("input.txt")
	check(err)

	lines := strings.Split(string(dat), "\r\n")

	pointsDefFinished := false
	folds := make([]Pair, 0)

	vectors := make([]Vector, 0)

	for _, s := range lines {
		if s == "" {
			pointsDefFinished = true
		} else if !pointsDefFinished {
			lineParts := strings.Split(string(s), ",")
			nextX, errX := strconv.Atoi(lineParts[0])
			check(errX)
			nextY, errY := strconv.Atoi(lineParts[1])
			check(errY)
			vectors = append(vectors, Vector{X: nextX, Y: nextY})
		} else {
			foldInputs := strings.Split(strings.Split(string(s), " ")[2], "=")
			val, errVal := strconv.Atoi(foldInputs[1])
			check(errVal)
			folds = append(folds, Pair{Dir: foldInputs[0], Val: val})
		}
	}

	partOneSet := make(map[Vector]int)
	for _, vec := range vectors {
		reflectedVec := vec
		reflectedVec = reflectedVec.reflect(folds[0].Val, folds[0].Dir)
		if _, ok := partOneSet[reflectedVec]; ok {

		} else {
			partOneSet[reflectedVec] = 1
		}
	}
	fmt.Println("Part One Answer")
	fmt.Println(len(partOneSet))

	set := make(map[Vector]int)
	for _, vec := range vectors {
		reflectedVec := vec
		for _, foldVal := range folds {
			reflectedVec = reflectedVec.reflect(foldVal.Val, foldVal.Dir)
		}
		if _, ok := set[reflectedVec]; ok {

		} else {
			set[reflectedVec] = 1
		}
	}

	// draw it i guess
	fmt.Println("Part Two Answer")
	for y := 0; y < 6; y++ {
		for x := 0; x < 39; x++ {
			if _, ok := set[Vector{X: x, Y: y}]; ok {
				fmt.Print("██")
			} else {
				fmt.Print("  ")
			}
		}
		fmt.Println("")
	}

}
