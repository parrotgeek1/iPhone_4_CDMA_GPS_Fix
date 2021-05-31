Important Notice
================
Development of the iPhone 4 CDMA GPS fix is now discontinued. The only changes which *might* be made to it would be those necessary to make it function on newer macOS versions; such compatibility will not be added if it imposes a significant maintenance burden.

What is this?
=============
This is an unofficial update for the CDMA iPhone 4 (iPhone3,3), which installs the new baseband included in the CDMA iPad 2's iOS 9.3.6 update. 
This fixes the GPS bug which caused the CDMA iPhone 4 to stop keeping correct time after November 3, 2019 00:00 UTC.

NOTE: The GSM iPhone 4 and all older devices are not affected by this bug, 

Limitations
===========
Only for Mac!

How to install the new baseband
===============================
1) Creating the patched IPSW

Run ./make_ipsw.sh <iOS_7.1.2_IPSW> 

2) Restoring the firmware

Connect your iPhone 4 and put it in DFU mode.

Run ./restore.sh <Patched_IPSW>

Wait for that to complete.

When your phone reboots, it will have the new baseband.

Credits
=======
s0uthwest, libimobiledevice, and @tihmstar for idevicerestore


@axi0mx for ipwndfu

@tihmstar for partialZipBrowser

xerub and iPhone Dev Team for xpwn and firmware bundle

@sequinn and @parrotgeek1 for root_tar
