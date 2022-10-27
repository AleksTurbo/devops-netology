package main

import "testing"

func TestMain(err *testing.T) {
	var tst float64
	tst = Convert(1)
	if tst != 3.281 {
		err.Error("Expected 3.281 ", tst)
	}
}
