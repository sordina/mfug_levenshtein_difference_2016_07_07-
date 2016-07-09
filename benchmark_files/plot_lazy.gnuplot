set size square

set ylabel "Time"
set xlabel "Size"

set term png
set output "benchmark_files/plot_lazy.png"

plot "benchmark_files/bench_data_lazy.txt" using 1:2 with lines
