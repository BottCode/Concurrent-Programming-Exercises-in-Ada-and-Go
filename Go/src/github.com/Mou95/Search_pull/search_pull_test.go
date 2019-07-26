package main

import (
	"testing"
)

func benchmarkSearch(s string, w int, b *testing.B) {
	for n := 0; n < b.N; n++ {
		Search(s, w)
	}
}

func BenchmarkSearch1(b *testing.B)  { benchmarkSearch("dffbbgb", 1, b) }
func BenchmarkSearch6(b *testing.B)  { benchmarkSearch("dffbbgb", 6, b) }
func BenchmarkSearch12(b *testing.B) { benchmarkSearch("dffbbgb", 12, b) }
func BenchmarkSearch24(b *testing.B) { benchmarkSearch("dffbbgb", 24, b) }
