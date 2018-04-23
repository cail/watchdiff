# watchdiff

watchdiff is a handy perl script to watch numeric differences in periodically running output of its command line.

Its somewhat similar to `watch -d` but instead of just printing the output, it printsout all numbers "differences".

Example is

<pre>
~/watchdiff 1 "ifconfig enp1s0f1 | grep packets"

ifconfig enp1s0f1 | grep packets
INCONSISTENT
          RX packets:4066342529 errors:0 dropped:0 overruns:0 frame:0
          TX packets:14323464927 errors:0 dropped:0 overruns:0 carrier:0

          RX packets:<<b>154,935</b>> errors:0 dropped:0 overruns:0 frame:0
          TX packets:<<b>156,114</b>> errors:0 dropped:0 overruns:0 carrier:0

          RX packets:<<b>154,668</b>> errors:0 dropped:0 overruns:0 frame:0
          TX packets:<<b>156,154</b>> errors:0 dropped:0 overruns:0 carrier:0
</pre>

This essentially shows dynamic packet per second rates on the adapter.

# Author

https://github.com/cail/

# License

BSD

# URL

https://github.com/cail/watchdiff
