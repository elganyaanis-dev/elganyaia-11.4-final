#!/bin/bash
cd $HOME/kamina-control
pkill -f "keyboard_interface" 2>/dev/null
node keyboard_interface_fixed.js
