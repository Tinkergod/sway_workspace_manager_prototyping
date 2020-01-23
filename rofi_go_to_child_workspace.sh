#!/bin/bash
killall rofi
function join_by { 
	local d=$1; 
	shift; 
	echo -n "$1"; 
	shift; 
	printf "%s" "${@/#/$d}"; 
}

focused_workspace=$(
	swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";

linked_nodes=($(echo -e ${focused_workspace//->/'\n'}))

node_count=${#linked_nodes[@]}

current_chain="$(join_by '->' "${linked_nodes[@]:1:$node_count}")"

message=$current_chain" (Current chain)"

choice="$(~/.local/bin/list_child_workspaces.sh | rofi -dmenu -p "Add or jump to child workspace" -mesg "$message" )"

if [[ $choice ]]; then
	if ((node_count > 1)); then
		swaymsg workspace "$focused_workspace->$choice";
	else
		swaymsg rename workspace "$focused_workspace" to "$focused_workspace->$choice"
		swaymsg workspace "$focused_workspace->$choice";
	fi
fi
