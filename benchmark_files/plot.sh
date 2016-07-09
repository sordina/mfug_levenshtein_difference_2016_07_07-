#!/bin/bash

grep strict- benchmark_files/benchmark.csv | sed 's/.*--//' | awk -F , '{print $1,$2}' > benchmark_files/bench_data_strict.txt
grep lazy-   benchmark_files/benchmark.csv | sed 's/.*--//' | awk -F , '{print $1,$2}' > benchmark_files/bench_data_lazy.txt
grep lazy_p- benchmark_files/benchmark.csv | sed 's/.*--//' | awk -F , '{print $1,$2}' > benchmark_files/bench_data_lazy_p.txt

gnuplot < benchmark_files/plot_strict.gnuplot
gnuplot < benchmark_files/plot_lazy.gnuplot
gnuplot < benchmark_files/plot_lazy_p.gnuplot
