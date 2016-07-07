set size square

set ylabel "Time"
set xlabel "Size"

set term png
set output "plot_strict.png"

plot "bench_data_strict.txt" using 1:2 with lines
