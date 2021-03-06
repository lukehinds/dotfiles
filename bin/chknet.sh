#!/bin/bash

green="\x1b[32m"
red="\x1b[31m"
reset="\x1b[m"

ON="$green ON $reset"
OFF="$red OFF $reset"

if (ping -W 2 -c 1 192.168.0.1 &>/dev/null) then
    echo -e "LAN:\t$ON"
else 
    echo -e "LAN:\t$OFF"
fi

if (ping -W 2 -c 1 8.8.8.8 &>/dev/null) then
    echo -e "WAN:\t$ON"
else 
    echo -e "WAN:\t$OFF"
fi

if (ping -W 2 -c 1 www.google.com &>/dev/null) then
    echo -e "DNS:\t$ON"
else
    echo -e "DNS:\t$OFF"
fi
