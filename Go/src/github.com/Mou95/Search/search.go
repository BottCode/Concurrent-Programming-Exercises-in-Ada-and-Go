package main

import (
	"io/ioutil"
	"log"
	"sync"

	"github.com/Mou95/Search/analyzer"
)

func Search(word string) {
	var wg sync.WaitGroup

	//find files to scan
	files, err := ioutil.ReadDir("./File/")
	if err != nil {
		log.Fatal(err)
		return
	}

	//number of words to process for each slave
	words_per_process := 200

	//create an analyzer for each of them
	for _, f := range files {
		wg.Add(1)
		go analyzer.New(word, f).Run(&wg, words_per_process)
	}

	wg.Wait()
}

func main() {
	word := "dffbbgb"
	Search(word)
}
