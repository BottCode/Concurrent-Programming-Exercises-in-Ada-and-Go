package slave

import (
	"fmt"
	"sync"
)

type Slave struct {
	word      string
	text      []string
	part      int
	file_name string
}

func New(word string, text []string, part int, file_name string) *Slave {
	return &Slave{word, text, part, file_name}
}

func (s *Slave) Run(wg *sync.WaitGroup) {
	defer wg.Done()

	for index, val := range s.text {
		if val == s.word {
			fmt.Printf("File %s, posizione %d\n", s.file_name, (200*s.part)+index+1)
		}
	}

}
