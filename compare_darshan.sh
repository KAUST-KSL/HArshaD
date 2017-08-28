# Compare Darshan part of HArshaD suite
# George Markomanolis
# KAUST Supercomputing Laboratory

# Usage:
# To compare the Darshan data for two job ids, execute ./compare_darshan.sh job_id1 job_id2
# Declare the darshan path where the logs are saved in the darshan_path variable
# Dependency: pdfjam

#!/bin/bash 


darshan_ver=`module avail --long 2>&1 | grep darshan | grep default | awk -F "[/ .]" '{print $2}'`
name=`hostname`

if [[ $name == *"cori"* ]]; then 

export darshan_path="/global/cscratch1/sd/darshanlogs/"
module load latex

elif [[ $name == *"cdl"* ]]; then  
export darshan_path="/project/logs/darshan/"

fi


file1=`ls -ltr $darshan_path/*/*/*/$USER*"_id"$1* | tail -n 1 |  awk '{print $9}'`
file2=`ls -ltr $darshan_path/*/*/*/$USER*"_id"$2* | tail -n 1 |  awk '{print $9}'`

echo "Used Darshan files:"
echo "1) "$file1
echo -e "2) "$file2"\n"

darshan-job-summary.pl $file1
darshan-job-summary.pl $file2

darshan-parser $file1 > temp_parser_$1
darshan-parser $file2 > temp_parser_$2



if [ $darshan_ver -eq 2 ]; then

execu=`cat temp_parser_$1 | grep exe | awk '{print $(NF-2)}' | awk 'BEGIN{FS="/"} {print $NF}'`
day_run1=`cat temp_parser_$1 | grep end_time_asci | awk '{print $5}'`
year_run1=`cat temp_parser_$1 | grep end_time_asci | awk '{print $7}'`
month_run1=`cat temp_parser_$1 | grep end_time_asci | awk '{print $4}'`
day_run2=`cat temp_parser_$2 | grep end_time_asci | awk '{print $5}'`
year_run2=`cat temp_parser_$2 | grep end_time_asci | awk '{print $7}'`
month_run2=`cat temp_parser_$2 | grep end_time_asci | awk '{print $4}'`
pdf_fil=`echo $file | awk 'BEGIN{FS="/"} {print $NF}' | sed 's/darshan.gz/pdf/'`

elif [ $darshan_ver -eq 3 ]; then
execu=`cat temp_parser_$1 | grep exe | awk 'BEGIN{FS="[/ ]"} {print $(NF-1)}'`
day_run1=`cat temp_parser_$1 | grep end_time_asci | awk '{print $5}'`
year_run1=`cat temp_parser_$1 | grep end_time_asci | awk '{print $7}'`
month_run1=`cat temp_parser_$1 | grep end_time_asci | awk '{print $4}'`
day_run2=`cat temp_parser_$2 | grep end_time_asci | awk '{print $5}'`
year_run2=`cat temp_parser_$2 | grep end_time_asci | awk '{print $7}'`
month_run2=`cat temp_parser_$2 | grep end_time_asci | awk '{print $4}'`
pdf_file=`echo $file | awk 'BEGIN{FS="/"} {print $NF}' | sed 's/darshan/darshan.pdf/'`

fi


month_run1_2=`date -d "1 $month_run1" "+%m"`
month_run2_2=`date -d "1 $month_run2" "+%m"`

pdf_file1=`echo $file1 | awk 'BEGIN{FS="/"} {print $NF}' | sed 's/darshan/darshan.pdf/'`
pdf_file2=`echo $file2 | awk 'BEGIN{FS="/"} {print $NF}' | sed 's/darshan/darshan.pdf/'`

pdfjam $pdf_file1 '1' $pdf_file2 '1' --nup 2x1 --landscape --outfile file1.pdf
pdfjam $pdf_file1 '2' $pdf_file2 '2' --nup 2x1 --landscape --outfile file2.pdf
pdfjam $pdf_file1 '3' $pdf_file2 '3' --nup 2x1 --landscape --outfile file3.pdf

if [ $darshan_ver -eq 3 ]; then
pdfjam $pdf_file1 '4' $pdf_file2 '4' --nup 2x1 --landscape --outfile file4.pdf

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=compare_darshan_$1_$2.pdf file1.pdf file2.pdf file3.pdf file4.pdf
rm file1.pdf file2.pdf file3.pdf file4.pdf

else
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=compare_darshan_$1_$2.pdf file1.pdf file2.pdf file3.pdf 
rm file1.pdf file2.pdf file3.pdf

fi
mkdir -p experiments/comparison/$execu/${year_run1}_${year_run2}/${month_run1_2}_${month_run2_2}/${day_run1}_${day_run2}/
mv compare_darshan_$1_$2.pdf experiments/comparison/$execu/${year_run1}_${year_run2}/${month_run1_2}_${month_run2_2}/${day_run1}_${day_run2}/

#mv temp_parser_$1 experiments/comparison/$execu/${year_run1}_${year_run2}/${month_run1_2}_${month_run2_2}/${day_run1}_${day_run2}/
#mv temp_parser_$2 experiments/comparison/$execu/${year_run1}_${year_run2}/${month_run1_2}_${month_run2_2}/${day_run1}_${day_run2}/


evince experiments/comparison/$execu/${year_run1}_${year_run2}/${month_run1_2}_${month_run2_2}/${day_run1}_${day_run2}/compare_darshan_$1_$2.pdf &

