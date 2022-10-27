package main

import (
	"fmt"
	"testing"
)

func TestMain(err *testing.T) {
	var tst []int
	tst = Calc()
	fmt.Printf("Result divisible by 3: %v\n", tst)
	if tst[0] != 3 || tst[32] != 99 {
		result := fmt.Sprintf("Expected values 3 and 6, got %v and %v", tst[0], tst[32])
		err.Error("Right result is 3 and 99 ", result)
	}
}
