package main

import (
	"io/ioutil"
	"log"

	"github.com/Mou95/Search_pull/reader"
	"github.com/Mou95/Search_pull/slave"
)

func Search(word string, k int) {
	//find files to scan
	files, err := ioutil.ReadDir("./File/")
	if err != nil {
		log.Fatal(err)
		return
	}

	words_per_slice := 200

	//buffer between reader and main
	buffer := make(chan reader.Message, 200)

	//create Reader
	r := reader.New(buffer, files, words_per_slice)

	//channel for requests from slaves
	request := make(chan (chan reader.Message), k)
	//create slave
	for i := 0; i < k; i++ {
		go slave.New(word, request).Run()
	}

	go r.Run()

	for {
		message := <-buffer
		if message.Eof {
			//all files are read, need to wait all slaves to finish their work
			for {
				if len(request) == k {
					break
				}
			}
			break
		}
		ch := <-request
		ch <- message
	}
}

func main() {
	word := "dffbbgb"
	k := 5
	Search(word, k)
}
