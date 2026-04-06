#!/bin/sh

if ! powerprofilesctl get | grep -q "balanced"; then
  notify-send "Setting balanced mode..." powerprofilesctl -i battery-profile-powersave -a powerprofilesctl
  powerprofilesctl set balanced
else
  notify-send "Setting performance mode..." powerprofilesctl -i battery-profile-balanced -a powerprofilesctl
  powerprofilesctl set performance
fi
