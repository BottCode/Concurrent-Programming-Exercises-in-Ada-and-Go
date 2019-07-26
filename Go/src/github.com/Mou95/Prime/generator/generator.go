package generator

type Generator struct {
	p2 chan<- int
}

func New(p2 chan<- int) *Generator {
	return &Generator{p2}
}

func (g *Generator) Run() {
	n := 3
	for {
		g.p2 <- n
		n++
	}
}
