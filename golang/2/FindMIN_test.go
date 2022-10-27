package main

import (
	"testing"
)

func TestMain(err *testing.T) {
	tst := FindMin([]int{11, 22, 33, 44})
	if tst != 11 {
		err.Error("Right result is 11 ", tst)
	}
}
