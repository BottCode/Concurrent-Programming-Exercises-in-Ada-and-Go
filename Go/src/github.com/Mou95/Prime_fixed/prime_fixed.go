package main

import (
	"fmt"

	"github.com/Mou95/Prime_fixed/generator"
	"github.com/Mou95/Prime_fixed/worker"
)

//create chain of k workers
func createWorker(n, k int, g *generator.Generator, main chan int) []worker.Worker {
	workers := []worker.Worker{}
	//first worker
	p_1 := worker.New([]int{2}, make(chan int, n/k), main, make(chan worker.Message), make(chan worker.Message), g.All, false)
	p_1.Generator = g.P1
	workers = append(workers, *p_1)

	for i := 1; i < k; i++ {
		if i == k-1 {
			workers = append(workers, *worker.New([]int{}, make(chan int, n/k), main, workers[i-1].Send, workers[0].Receive, g.All, true))
		} else {
			workers = append(workers, *worker.New([]int{}, make(chan int, n/k), main, workers[i-1].Send, make(chan worker.Message), g.All, false))
		}
	}

	workers[0].Receive = workers[k-1].Send

	return workers
}

func Prime(n, k int) {
	//channel to comunicate between p1 and generator
	ch := make(chan int)

	//channel to comunicate between workers and main
	main := make(chan int)

	//create Generator
	g := generator.New(ch, k)

	workers := createWorker(n, k, g, main)

	for i, _ := range workers {
		go workers[i].Run()
	}

	go g.Run()

	for i := 1; i < n; i++ {
		value := <-main
		fmt.Printf("Primo numero %d: %d\n", i+1, value)
		workers[i%k].New_primes <- value
	}

}

func main() {
	n := 50000
	k := 32
	Prime(n, k)
}
