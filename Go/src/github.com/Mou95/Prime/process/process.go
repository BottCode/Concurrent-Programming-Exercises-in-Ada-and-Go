package process

type Process struct {
	n       int
	last    bool
	receive <-chan int
	send    chan int
	prime   chan<- int
}

func New(n int, receive <-chan int, prime chan<- int) *Process {
	return &Process{n, true, receive, make(chan int), prime}
}

func (p *Process) Run() {
	for {
		//new number to verify
		div := <-p.receive
		if (div % p.n) != 0 {
			if p.last {
				//the number is prime so it is send back to main and a new process is created
				p.last = false
				p.prime <- div
				go New(div, p.send, p.prime).Run()
			} else {
				//send the number to next process
				p.send <- div
			}
		}
	}
}
