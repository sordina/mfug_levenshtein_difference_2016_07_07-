set size square

set ylabel "Time"
set xlabel "Size"

set term png
set output "plot_lazy_p.png"

plot "bench_output_lazy_p.txt" using 1:2 with lines
