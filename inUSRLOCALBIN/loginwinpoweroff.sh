#!/bin/bash
/usr/bin/who | /usr/bin/awk '{ print $2 }'| grep console || sleep 1800 && /usr/bin/who | /usr/bin/awk '{ print $2 }'| grep console || /usr/local/bin/lwp_serv.sh