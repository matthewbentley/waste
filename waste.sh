#!/bin/sh

# This script exists solely to waste download bandwidth (and thus NSA storage
# space) over ssh. It starts listening with nc on port 2020, and simultaneously
# connects to a remote server and pipes random data over the ssh connection

# USAGE: waste.sh [-P] [-p port] [-f] <remote host>
#        -P       pipe the output through pv, to watch it real-time (doesn't seem to work yet)
#        -f       use /dev/frandom on remote host
#        -p port  a different port
#
#        <remote host> should be sufficiently far away that the NSA has a
#        chance to record and store all the (encrypted) random data before it
#        reaches its destination. You should also be a frequent Linux Journal
#        reader and Tor user to ensure the NSA is keeping a backup of all your
#        web traffic (especially the encrypted stuff). It probably won't hurt
#        to also throw in a few anti-government Tweets and plain-text emails.

# ISSUES: - Currently limited by the speed of /dev/urandom.
#         - Only does server -> client (download), but could also do
#           client -> server (upload).
#         - No rate-limiting: it may very well saturate your downlink.
#         - Requires a remote server. A future version could use DHT to find
#           other willing participants, and encrypt with OpenSSL before
#           transmitting raw with nc rather than using SSH.

mid_process="nc -n 127.0.0.1"
rand_gen="/dev/urandom"
port="2020"

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            shift
            echo "# USAGE: waste.sh [-P] [-p port] [-f] <remote host>"
            echo "#        -P       pipe the output through pv, to watch it real-time (doesn't seem to work yet)"
            echo "#        -f       use /dev/frandom on remote host"
            echo "#        -p port  a different port"
            exit 0
            ;;
        -P|--pv)
            shift
            mid_process="pv | nc -n 127.0.0.1"
            ;;
        -f|--frandom)
            shift
            rand_gen="/dev/frandom"
            ;;
        -p|--port)
            shift
            if test $1 -gt 0; then
                export port=$1
            else
                echo "-p must be followed by a positive integer for the port"
                exit 1
            fi
            shift
            ;;
        *)
            host=$1
            shift
    esac
done


c1="nc -l -p ${port}"
c2="ssh -R ${port}:localhost:${port} ${host} cat ${rand_gen} | ${mid_process} ${port}"

`$c1` > /dev/null &

`$c2`
