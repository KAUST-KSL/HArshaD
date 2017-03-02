#Open Darshan part of HArshaD suite
#George Markomanolis
#KAUST Supercomputing Laboratory

#Usage:
#1) To load your last experiment on the same day, execute ./open_darshan.sh
#2) To load darshan data from specific job, execute ./open_darshan.sh job_id
# Declare the darshan path where the logs are saved in the darshan_path variable

#!/bin/bash

export darshan_path="/project/logs/darshan/"

if [ $# -eq 0 ]; then

year=`date +"%Y"`
month=`date +"%-m"`
day=`date +"%-d"`


file=`ls -ltr $darshan_path/$year/$month/$day/$USER* | tail -n 1 |  awk '{print $9}'`

else
file=`ls -ltr $darshan_path/*/*/*/$USER*"_id"$1* | tail -n 1 |  awk '{print $9}'`

fi

echo "Used Darshan file:"
echo $file"\n"

darshan-job-summary.pl $file
darshan-parser $file > temp_parser

execu=`cat temp_parser | grep exe | awk '{print $(NF-2)}' | awk 'BEGIN{FS="/"} {print $NF}'`
day_run=`cat temp_parser | grep end_time_asci | awk '{print $5}'`
year_run=`cat temp_parser | grep end_time_asci | awk '{print $7}'`
month_run=`cat temp_parser | grep end_time_asci | awk '{print $4}'`

month_run2=`date -d "1 $month_run" "+%m"`

pdf_file=`echo $file | awk 'BEGIN{FS="/"} {print $NF}' | sed 's/darshan.gz/pdf/'`
mkdir -p experiments/$execu/$year_run/$month_run2/$day_run/
mv $pdf_file experiments/$execu/$year_run/$month_run2/$day_run/
mv temp_parser experiments/$execu/$year_run/$month_run2/$day_run/

evince experiments/$execu/$year_run/$month_run2/$day_run/$pdf_file &
