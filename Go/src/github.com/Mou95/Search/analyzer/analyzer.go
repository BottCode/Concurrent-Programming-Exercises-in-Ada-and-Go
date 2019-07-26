package analyzer

import (
	"bufio"
	"os"
	"sync"

	"github.com/Mou95/Search/slave"
)

type Analyzer struct {
	word string
	f    os.FileInfo
}

func New(word string, f os.FileInfo) *Analyzer {
	return &Analyzer{word, f}
}

func (a *Analyzer) Run(wmain *sync.WaitGroup, nwords int) {
	defer wmain.Done()
	var wg sync.WaitGroup

	file, _ := os.Open("./File/" + a.f.Name())
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanWords)

	eof := false
	for part := 0; !eof; part++ {
		var words []string
		for i := 0; i < nwords; i++ {
			if scanner.Scan() {
				words = append(words, scanner.Text())
			} else {
				eof = true
				break
			}
		}
		s := slave.New(a.word, words, part, a.f.Name())
		wg.Add(1)
		go s.Run(&wg)
	}

	wg.Wait()

}
