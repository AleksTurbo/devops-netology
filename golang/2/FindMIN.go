package main

import (
	"fmt"
	"sort"
)

func FindMin(SortList []int) (minimum int) {
	sort.Ints(SortList)
	minimum = SortList[0]
	return
}

func main() {
	n := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 19, 17}
	m := FindMin(n)
	fmt.Printf("The minimum is: %v\n", m)
}
