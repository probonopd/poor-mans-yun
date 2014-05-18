poor-mans-yun
=============
Arduino Yun functionality using a $20 WR703N router and a $3 Arduino Pro Mini.

This allows you to upload sketches to the Arduino Pro Mini over Ethernet or WLAN from the Arduino IDE, just like with the Arduino Yun.

Materials used
--------------
 * WR703N router (do NOT use WR702N) from eBay or Aliexpress, around $20 shipped
 * $3 Arduino Pro Mini from eBay, around $3 shipped
 
Soldering
--------------
 * Solder Arduino pin VCC to WR703N +3.3V
 * Solder Arduino pin GND to WR703N Ground
 * Solder Arduino pin RST to WR703N GPIO 29 signal = R17-South
 * Solder Arduino pin RX to WR703N TP_OUT signal = C55-West
 * Solder Arduino pin TX to WR703N TP_IN signal = R82-North
For information on the WR703N pins, see http://wiki.openwrt.org/toh/tp-link/tl-wr703n#gpios

Preparing Arduino IDE
---------------------
Edit boards.txt so that it contains the following line:
````
pro.upload.via_ssh=true
```
Preparing WR703N
----------------
Install OpenWrt on the WR703N. Then install the "announce" package and finally run the script from this repository on the WR703N.
