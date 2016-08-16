#!/bin/bash
awake_time=$1
sleep_time=$2
pictures_root="/home/pi/Pictures"

function show {
  folder=$1
  delay_in_seconds=$2
  delay_in_minutes=$(($delay_in_seconds * 60))
  command="$XPREFIX /usr/bin/feh --quiet --preload --fullscreen --hide-pointer --cycle-once --slideshow-delay $delay_in_minutes $pictures_root/$folder"
  logger "Executing this command: $command"
  eval $command
}

if [ -z "$sleep_time" ]; then
  mode="morning"
else 
  mode="evening"
fi
 
run_env=${DISPLAY-shell}
if [ "$run_env" == "shell" ]; then
  logger "Running from shell"
  XPREFIX="DISPLAY=:0.0 XAUTHORITY=/home/pi/.Xauthority"
else
  logger "Running from GUI"
  XPREFIX=""
fi 

function run_command {
  command="$XPREFIX $@"
  logger "Running command: $command"
  eval $command
}

if [ "$mode" == "morning" ]; then
  logger "Running in morning mode with awake time $awake_time"
else
  logger "Running in evening mode with awake time $awake_time and sleep time $sleep_time"
fi

run_command "xset s off"
run_command "xset -dpms"
run_command "xset s noblank"

date=`date`
logger "$date Awake..."
show "awake" "$awake_time"

if [ "$mode" == "evening" ]; then
  date=`date`
  logger "$date Sleeping..."
  show "sleeping" "$sleep_time"
fi

logger "Re-enabling screen blank"
run_command "xset s on"
run_command "xset +dpms"
run_command "xset s blank"
run_command "xset s activate"

date=`date`
logger "$date Done!"

