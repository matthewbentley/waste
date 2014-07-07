waste
=====

Waste bandwidth over SSH

Info
----
This script exists solely to waste download bandwidth (and thus NSA storage
space) over ssh. It starts listening with nc on port 2020, and simultaneously
connects to a remote server and pipes random data over the ssh connection

USAGE:

        waste.sh [-P] [-p port] [-f] <remote host>
        -P       pipe the output through pv, to watch it real-time (doesn't seem to work yet)
        -f       use /dev/frandom on remote host
        -p port  a different port

        <remote host> should be sufficiently far away that the NSA has a
        chance to record and store all the (encrypted) random data before it
        reaches its destination. You should also be a frequent Linux Journal
        reader and Tor user to ensure the NSA is keeping a backup of all your
        web traffic (especially the encrypted stuff). It probably won't hurt
        to also throw in a few anti-government Tweets and plain-text emails.

ISSUES:

        - -P does not work
        - Only does server -> client (download), but could also do
          client -> server (upload).
        - No rate-limiting: it may very well saturate your downlink.
        - Requires a remote server. A future version could use DHT to find
          other willing participants, and encrypt with OpenSSL before
          transmitting raw with nc rather than using SSH.
