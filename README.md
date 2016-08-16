# Children's alarm clock

This script runs on my Raspberry Pi, which is connected to a 7" touchscreen. As I leave the room after having said goodnight to my kid, I start the script (in night mode) which displays an image on the screen indicating it's daystime. After a few minutes, the image is replaced by another one indicating that it's night time, and that the it's time to go to sleep. The script is triggered by double clicking an icon on the touchscreen. 

In the morning, the script dislays the daytime image. The script is triggered by a simple cron job. 

## Setup

### The script itself

Put the script somewhere in the file system, for example /home/pi/scripts/alarmclock. 

### Raspbian icon

Enable trigging the script by double clicking an icon on the touchscreen, but adding a file such as this:
```
pi@raspberrypi:~ $ cat ~/Desktop/goodnight.desktop
[Desktop Entry]
Name=Nighttime
Comment=Some comment
Icon=/usr/share/pixmaps/openbox.xpm
Exec=/bin/bash /home/pi/scripts/alarmclock/alarmclock.sh 10 90
Type=Application
Encoding=UTF-8
Terminal=false
Categories=None;
```

### Crontab

Create a crontab entry to start the script in the morning:
```
15 06 * * * /bin/bash /home/pi/scripts/alarmclock/alarmclock.sh 90
```

### Touchscreen 

You might want to reduce the touch sensitivity on the touchscreen, if you find it difficult to start the script by double clicking the icon. 


