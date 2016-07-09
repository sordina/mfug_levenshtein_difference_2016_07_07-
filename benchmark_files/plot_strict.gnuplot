set size square

set ylabel "Time"
set xlabel "Size"

set term png
set output "benchmark_files/plot_strict.png"

plot "benchmark_files/bench_data_strict.txt" using 1:2 with lines
