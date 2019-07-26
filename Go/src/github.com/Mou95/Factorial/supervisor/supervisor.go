package supervisor

type Supervisor struct {
	k          int
	subproduct <-chan int
	response   chan<- int
	product    int
}

func New(k int, sub chan int, response chan int) *Supervisor {
	return &Supervisor{k, sub, response, 1}
}

func (s *Supervisor) Run() {
	for i := 0; i < s.k; i++ {
		//wait for a new partial value
		n := <-s.subproduct
		//increment result
		s.product = s.product * n
	}

	s.response <- s.product //send final result

}
