#!/bin/bash

wx=$(curl -4 wttr.in/~Orlando?1QT 2>/dev/null)
rainfall=$(echo $wx | grep -Eao '[[:digit:]]{1,2}\.[[:digit:]]{1,2} in \|')
rainchance=$(echo $wx | grep -Eao ' [[:digit:]]{1,2}%')

echo $rainfall
echo $rainchance

exit 0


