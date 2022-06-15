# Fusion Repair Metrics Script
A bash script to parse Fusion server logs for metrics on batch repairs to ADLS gen 2.
The script will take a ruleid and look for all repairs for this rule in the logs.
It will list each repair task individually for the rule and the repair task metrics.

### Versions.
Fusion: fusion-hcfs-azure-hdi-4.0-server-2.15.2.1

### Instructions.
Copy the script and fully uncompressed 'fusion-server.log' logs to a directory and run as a bash script.


### Arguments.
The Fusion rule id. Which can be found from the UI or the API endpoint. (/fusion/fs/paths)

### Usage.
```
./metrics.sh <ruleid>
```

Example. 
```
./metrics3.sh 5f8740bb-d154-11ec-a9a6-000d3ae36e08
```

### Output
The script will output data in the following formatting. This header is also printed. 

| ruleid | utask | taskStartDate | taskEndDate | taskDurationPretty | noDirs | noFiles | fails | nofounds | stillmissing |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

### Explanation of headers. 

**ruleid**: The rule id used in the script run.

**utask**: The unique repair task id.

**taskStartDate**: The date when the repair action was requested.

**taskEndDate**: The final date when the repair was marked by Fusion as Finished.

**taskDurationPretty**: Full duration of the repair in hours mins and seconds.

**noDirs**: Number of directories reported in this repair.

**noFiles**: Number of files reported in this repair.

**fails**: Number of 'failed with non retriable exception' entries reported for this task.

**nofounds**: Number of 'The specified path does not exist' entries reported for this task.

**stillmissing**: Number of 'is still missing after repair' entries reported for this task.

### Notes.
- The output list of tasks is not in date order. (You can sort them in excel if needed for a report)
- Output is **space** delimited.
- Does not work with tar files.
- Does not work with gzip files.