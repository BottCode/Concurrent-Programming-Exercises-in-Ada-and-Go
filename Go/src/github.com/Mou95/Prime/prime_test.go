package main

import (
	"testing"
)

func benchmarkPrime(i int, b *testing.B) {
	for n := 0; n < b.N; n++ {
		Prime(i)
	}
}

func BenchmarkPrime100(b *testing.B)   { benchmarkPrime(100, b) }
func BenchmarkPrime1000(b *testing.B)  { benchmarkPrime(1000, b) }
func BenchmarkPrime10000(b *testing.B) { benchmarkPrime(10000, b) }
func BenchmarkPrime50000(b *testing.B) { benchmarkPrime(50000, b) }
