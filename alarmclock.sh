#!/bin/bash
awake_time=$1
sleep_time=$2
pictures_root="/home/pi/Pictures"

# Usage: 
#  * Set night time mode by passing two parameters. The first being the number of minutes to display the first picture, 
#    and the second being the number of minutes to display the second picture before turning off the screen. 
#    Example: 
#        PUSHOVER_APP_TOKEN=secret PUSHOVER_USER_TOKEN=shh /bin/bash /home/pi/scripts/armclock/alarmclock.sh 10 90
#    In the desktop file, e.g. ~/Desktop/nighttime.desktop, wrap the above command like this: 
#        Exec=sh -c "PUSHOVER_APP_TOKEN=secret PUSHOVER_USER_TOKEN=shh /bin/bash /home/pi/scripts/armclock/alarmclock.sh 10 90"
#  * Set morning time mode by passing a singe parameter that denotes the number of minutes to display the picture before turning the
#    screen off. 
#    Example: 
#        PUSHOVER_APP_TOKEN=secret PUSHOVER_USER_TOKEN=shh /bin/bash /home/pi/scripts/armclock/alarmclock.sh 60
   
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

run_command "sudo sh -c 'echo 50 > /sys/class/backlight/rpi_backlight/brightness'"
run_command "xset s off"
run_command "xset -dpms"
run_command "xset s noblank"

date=`date`
logger "$date Awake..."
show "awake" "$awake_time"

if [ "$mode" == "evening" ]; then
  
  # Send a notification the the parents mobile phone, using Pushover
  message="Tuck in the baby"
  run_command "curl -s --form-string \"token=$PUSHOVER_APP_TOKEN\" --form-string \"user=$PUSHOVER_USER_TOKEN\" --form-string \"message=$message\" https://api.pushover.net/1/messages.json"
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

