#Open Darshan part of HArshaD suite
#George Markomanolis
#KAUST Supercomputing Laboratory

#Usage:
#1) To load your last experiment on the same day, execute ./open_darshan.sh
#2) To load darshan data from specific job, execute ./open_darshan.sh job_id
# Declare the darshan path where the logs are saved in the darshan_path variable

#!/bin/bash -x

darshan_ver=`module avail --long 2>&1 | grep darshan/ | tail -n 1 | awk -F "[/ .]" '{print $2}'`
name=`hostname`

if [[ $name == *"cori"* ]]; then

export darshan_path="/global/cscratch1/sd/darshanlogs/"
module load latex

elif [[ $name == *"cdl"* ]]; then 
export darshan_path="/project/logs/darshan/"
module load texlive/2017
fi

if [ $# -eq 0 ]; then

year=`date +"%Y"`
month=`date +"%-m"`
day=`date +"%-d"`


file=`ls -ltr $darshan_path/$year/$month/$day/$USER* | tail -n 1 |  awk '{print $9}'`

else
file=`ls -ltr $darshan_path/*/*/*/$USER*"_id"$1* | tail -n 1 |  awk '{print $9}'`

fi

echo "Used Darshan file:"
echo $file

darshan-job-summary.pl $file
darshan-parser $file > temp_parser

if [ $darshan_ver -eq 2 ]; then
execu=`cat temp_parser | grep exe | awk '{print $(NF-2)}' | awk 'BEGIN{FS="/"} {print $NF}'`
day_run=`cat temp_parser | grep end_time_asci | awk '{print $5}'`
year_run=`cat temp_parser | grep end_time_asci | awk '{print $7}'`
month_run=`cat temp_parser | grep end_time_asci | awk '{print $4}'`

pdf_file=`echo $file | awk 'BEGIN{FS="/"} {print $NF}' | sed 's/darshan.gz/pdf/'`

elif [ $darshan_ver -eq 3 ]; then
execu=`cat temp_parser | grep exe | awk 'BEGIN{FS="[/ ]"} {print $(NF-1)}'`
day_run=`cat temp_parser | grep end_time_asci | awk '{print $5}'`
year_run=`cat temp_parser | grep end_time_asci | awk '{print $7}'`
month_run=`cat temp_parser | grep end_time_asci | awk '{print $4}'`
pdf_file=`echo $file | awk 'BEGIN{FS="/"} {print $NF}' | sed 's/darshan/darshan.pdf/'`

fi

month_run2=`date -d "1 $month_run" "+%m"`
echo experiments/$execu/$year_run/$month_run2/$day_run/
mkdir -p experiments/$execu/$year_run/$month_run2/$day_run/
mv $pdf_file experiments/$execu/$year_run/$month_run2/$day_run/
#mv temp_parser experiments/$execu/$year_run/$month_run2/$day_run/

evince experiments/$execu/$year_run/$month_run2/$day_run/$pdf_file &
