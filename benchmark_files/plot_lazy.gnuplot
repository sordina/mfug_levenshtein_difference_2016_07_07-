set size square

set ylabel "Time"
set xlabel "Size"

set term png
set output "plot_lazy.png"

plot "bench_data_lazy.txt" using 1:2 with lines
