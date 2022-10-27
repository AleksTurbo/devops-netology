package main

import "fmt"

func Convert(m float64) (f float64) {
	f = m * 3.281
	return
}

func main() {
	fmt.Print("Enter a length in m: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := Convert(input)

	fmt.Printf("length in: %v feet\n", output)
}
