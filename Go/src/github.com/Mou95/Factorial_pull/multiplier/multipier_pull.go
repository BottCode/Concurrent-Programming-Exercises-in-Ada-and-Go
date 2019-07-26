package multiplier

import (
	"math/rand"
)

type Multiplier struct {
	list        []int
	new_numbers chan []int //channel to receive new numbers
	supervisor  chan<- int
	request     chan (chan []int)
	fail        chan<- []int
}

func New(supervisor chan<- int, request chan (chan []int), fail chan<- []int) *Multiplier {
	return &Multiplier{[]int{}, make(chan []int), supervisor, request, fail} //create new multiplier
}

func (m *Multiplier) Run() {
	for {
		//new request to main
		m.request <- m.new_numbers

		//receive new list from main
		m.list = <-m.new_numbers

		var counter int = 1
		//process has 40% probability of failing
		prob := rand.Float32()
		if prob > 0.4 {
			//multiply all the numbers in the list
			for _, val := range m.list {
				counter = counter * val
			}
			//send result to supervisor
			m.supervisor <- counter

		} else {
			//process fails
			m.fail <- m.list
			return
		}
	}
}
