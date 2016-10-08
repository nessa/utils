#!/bin/bash
#
# Script to check if our server CPU or memory are overloaded.
# If so, send an email to an specific direction to inform
# about the values and percentages.
#
# To make it work:
# - Install mailutils package
# 
# Add this script as a cron job executed every 5 minutes
# (for example):
# */5 * * * * /path/check_memory.sh
#
# Author: Noelia Sales Montes, noelia.salesmontes<at>gmail.com
# Licensed under GPLv3: 
# https://www.gnu.org/licenses/gpl-3.0.html

THRESHOLD=70

# Email data
EMAIL=email@noreply.org
SUBJECT='Server alert'
MESSAGE=""

# Memory info
CURRENT_MEMORY=$(free -m | awk 'FNR == 2 {print $3}')
TOTAL_MEMORY=$(free -m | awk 'FNR == 2 {print $2}')
MEMORY_PERCENT=$(($CURRENT_MEMORY*100/$TOTAL_MEMORY))

# Calc CPU percentage
# User + System + Nice + Soft + Steal
CPU_PERCENT=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 + $6 + $14 + $16}')


if [ $MEMORY_PERCENT -gt $THRESHOLD ] || [ $CPU_PERCENT -gt $THRESHOLD ]; then

    # Memory overloaded
    if [ $MEMORY_PERCENT -gt $THRESHOLD ]; then     
	MESSAGE="$MESSAGEYour remaining free memory is critically low"
	MESSAGE="$MESSAGE(Used: $CURRENT_MEMORY -"
	MESSAGE="$MESSAGEPercentage: $MEMORY_PERCENT%)."
    fi

    # CPU overloaded
    if [ $CPU_PERCENT -gt $THRESHOLD ]; then     
	MESSAGE="$MESSAGE\nYour CPU is overloaded ($CPU_PERCENT%)."
    fi
    
    echo $MESSAGE | mail -s $SUBJECT $EMAIL
fi
