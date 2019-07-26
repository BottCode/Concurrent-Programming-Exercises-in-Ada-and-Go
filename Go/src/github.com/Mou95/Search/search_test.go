package main

import (
	"testing"
)

func benchmarkSearch(b *testing.B) {
	for n := 0; n < b.N; n++ {
		Search("dffbbgb")
	}
}

func BenchmarkSearch1(b *testing.B) { benchmarkSearch(b) }
