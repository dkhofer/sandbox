package main

import (
	"fmt"

	"github.com/cznic/mathutil"
)

const squareSize = 10

func main() {
	var paths int64
	for i := uint64(0); i < uint64(1<<(squareSize*2)); i++ {
		bitCount := mathutil.PopCountUint64(i)
		if bitCount == squareSize {
			paths++
		}
	}

	fmt.Println(paths)
}
