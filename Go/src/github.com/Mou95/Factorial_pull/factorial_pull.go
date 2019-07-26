package main

import (
	"fmt"

	"github.com/Mou95/Factorial/supervisor"
	"github.com/Mou95/Factorial_pull/multiplier"
)

//es. n=10, return [[2,10],[3,9],[4,8],[5,7],[6]]
func CreateLists(n int) [][]int {
	i := n
	y := 0
	var slice [][]int
	for i > n/2+1 {
		sl := []int{2 + y, i}
		i--
		y++
		slice = append(slice, sl)
	}
	if n%2 == 0 {
		slice = append(slice, []int{n/2 + 1})
	}
	return slice
}

func Factorial(n, k int) {
	lists := CreateLists(n)

	//channel used to comunicate from subprocess to Supervisor
	subproduct := make(chan int, 10)

	//channel used from supervisor to comunicate result to main
	result := make(chan int)

	//channel used from multiplier to comunicate failure
	fail := make(chan []int, k)

	//channel used form slaves to request numbers to main
	request := make(chan (chan []int), k)

	//Create the supervisor
	s := supervisor.New(len(lists), subproduct, result)
	go s.Run()

	//create k multiplier
	for i := 0; i < k; i++ {
		//create process only if there is a sublist
		m := multiplier.New(subproduct, request, fail)
		go m.Run()

	}

	for {
		select {
		//result from supervisor
		case v := <-result:
			fmt.Printf("Il fattoriale di %d è %d\n", n, v)
			return
		default:
			select {
			//if a process fail, create another one with the same list of numbers to be multiplied
			case list := <-fail:
				lists = append(lists, list)
				m := multiplier.New(subproduct, request, fail)
				go m.Run()

			//a multiplier is asking for a new task
			case ch := <-request:
				if len(lists) > 0 {
					numb, x := lists[len(lists)-1], lists[:len(lists)-1]
					ch <- numb
					lists = x
				}
			default:
			}
		}
	}
}

func main() {
	n := 20
	k := 5
	Factorial(n, k)
}
