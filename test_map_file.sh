#!/bin/bash

killall rofi
function join_by { 
	local d=$1; 
	shift; 
	echo -n "$1"; 
	shift; 
	printf "%s" "${@/#/$d}"; 
}
#split tag

focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')

focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";
linked_nodes=("$(echo -e "${focused_workspace//->/'\n'}")")
node_count=${#linked_nodes[@]}
focused_last_node=${linked_nodes[-1]}

parent_workspace=$(join_by '->' "${linked_nodes[@]:0:($node_count-1)}")
neighbors_array=();
neighbors="";
if [[ $node_count -gt 1 ]]; then
	all_workspaces=("$(swaymsg -t get_workspaces | jq '.[] | .name')")

	for ((i=0; i<${#all_workspaces[@]}; i++)); do
		if [[ ${all_workspaces[$i]} =~ $parent_workspace ]]; then
			unsplit_chain=${all_workspaces[$i]}
			unsplit_chain="${unsplit_chain%\"}"
			unsplit_chain="${unsplit_chain#\"}"
			chain=("$(echo -e "${unsplit_chain//->/'\n'}")")
			if [[ ${#chain[@]} -eq $node_count ]]; then
				if [[ ${chain[-1]} != "$focused_last_node" ]]; then
					neighbors_array+=("${chain[-1]}")
				fi
			fi
		fi
	done
	neighbors=$(join_by '\n' "${neighbors_array[@]}");
	current_chain=$(join_by '->' "${linked_nodes[@]:1:($node_count)}")
	echo "$current_chain"

	message+=$current_chain" (Current chain)"
	selection=$(echo -e "$neighbors" | rofi -dmenu -p "Add or jump to neighbor" -mesg "$message");
	if [[ $selection ]]; then
		swaymsg workspace "$parent_workspace->$selection"
	fi
fi


