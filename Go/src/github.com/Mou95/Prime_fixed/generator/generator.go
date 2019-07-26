package generator

type Generator struct {
	P1          chan int
	num_process int
	All         chan int
}

func New(p2 chan int, k int) *Generator {
	return &Generator{p2, k, make(chan int, k-1)}
}

//There should be max num_process-1 numbers in chain to avoid deadlock
func (g *Generator) Run() {
	counter := g.num_process - 1
	n := 3
	for {
		//create new number
		for counter > 0 {
			g.P1 <- n
			n++
			counter--
		}
		//wait that a worker discard a number (find it prime or not)
		<-g.All
		counter++
	}

}
