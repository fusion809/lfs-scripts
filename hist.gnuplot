set terminal png size 1920,1080 font "Liberation Sans,30"
set output "/home/fusion809/lfs-scripts/boots_hist.png"

set title "Linux From Scratch boot time distribution"
set xlabel "Boot time (seconds)"
set lmargin 13
set ylabel "Frequency" rotate by 0 offset -2,0

set style fill solid 0.8
# Get data stats
stats "/home/fusion809/lfs-scripts/boots.dat" nooutput
binwidth = (STATS_max-STATS_min)/7
set boxwidth binwidth * 0.9
bin(x,width) = width*floor(x/width)

count  = STATS_records
mean   = STATS_mean
median = STATS_median

xmin = STATS_min - binwidth
xmax = STATS_max + binwidth

set table $hist
plot "/home/fusion809/lfs-scripts/boots.dat" using (bin($1,binwidth)):(1.0) smooth freq
unset table

stats $hist using 2 nooutput
ymax = STATS_max * 1.1

set xrange [xmin:xmax]
set yrange [0:ymax]

set label 1 sprintf("Count: %d", count) at graph 0.98,0.95 right
# Vertical lines
# Vertical lines
set arrow 1 from mean, graph 0 to mean, graph 1 nohead lw 3
set arrow 2 from median, graph 0 to median, graph 1 nohead lw 3 dt 2

# Place labels slightly below top of plot
offset=(xmax-xmin)/xmax*0.02
if (mean < median) {
    set label 2 sprintf("Mean: %.2f s", mean)   at mean-offset,   graph 0.95 right
    set label 3 sprintf("Median: %.2f s", median) at median+offset, graph 0.95 left
} else {
    set label 2 sprintf("Mean: %.2f s", mean)   at mean-offset,   graph 0.95 left
    set label 3 sprintf("Median: %.2f s", median) at median+offset, graph 0.95 right
}
plot "/home/fusion809/lfs-scripts/boots.dat" using (bin($1,binwidth)):(1.0) \
     smooth freq with boxes notitle
