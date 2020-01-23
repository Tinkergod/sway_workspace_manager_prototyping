#!/bin/bash
focused_workspace=$(
	swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')

linked_workspaces=($(echo -e "${focused_workspace//->/'\n'}"))

parent="";
if ((${#linked_workspaces[@]} == 1)); then
	parent+=${linked_workspaces[0]};
else
	for ((i=0; i<((${#linked_workspaces[@]}-1));i++)); do

		if (( i == ((${#linked_workspaces[@]}-2)) )); then
			parent+=${linked_workspaces[$i]};
		elif (( ((${#linked_workspaces[@]}-1)) > 1 )); then
			parent+=${linked_workspaces[$i]}"->";

		fi
	done
		fi

swaymsg workspace "$parent";
