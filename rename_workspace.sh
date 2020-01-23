#!/bin/bash

#Todo
#Change the name for each chain that has the old name in it.
killall rofi

focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')

focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";
message=$focused_workspace" (Current workspace)"
new_name=$(rofi -p "Rename workspace" -mesg "$message" -dmenu)
focused_workspace=$(
	swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')

if [[ $new_name ]]; then
	swaymsg "rename workspace $focused_workspace to $new_name"
fi
