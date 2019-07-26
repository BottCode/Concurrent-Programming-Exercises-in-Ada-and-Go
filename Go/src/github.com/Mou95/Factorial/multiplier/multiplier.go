package multiplier

import (
	"math/rand"
)

type Multiplier struct {
	numbers    []int
	supervisor chan<- int
	fail       chan<- []int
}

func New(numbers []int, supervisor chan<- int, fail chan<- []int) *Multiplier {
	return &Multiplier{numbers, supervisor, fail}
}

func (m *Multiplier) Run() {
	var counter int = 1

	//process has 40% probability of failing
	prob := rand.Float32()
	if prob > 0.4 {
		//multiply all the numbers in the list
		for _, val := range m.numbers {
			counter = counter * val
		}
		m.supervisor <- counter
	} else {
		//process fails returning list it should has multiplied
		m.fail <- m.numbers
	}
}
