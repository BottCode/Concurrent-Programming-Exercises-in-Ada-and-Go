package main

import (
	"fmt"
	"github.com/Mou95/Prime/generator"
	"github.com/Mou95/Prime/process"
)

func Prime(n int) {
	//channel to send numbers to p2
	ch := make(chan int)

	//create generator of numbers
	go generator.New(ch).Run()

	//channel to return new prime to main
	prime := make(chan int)

	//first process of chain
	p2 := process.New(2, ch, prime)

	go p2.Run()

	for i := 1; i < n; i++ {
		//waiting first n primes
		new_prime := <-prime
		fmt.Printf("Primo numero %d: %d\n", i+1, new_prime)
	}

}

func main() {
	number_of_primes := 100
	Prime(number_of_primes)
}
