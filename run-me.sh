#!/bin/sh

#
# Need to run this after each reboot since the space on the WR703N flash 
# is limited; hence we are "installing" avrdude only to volatile RAM
#

if [ ! -e /usr/bin/announce ] ; then
  echo "Install the announce package from https://github.com/probonopd/announce first."
  exit 1
fi

killall arduinolisten 2>/dev/null

# Install avrdude
opkg update
opkg -d ram install avrdude
export PATH=/tmp/usr/bin/:$PATH
export LD_LIBRARY_PATH=/tmp/usr/lib/:$LD_LIBRARY_PATH
ln -sf /tmp/etc/avrdude.conf /etc/avrdude.conf

# Announce Arduino service on the network
HOSTNAME=$(uci get system.@system[0].hostname)
L=".local" 
launch() {
  IPS=$(ifconfig | grep "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1)
  for IP in $IPS ; do
    announce $HOSTNAME$L $IP $HOSTNAME $1$L $2 ''$3 >/dev/null 2>&1 &
  done
}
launch "_arduino._tcp" 80 "board=pro"

touch /usr/bin/merge-sketch-with-bootloader.lua
chmod a+x /usr/bin/merge-sketch-with-bootloader.lua


cat > /usr/bin/run-avrdude <<\EOF
#!/bin/sh

killall arduinolisten 2>/dev/null

export PATH=/tmp/usr/bin/:$PATH
export LD_LIBRARY_PATH=/tmp/usr/lib/:$LD_LIBRARY_PATH

# GPIO 29 is on "pin" R17-S (south end of resistor 17)
# This is connected to the Arudino reset pin, hence we need to change it from "grounded" to "isolated"
# so that the Arduino can start running
echo 29 > /sys/class/gpio/export 2>/dev/null
echo out > /sys/class/gpio/gpio29/direction
echo 1 > /sys/class/gpio/gpio29/value # isolated

# Reset using "pin" R17-S (south end of resistor 17)
echo 0 > /sys/class/gpio/gpio29/value # grounded
sleep 1 # Is needed to make it reliable
echo 1 > /sys/class/gpio/gpio29/value # isolated

avrdude -V -p m328p -c arduino -b 57600 -P /dev/ttyATH0 -C /etc/avrdude.conf -U flash:w:$1 $2
EOF
chmod a+x /usr/bin/run-avrdude
