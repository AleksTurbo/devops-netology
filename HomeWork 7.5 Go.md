# Домашнее задание к занятию "7.5. Основы golang"

## Задача 1 - Установите golang

Выполнено

```ps
PS C:\gopath> go version
go version go1.19.2 windows/amd64
```

## Задача 2 - Знакомство с gotour

Выполнено

## Задача 3 - Написание кода

1. Программа для перевода метров в футы (1 фут = 0.3048 метр)

```go
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
```

```ps
PS C:\gopath\1> go run MtoF.go
Enter a length in m: 1
length in: 3.281 feet
```

2. Программа, которая найдет наименьший элемент в списке {48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 19, 17}

```go
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
```

```ps
PS C:\gopath\2> go run FindMIN.go
The minimum is: 17
```

3. Програма, которая выводит числа от 1 до 100, которые делятся на 3

```go
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
```

```ps
PS C:\gopath\3> go run DividedByThree.go
Numbers from 1 to 100, which are divisible by 3: [3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99]
```

## Задача 4 - Тестирование кода

1. MtoF_test.go

```go
package main

import "testing"

func TestMain(err *testing.T) {
 var tst float64
 tst = Convert(1)
 if tst != 3.281 {
  err.Error("Expected 3.281 ", tst)
 }
}
```

```go
PS C:\gopath\1> go test MtoF.go MtoF_test.go
ok      command-line-arguments  0.300s
```

2. FindMIN_test.go

```go

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
```

```go
PS C:\gopath\2> go test FindMIN.go FindMIN_test.go
ok      command-line-arguments  0.312s
```

3. DividedByThree_test.go

```go
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
```

```go
PS C:\gopath\3> go test DividedByThree.go DividedByThree_test.go
ok      command-line-arguments  0.277s
```

*****************
[Go file dir:](https://github.com/AleksTurbo/devops-netology/tree/main/golang)