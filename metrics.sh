#!/usr/bin/env bash
#set -x
ruleid=$1

get_repair_task_ids ()
{
taskids=(`grep StartRepairRequest *.log | grep $ruleid | awk -F "taskId=" '{print $2}' | awk -F "}" '{print $1}' | sort -u`)
}
print_taskids () {
  for utask in ${taskids[@]}; do
    echo $utask
  done
}

get_metrics () {

grep $utask *.log | awk -F ".log:" '{print $2}' > $utask.txt
taskStartDate=`grep "StartRepairRequest" $utask.txt | head -1 | awk '{print $1}'`
taskStartSec=$(date -u -d "$taskStartDate" +"%s")
taskEndDate=`grep "RepairTaskState=FINISHED" $utask.txt | grep received | grep "adls-gen2-prdbkp-zone" | awk '{print $1}'`
noDirs=`grep noDirs $utask.txt | awk -F "noDirs:" '{print $2}' | awk '{print $1}' | sed 's:,::' | head -1`
noFiles=`grep noDirs $utask.txt | awk -F "noDirs:" '{print $2}' | awk '{print $3}' | sed 's:,::'| head -1`
fails=`grep "failed with non retriable exception" $utask.txt | wc -l`
nofounds=`grep "The specified path does not exist" $utask.txt | wc -l`
stillmissing=`grep "is still missing after repair" $utask.txt | wc -l`

if [ -z "$taskEndDate" ];
then
taskEndDate="NO_DATA"
taskEndSec="NO_DATA"
taskDuration="NO_DATA"
scanDuration="NO_DATA"
taskDurationPretty="NO_DATA"
scanDurationPretty="NO_DATA"
else
taskEndSec=$(date -u -d "$taskEndDate" +"%s")
taskDurationSec=$(expr $taskEndSec - $taskStartSec)
taskDurationPretty=`printf '%dh:%dm:%ds\n' $((taskDurationSec/3600)) $((taskDurationSec%3600/60)) $((taskDurationSec%60))`
scanEndSec=$(date -u -d "$scanEndDate" +"%s")
scanDurationSec=$(expr $scanEndSec - $taskStartSec)
scanDurationPretty=`printf '%dh:%dm:%ds\n' $((scanDurationSec/3600)) $((scanDurationSec%3600/60)) $((scanDurationSec%60))`
fi
}

reset_metrics (){
taskStartDate=0
taskStartSec=0
taskEndDate="NO_END"
taskEndSec="NO_END"
scanEndDate=0
scanEndDay=0
scanEndSec=0
scanDuration=0
taskDuration=0
}

header () {
echo "ruleid utask taskStartDate taskEndDate taskDurationPretty noDirs noFiles fails nofounds stillmissing"
}
record_metrics () {
# Start End task rule
echo "$ruleid $utask $taskStartDate $taskEndDate $taskDurationPretty $noDirs $noFiles $fails $nofounds $stillmissing"
}

get_repair_task_ids
print_taskids
reset_metrics
header
for utask in ${taskids[@]}; do
    get_metrics
    record_metrics
    reset_metrics
  done


