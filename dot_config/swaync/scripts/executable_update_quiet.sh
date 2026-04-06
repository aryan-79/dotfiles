#!/bin/sh

if powerprofilesctl get | grep -q "balanced"; then
  echo true
else
  echo false
fi
