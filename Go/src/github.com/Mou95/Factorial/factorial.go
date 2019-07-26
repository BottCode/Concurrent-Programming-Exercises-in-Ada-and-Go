package main

import (
	"fmt"

	"github.com/Mou95/Factorial/multiplier"
	"github.com/Mou95/Factorial/supervisor"
)

//es. n=10, k=3, return [10,7,4]
func createLists(n, k int) (slice []int) {
	for n > 1 {
		slice = append(slice, n)
		n -= k
	}
	return
}

func Factorial(n, k int) {
	//channel used to comunicate from subprocess to supervisor
	subproduct := make(chan int, 10)

	//channel used from supervisor to comunicate result to main
	result := make(chan int)

	//channel used from multiplier to comunicate failure
	fail := make(chan []int, k)

	//Create the supervisor
	s := supervisor.New(k, subproduct, result)
	go s.Run()

	//create k multiplier
	for i := 0; i < k; i++ {
		numbers := createLists(n-i, k)
		m := multiplier.New(numbers, subproduct, fail)
		go m.Run()
	}

	for {
		select {
		//if result is returned, print it
		case v := <-result:
			fmt.Printf("Il fattoriale di %d è %d\n", n, v)
			return
		//if a process fail, create another one with the same list of numbers to be multiplied
		case list := <-fail:
			m := multiplier.New(list, subproduct, fail)
			go m.Run()
		}
	}

}

func main() {
	Factorial(10, 5)
}
