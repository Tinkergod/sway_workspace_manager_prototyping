#!/bin/bash

killall rofi
focused_workspace="$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')"
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";

message=$focused_workspace" (Current workspace)"
choice="$(~/.local/bin/list_all_workspaces.sh | rofi -mesg "$message" -p "Add or jump to workspace" -dmenu)"

if [[ $choice ]]; then
	swaymsg workspace "$choice";
fi
