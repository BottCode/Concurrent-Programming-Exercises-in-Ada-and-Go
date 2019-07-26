package worker

import (
	"math"
)

type Message struct {
	N     int
	Level int
}

type Worker struct {
	Numbers    []int        //list of primes
	New_primes chan int     //primes to be added to Numbers if needed
	Main       chan int     //comunicate new prime to main
	Receive    chan Message //receive numbers from previous worker
	Send       chan Message //send numbers to next worker
	Generator  chan int     //wait numbers from generator
	all        chan int     //comunicate to generator the discard of a number
	last       bool         //true if the worker is the last in the chain
}

func New(numbers []int, new_primes chan int, main chan int, receive chan Message, send chan Message, all chan int, last bool) *Worker {
	return &Worker{numbers, new_primes, main, receive, send, make(chan int), all, last}
}

func (w *Worker) checkNumber(mess *Message) {
	//take a prime from new_prime if list is too short
	if mess.Level == len(w.Numbers) {
		p := <-w.New_primes
		w.Numbers = append(w.Numbers, p)
	}
	//check number
	if float64(w.Numbers[mess.Level]) > math.Sqrt(float64(mess.N)) {
		//new prime number
		w.Main <- mess.N
		//send notification to generator
		w.all <- mess.N
	} else {
		if (mess.N % w.Numbers[mess.Level]) != 0 {
			if w.last {
				//send number back to p_1 and add a level
				w.Send <- Message{mess.N, mess.Level + 1}
			} else {
				//send the number to next process
				w.Send <- *mess
			}
		} else {
			//send notification to generator
			w.all <- mess.N
		}
	}

}

func (w *Worker) Run() {
	for {
		select {
		//receive message from previous worker
		case mess := <-w.Receive:
			w.checkNumber(&mess)
		//receive message from generator (only first process)
		case next := <-w.Generator:
			w.checkNumber(&Message{next, 0})
		}
	}
}
