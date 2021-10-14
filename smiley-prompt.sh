#!/bin/bash

red="\033[01;31m"
green="\033[01;32m"
light_blue="\033[01;34m"
grey="\033[0;37m"
no_format="\033[00m"
yellow="\033[01;33m"
blue="\033[0;34m"

columns=$(tput cols)
dir=$PWD

user_host="$USER@$HOSTNAME"
date=`date +'%m/%d'`
time=`date +'%H:%M'`

#replace home directory with ~
if [ "$home" == "$dir" ]; then
  dir="~"
elif [ "$home" == "${dir:0:${#home}}" ]; then
  dir="~${dir#$HOME}"
fi

gitstatus=`git status 2> /dev/null`
if [ "$?" -eq "0" ]; then
  gitstatus=${gitstatus#On branch[[:space:]]}
  gitstatus=${gitstatus%%[[:space:]]Your branch*}
  repos_info=${gitstatus/$'\n'*/}
else
  svninfo=`svn info 2> /dev/null`
  if [ "$?" -eq "0" ]; then
    svninfo=${svninfo#*URL: } #get url
    svninfo=${svninfo%%[[:space:]]*} #strip other content
    svninfo=${svninfo/*:\/\//} #remove protocol
    repos_info=${svninfo#*/} #remove hostname
  else
    repos_info=""
  fi
fi

#at this point we have all the data, now it's time to fit it all
#priorities: 
# #1 directory (all or none)
# #2 user/host (all or none)
# #3 repos info (last part)
# #4 time (all or none)
# #5 date (all or none)

#full format
#directory user@host MM/DD hh:mm       [repos/info/right/justified]
#return value? smiley

echo "" #blank line

#directory
if [ $columns -gt ${#dir} ]; then
  echo -en "$light_blue$dir$no_format "
  columns=$((columns-${#dir}-1))
fi

#user/host
if [ $columns -gt ${#user_host} ]; then
  if [ "$USER" == "root" ]; then
    echo -en "$red"
  else
    echo -en "$green"
  fi
  echo -en "$user_host$no_format "
  columns=$((columns-${#user_host}-1))
fi

#date
remaining=$((${#repos_info}+2+${#date}+1+${#time}))
if [ $columns -gt $remaining ]; then
  echo -en "$blue$date$no_format "
  columns=$((columns-6))
fi
remaining=$((remaining-6))

#time
if [ $columns -gt $remaining ]; then
  echo -en "$blue$time$no_format "
  columns=$((columns-6))
fi
remaining=$((remaining-6))

#repos
if [ ${#repos_info} -gt 0 ]; then
  if [ $columns -gt $remaining ]; then
    remaining=$((columns-${#repos_info}-2))
    printf '%*s' "$remaining"
    echo -en "$grey[$repos_info]$no_format"
  else
    trunc=$((${#repos_info}+3-$columns))
    repos_info=${repos_info:$trunc}
    echo -en "$grey[~$repos_info]$no_format"
  fi
fi

echo ""
