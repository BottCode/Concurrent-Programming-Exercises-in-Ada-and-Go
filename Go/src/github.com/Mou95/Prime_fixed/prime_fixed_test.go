package main

import (
	"testing"
)

func benchmarkPrime(i int, k int, b *testing.B) {
	for n := 0; n < b.N; n++ {
		Prime(i, k)
	}
}

func BenchmarkPrime100_4(b *testing.B)   { benchmarkPrime(100, 4, b) }
func BenchmarkPrime1000_4(b *testing.B)  { benchmarkPrime(1000, 4, b) }
func BenchmarkPrime10000_4(b *testing.B) { benchmarkPrime(10000, 4, b) }

//func BenchmarkPrime100000_4(b *testing.B)  { benchmarkPrime(100000, 4, b) }
func BenchmarkPrime100_8(b *testing.B)    { benchmarkPrime(100, 8, b) }
func BenchmarkPrime1000_8(b *testing.B)   { benchmarkPrime(1000, 8, b) }
func BenchmarkPrime10000_8(b *testing.B)  { benchmarkPrime(10000, 8, b) }
func BenchmarkPrime50000_4(b *testing.B)  { benchmarkPrime(50000, 4, b) }
func BenchmarkPrime50000_8(b *testing.B)  { benchmarkPrime(50000, 8, b) }
func BenchmarkPrime50000_16(b *testing.B) { benchmarkPrime(50000, 16, b) }
func BenchmarkPrime50000_32(b *testing.B) { benchmarkPrime(50000, 32, b) }
