package reader

import (
	"bufio"
	"os"
)

type Message struct {
	File_name string
	Message   []string
	File_part int
	Eof       bool
}

type Reader struct {
	buffer         chan<- Message
	files          []os.FileInfo
	word_per_slice int
}

func New(buffer chan<- Message, files []os.FileInfo, words_per_slice int) *Reader {
	return &Reader{buffer, files, words_per_slice}
}

func (r *Reader) Run() {
	for _, f := range r.files {
		file, _ := os.Open("./File/" + f.Name())
		defer file.Close()

		scanner := bufio.NewScanner(file)
		scanner.Split(bufio.ScanWords)

		eof := false
		for part := 0; !eof; part++ {
			var words []string
			for i := 0; i < r.word_per_slice; i++ {
				if scanner.Scan() {
					words = append(words, scanner.Text())
				} else {
					eof = true
					break
				}
			}
			r.buffer <- Message{f.Name(), words, part, false}
		}
	}

	r.buffer <- Message{"", []string{}, 0, true}

}
