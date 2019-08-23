#!/bin/bash -e

pushd "$(dirname "$0")" >/dev/null

ecid=`ioreg -l -w0 | grep "USB Serial Number" | grep -m 1 "iBoot-574.4" | sed 's/^.*ECID://' | sed 's/ .*//'`
if [ "x$ecid" = x ]; then
	echo "Can't connect to your iPhone. It needs to be in DFU mode."
	exit 1
fi

killall iTunes iTunesHelper >/dev/null 2>&1 || true
cd tools/ipwndfu
./ipwndfu -p
cd ../../tss_server
./run.sh >/dev/null 2>&1 &
php_pid=$!
sleep 1
popd >/dev/null
set +e
"$(dirname "$0")/tools/idevicerestoreLHTSS" -e "$1"
rm -rf version.xml "`echo "$1" | sed 's/\.ipsw$//'`"
kill -9 $php_pid >/dev/null 2>&1
