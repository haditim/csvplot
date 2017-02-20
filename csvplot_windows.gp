# This GNUplot code plots all the .csv files in the folder together
# Normalization to maximum values and integral value is also done and a summary file will be plotted
# Code by M.Hadi Timachi
# Started on 07.02.2017
# Last modified 07.02.2017
reset

# you can set x range here. The integral also gets calculated based on this range
xstart = 334.5
xend = 341.5

system ('del files.txt')
system ('del labels.txt')
system('for /R %A in (*.csv) do @echo "%~nA" >> labels.txt')
system('for /R %A in (*.csv) do @echo "%A" >> files.txt') 
files = system('more files.txt')
labels = system('more labels.txt')

do for [i=1:20] {
set style line i linewidth 2
}

set xra [xstart:xend]
set term wxt enh 0
set encoding utf8
set xla "Magnetic Field [mT]
set yla "Intensity [a.u.]"
set key notit
set key inside right top vertical Left reverse enhanced autotitles nobox
set key noinvert samplen 4 spacing 1.5 width 0 height 0 
set key maxcolumns 0 maxrows 0
set key noopaque


plot for [i=1:words(files)] word(files,i) u 1:2 w lines ls i tit word(labels,i) noenhanced

set term postscript eps enh color solid font "Arial, 21"
set out "plot_all_csv_files.eps"
rep
set term pdf enh font "Arial, 16"
set out "plot_all_csv_files.pdf"
rep 
set term png enh size 1280,720 font "Arial, 14"
set out "plot_all_csv_files.png"
rep 
set term wxt enh 0
rep

set term wxt enh 1
set xla "Magnetic Field [mT]
set yla "Intensity normalized to area [a.u.]"
maxy_arr = ""
sum_arr = ""
N_arr = ""
sum = 0
do for [i=1:words(files)] {plot word(files, i) us 1:($2)
maxy = GPVAL_DATA_Y_MAX
maxy_arr = sprintf("%s %g",maxy_arr,maxy)}
do for [i=1:words(files)] {sum=0
plot [xstart:xend] word(files, i) us 1:(sum=abs($2)+sum)
sum_arr = sprintf("%s %g",sum_arr,sum)
}
plot for [i=1:words(files)] word(files, i) us 1:($2/(word(sum_arr, i))) w lines ls i tit word(labels, i) noenhanced

set term postscript eps enh color solid font "Arial, 21"
set out "plot_all_csv_files_int.eps"
rep
set term pdf enh font "Arial, 16"
set out "plot_all_csv_files_int.pdf"
rep 
set term png enh size 1280,720 font "Arial, 14"
set out "plot_all_csv_files_int.png"
rep 
set term wxt enh 1
rep

set term wxt enh 2
set xla "Magnetic Field [mT]
set yla "Intensity normalized to max. value [a.u.]"
plot for [i=1:words(files)] word(files, i) us 1:($2/(word(maxy_arr, i))) w lines ls i tit word(labels, i) noenhanced

set term postscript eps enh color solid font "Arial, 21"
set out "plot_all_csv_files_max.eps"
rep
set term pdf enh font "Arial, 16"
set out "plot_all_csv_files_max.pdf"
rep 
set term png enh size 1280,720 font "Arial, 14"
set out "plot_all_csv_files_max.png"
rep 
set term wxt enh 2
rep