#!/bin/bash

export STRING_SIZES="[100,150,200,250,300,350,400,450,500]"

stack exec -- runhaskell -isrc test/Spec.hs --csv benchmark_files/benchmark.csv --time-limit 2

./benchmark_files/parse.csv
