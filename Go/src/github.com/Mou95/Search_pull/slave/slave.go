package slave

import (
	"fmt"
	"github.com/Mou95/Search_pull/reader"
)

type Slave struct {
	words   string
	request chan<- (chan reader.Message)
	message chan reader.Message
}

func New(words string, request chan (chan reader.Message)) *Slave {
	return &Slave{words, request, make(chan reader.Message)}
}

func (s *Slave) Run() {
	for {
		s.request <- s.message
		m := <-s.message

		for index, val := range m.Message {
			if val == s.words {
				fmt.Printf("File %s, posizione %d\n", m.File_name, (200*m.File_part)+index+1)
			}
		}
	}

}
