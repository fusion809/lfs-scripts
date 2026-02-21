set terminal png size 1920,1080 font "Liberation Sans,30"
set output "boots_hist.png"

set title "Linux From Scratch boot time distribution"
set xlabel "Boot time (seconds)"
set lmargin 13
set ylabel "Frequency" rotate by 0 offset -1,0

set style fill solid 0.8
set boxwidth 0.5

binwidth = 0.5
bin(x,width) = width*floor(x/width)

# Get data stats
stats "boots.dat" nooutput

# Add padding (adjust multipliers if desired)
xmin = STATS_min - binwidth
xmax = STATS_max + binwidth

# Estimate max frequency for y padding
set table $hist
plot "boots.dat" using (bin($1,binwidth)):(1.0) smooth freq
unset table

stats $hist using 2 nooutput
ymax = STATS_max * 1.2   # 20% vertical padding

set xrange [xmin:xmax]
set yrange [0:ymax]

plot "boots.dat" using (bin($1,binwidth)):(1.0) \
     smooth freq with boxes notitle
