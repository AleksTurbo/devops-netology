package main

import (
	"fmt"
)

func Calc() (NumD3List []int) {
	for i := 1; i <= 100; i++ {
		if i%3 == 0 {
			NumD3List = append(NumD3List, i)
		}
	}
	return
}

func main() {
	NumDevThree := Calc()
	fmt.Printf("Numbers from 1 to 100, which are divisible by 3: %v\n", NumDevThree)
}
