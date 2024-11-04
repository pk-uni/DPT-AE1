package main

import (
	"flag"
	"fmt"
	"os"
	"totient/internal/bench"
	"totient/internal/totient"
	"totient/internal/totient/parallel"
	"totient/internal/totient/sequential"
)

var (
	mode  = flag.String("mode", "sequential", "execution mode: sequential or parallel")
	lower = flag.Int64("lower", 1, "lower bound of range")
	upper = flag.Int64("upper", 1000, "upper bound of range")
	runs  = flag.Int("runs", 1, "number of runs to execute")
)

func main() {
	flag.Parse()

	var calculator totient.Calculator
	switch *mode {
	case "sequential", "seq":
		calculator = sequential.New()
	case "parallel", "par":
		calculator = parallel.New()
	default:
		fmt.Fprintf(os.Stderr, "invalid mode: %s\n", *mode)
		flag.Usage()
		os.Exit(1)
	}

	runner := bench.NewRunner(calculator)

	if *runs > 1 {
		runner.RunN(*lower, *upper, *runs)
	} else {
		runner.Run(*lower, *upper)
	}
}
