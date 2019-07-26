package main

import (
	"testing"
)

func benchmarkFactorial(i int, k int, b *testing.B) {
	for n := 0; n < b.N; n++ {
		Factorial(i, k)
	}
}

func BenchmarkFactorial1(b *testing.B) { benchmarkFactorial(20, 1, b) }
func BenchmarkFactorial2(b *testing.B) { benchmarkFactorial(20, 2, b) }
func BenchmarkFactorial5(b *testing.B) { benchmarkFactorial(20, 5, b) }
