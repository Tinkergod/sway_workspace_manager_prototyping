#!/bin/bash
#Todos
#check for uniqueness

focused_workspace=$(swaymsg -t get_workspaces | jq ".[] | select(.focused==true) | .name")
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";

workspace_names=$(swaymsg -t get_workspaces | jq ".[] | .name");

workspaces=($workspace_names)

root_node_names=();
for element in "${workspaces[@]}";do
	chain_of_nodes=($(echo -e "${element//->/'\n'}"))

	if (( ${#chain_of_nodes[@]} == 1 )); then	
		name=${chain_of_nodes[0]}
		name="${name%\"}";
		name="${name#\"}";
		root_node_names+=("$name");
	fi
done

output=""
for ((i=0; i < ${#root_node_names[@]}; i++)); do
	if [[ ${root_node_names[$i]} ]]; then
		if [[ ${root_node_names[$i]} != "$focused_workspace" ]]; then
			output+=${root_node_names[$i]}"\n"
		fi
	fi
done

if [[ $output ]]; then
	echo -e -n "$output"
fi
